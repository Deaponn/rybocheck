use crate::{
    database::auth::OperationStatus,
    security::{Encryption, Jwt},
    utils::{
        Error::UserError,
        error::UserErrors::{BadRequest, UserExists, WrongCredentials},
        Error,
    },
    AppState,
};
use actix_web::{post, web, HttpResponse, Responder};
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
struct RegisterRequest {
    username: String,
    password: String,
    email: Option<String>,
    phone_number: Option<String>,
}

#[derive(Deserialize, Debug)]
struct LoginRequest {
    username: String,
    password: String,
}

#[derive(Deserialize, Debug)]
struct RefreshRequest {
    refresh_token: String,
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

// TODO: make old refresh_token invalid, use proper Error::UserError::BadRequest
#[post("/refresh")]
pub async fn refresh(_data: web::Data<AppState>, request: web::Json<RefreshRequest>) -> Result<impl Responder, Error> {
    let refresh_token = &request.refresh_token;

    let is_valid = Jwt::check_if_valid((*refresh_token).clone())?;

    if !is_valid {
        return Err(Error::UserError(WrongCredentials));
    }

    let access_token = Jwt::access_from_refresh((*refresh_token).clone());

    if access_token == None {
        return Err(UserError(BadRequest));
    }

    let response = json!({
        "status": "success",
        "body": {
            "accessToken": access_token.unwrap(),
            "refreshToken": refresh_token
        }
    })
    .to_string();

    Ok(HttpResponse::Ok().body(response))
}
