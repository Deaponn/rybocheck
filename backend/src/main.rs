use actix_web::{get, middleware::Logger, post, web, App, HttpResponse, HttpServer, Responder};
use database::DatabaseConnection;
use env_logger::Env;
use jwt::{create_access_token, create_refresh_token, PermissionLevel};
use serde::Deserialize;
use serde_json::json;
use std::{
    env::{self},
    process::Command,
};
mod database;
mod jwt;
mod encryption;

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
    let args: Vec<String> = env::args().collect();
    let _ = dotenvy::from_filename(".env");
    let port: u16 = env::var("API_PORT")
        .expect("API_PORT environment variable is not set")
        .parse::<u16>()
        .expect("Could not parse API_PORT as an int");
    let url: String = env::var("API_URL").expect("API_URL environment variable is not set");
    let db_url: String = env::var("DATABASE_URL").expect("DATABASE_URL environment variable is not set");

    if args[1] == "reset-database" {
        println!("resetting the whole database...");
        let _ = Command::new("psql")
            .args([&db_url, "-a", "-f", "migrations/drop_database.sql"])
            .output()
            .expect("Failed to DROP");
        println!("DROP all TABLEs successful");
        let _ = Command::new("psql")
            .args([&db_url, "-a", "-f", "migrations/setup_database.sql"])
            .output()
            .expect("Failed to CREATE");
        println!("CREATE all TABLEs successful");
        let _ = Command::new("psql")
            .args([&db_url, "-a", "-f", "migrations/insert_constants.sql"])
            .output()
            .expect("Failed to populate with constants");
        println!("INSERT all constants successful");
        return Ok(());
    }

    let database = DatabaseConnection::new(&db_url)
        .await
        .expect("Failed to establish databse connection");

    database
        .register("admin2", "cool-hash", None, Some("+48 512123456"))
        .await
        .expect("Query error");
    database
        .register("admin4", "cool-hash", None, Some("+48 512123456"))
        .await
        .expect("Query error");
    database
        .register("test2", "cool-hash", Some("my.email@test.org"), None)
        .await
        .expect("Query error");

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
