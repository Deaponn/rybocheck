use actix_web::{get, middleware::Logger, post, web, App, HttpResponse, HttpServer, Responder};
use env_logger::Env;
use jwt::{create_access_token, create_refresh_token, PermissionLevel};
use serde::Deserialize;
use serde_json::json;
use std::env;
mod jwt;

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

#[get("")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/login")]
async fn login(request: web::Json<LoginRequest>) -> impl Responder {
    let username = &request.username;
    let password = &request.password;
    
    if check_credentials(username, password) {
        let response = json!({
            "status": "success",
            "body": {
                "accessToken": create_access_token(0, PermissionLevel::Admin),
                "refreshToken": create_refresh_token(0, PermissionLevel::Admin)
            }
        }).to_string();
        
        return HttpResponse::Ok().body(response);
    }
    let response = json!({
        "status": "failure",
        "error": "WrongCredentials"
    }).to_string();
    HttpResponse::Ok().body(response)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = dotenvy::from_filename("dev.env");
    let port: u16 = env::var("API_PORT")
        .expect("API_PORT environment variable is not set")
        .parse::<u16>()
        .expect("Could not parse API_PORT as an int");
    let url: String = env::var("API_URL").expect("API_URL environment variable is not set");

    env_logger::init_from_env(Env::default().default_filter_or("info"));

    HttpServer::new(|| {
        App::new().wrap(Logger::default()).service(
            web::scope("/rybocheck/api/v1")
                .service(login)
                .service(hello),
        )
    })
    .bind((url, port))?
    .run()
    .await
}
