use crate::{
    database::auth::OperationStatus,
    security::{Encryption, Jwt},
    utils::error::UserErrors::{UserExists, WrongCredentials},
    utils::Error,
    AppState,
};
use actix_web::{post, web, HttpResponse, Responder};
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
struct LoginRequest {
    username: String,
    password: String,
}

#[derive(Deserialize, Debug)]
struct RegisterRequest {
    username: String,
    password: String,
    email: Option<String>,
    phone_number: Option<String>,
}

#[post("/register")]
pub async fn register(data: web::Data<AppState>, request: web::Json<RegisterRequest>) -> Result<impl Responder, Error> {
    let username = &request.username;
    let password = &Encryption::encrypt_with_argon2(&request.password)?;
    let email = &request.email;
    let phone_number = &request.phone_number;

    let outcome = data
        .database_connection
        .register(username, password, email.as_deref(), phone_number.as_deref())
        .await?;

    match outcome {
        OperationStatus::Success => {
            let user = data.database_connection.get_user_by_username(username).await?.unwrap();

            return Ok(HttpResponse::Ok().body(
                json!({
                    "status": "success",
                    "body": {
                        "accessToken": Jwt::create_access_token(user.user_id, &user.role),
                        "refreshToken": Jwt::create_refresh_token(user.user_id, &user.role)
                    }
                })
                .to_string(),
            ));
        }
        OperationStatus::UserExists => return Err(Error::UserError(UserExists)),
    };
}

#[post("/login")]
pub async fn login(data: web::Data<AppState>, request: web::Json<LoginRequest>) -> Result<impl Responder, Error> {
    let username = &request.username;
    let password = &request.password;

    let maybe_user = data.database_connection.get_user_by_username(username).await?;

    if maybe_user == None {
        return Err(Error::UserError(WrongCredentials));
    }

    let user = maybe_user.unwrap();

    if !Encryption::verify_password(password, &user.password_hash)? {
        return Err(Error::UserError(WrongCredentials));
    }

    let response = json!({
        "status": "success",
        "body": {
            "accessToken": Jwt::create_access_token(user.user_id, &user.role),
            "refreshToken": Jwt::create_refresh_token(user.user_id, &user.role)
        }
    })
    .to_string();

    Ok(HttpResponse::Ok().body(response))
}
