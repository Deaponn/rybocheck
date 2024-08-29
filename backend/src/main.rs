use actix_web::{get, middleware::Logger, post, web, App, HttpResponse, HttpServer, Responder};
use env_logger::Env;
use jwt::{create_access_token, create_refresh_token, PermissionLevel};
use serde::Deserialize;
use serde_json::json;
use sqlx::postgres::PgPoolOptions;
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

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = dotenvy::from_filename(".env");
    let port: u16 = env::var("API_PORT")
        .expect("API_PORT environment variable is not set")
        .parse::<u16>()
        .expect("Could not parse API_PORT as an int");
    let url: String = env::var("API_URL").expect("API_URL environment variable is not set");
    let db_user: String = env::var("DB_USER").expect("DB_USER environment variable is not set");
    let db_address: String = env::var("DB_ADDRESS").expect("DB_ADDRESS environment variable is not set");
    let db_password: Option<String> = env::var("DB_PASSWORD").ok();
    let db_name: String = env::var("DB_NAME").expect("DB_NAME environment variable is not set");
    let db_connection = match db_password {
        Some(db_password) if db_password != "" => format!("postgres://{db_user}:{db_password}@{db_address}/{db_name}"),
        _ => format!("postgres://{db_user}@{db_address}/{db_name}"),
    };

    println!("{db_connection}");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&db_connection)
        .await
        .expect("Database connection error");

    let row: (String,) = sqlx::query_as("SELECT version()")
        .fetch_one(&pool)
        .await
        .expect("Query error");

    println!("query outcome: {:?}", row);

    env_logger::init_from_env(Env::default().default_filter_or("info"));

    HttpServer::new(|| {
        App::new()
            .wrap(Logger::default())
            .service(web::scope("/rybocheck/api/v1").service(login).service(hello))
    })
    .bind((url, port))?
    .run()
    .await
}
