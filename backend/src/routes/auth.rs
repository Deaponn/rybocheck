use crate::{
    database::auth::OperationStatus,
    security::{Encryption, Jwt},
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
pub async fn register((data, request): (web::Data<AppState>, web::Json<RegisterRequest>)) -> impl Responder {
    let username = &request.username;
    // TODO: get rid of unwrap
    let password = &Encryption::encrypt_with_argon2(&request.password).unwrap();
    let email = &request.email;
    let phone_number = &request.phone_number;

    let fail_response = json!({
        "status": "failure",
        "error": "WrongCredentials"
    })
    .to_string();

    let register_successful = data
        .database_connection
        .register(username, password, email.as_deref(), phone_number.as_deref())
        .await;

    if let Err(error) = register_successful {
        println!("error during register: {:?}", error);
        // TODO: change to internal server error
        return HttpResponse::Ok().body(fail_response);
    }

    if let Ok(outcome) = register_successful {
        match outcome {
            OperationStatus::Success => {
                let user = data
                    .database_connection
                    .get_user_by_username(username)
                    .await
                    .unwrap()
                    .unwrap();

                return HttpResponse::Ok().body(
                    json!({
                        "status": "success",
                        "body": {
                            "accessToken": Jwt::create_access_token(0, &user.role),
                            "refreshToken": Jwt::create_refresh_token(0, &user.role)
                        }
                    })
                    .to_string(),
                );
            }
            OperationStatus::UserExists => return HttpResponse::Ok().body(fail_response),
        }
    };

    HttpResponse::Ok().body(fail_response)
}

#[post("/login")]
pub async fn login((data, request): (web::Data<AppState>, web::Json<LoginRequest>)) -> impl Responder {
    let username = &request.username;
    let password = &request.password;

    let fail_response = json!({
        "status": "failure",
        "error": "WrongCredentials"
    })
    .to_string();

    let login_successful = data.database_connection.get_user_by_username(username).await;

    if let Err(error) = login_successful {
        println!("error during login: {:?}", error);
        // TODO: change to internal server error
        return HttpResponse::Ok().body(fail_response);
    }

    if let Ok(maybe_user) = login_successful {
        if maybe_user == None {
            // TODO: change to specific error
            return HttpResponse::Ok().body(fail_response);
        }

        let user = maybe_user.unwrap();

        let passwords_match_result = Encryption::verify_password(password, &user.password_hash);

        if let Err(error) = passwords_match_result {
            println!("error during verifying password: {:?}", error);
            // TODO: change to internal server error
            return HttpResponse::Ok().body(fail_response);
        }

        let passwords_match = passwords_match_result.unwrap();

        if !passwords_match {
            return HttpResponse::Ok().body(fail_response);
        }

        let response = json!({
            "status": "success",
            "body": {
                "accessToken": Jwt::create_access_token(0, &user.role),
                "refreshToken": Jwt::create_refresh_token(0, &user.role)
            }
        })
        .to_string();

        return HttpResponse::Ok().body(response);
    };

    HttpResponse::Ok().body(fail_response)
}
