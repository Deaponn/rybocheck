use actix_web::{middleware::Logger, web, App, HttpServer};
use database::DatabaseConnection;
use env_logger::Env;
use std::{
    env::{self},
    process::Command,
};
mod database;
mod routes;
mod security;

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
        App::new().wrap(Logger::default()).service(
            web::scope("/rybocheck/api/v1")
                .service(routes::auth::login)
                .service(routes::root::hello),
        )
    })
    .bind((url, port))?
    .run()
    .await
}
