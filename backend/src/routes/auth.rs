use crate::{security::{Encryption, Jwt}, AppState};
use actix_web::{post, web, HttpResponse, Responder};
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize, Debug)]
struct LoginRequest {
    username: String,
    password: String,
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
