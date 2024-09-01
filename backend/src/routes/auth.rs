use serde::Deserialize;
use serde_json::json;
use actix_web::{post, web, HttpResponse, Responder};
use crate::security::jwt::PermissionLevel;
use crate::security::Jwt;

#[derive(Deserialize, Debug)]
struct LoginRequest {
    username: String,
    password: String,
}

fn check_credentials(username: &str, password: &str) -> bool {
    if username == "admin" && password == "37bb2162f62286505299b0147d2598dfe8a8c1c4ed7ac8346dbb9cfab31ae080" {
        return true;
    }
    false
}

#[post("/login")]
pub async fn login(request: web::Json<LoginRequest>) -> impl Responder {
    let username = &request.username;
    let password = &request.password;

    if check_credentials(username, password) {
        let response = json!({
            "status": "success",
            "body": {
                "accessToken": Jwt::create_access_token(0, PermissionLevel::Admin),
                "refreshToken": Jwt::create_refresh_token(0, PermissionLevel::Admin)
            }
        })
        .to_string();

        return HttpResponse::Ok().body(response);
    }
    let response = json!({
        "status": "failure",
        "error": "WrongCredentials"
    })
    .to_string();
    HttpResponse::Ok().body(response)
}