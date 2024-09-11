use actix_web::{middleware::Logger, web, App, HttpServer};
use database::DatabaseConnection;
use env_logger::Env;
use std::env::{self};
use utils::{ScriptRunner, run_scripts::Scripts};
mod database;
mod routes;
mod security;
mod utils;

struct AppState {
    database_connection: DatabaseConnection,
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

    if ScriptRunner::new(args)
        .add_new(Scripts::ResetDatabase, &db_url)
        .add_new(Scripts::SetupDatabase, &db_url)
        .add_new(Scripts::DropDatabase, &db_url)
        .try_all()
    {
        return Ok(());
    }

    let database_connection = DatabaseConnection::new(&db_url)
        .await
        .expect("Failed to establish databse connection");

    env_logger::init_from_env(Env::default().default_filter_or("info"));

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(AppState { database_connection: database_connection.clone() }))
            .wrap(Logger::default())
            .service(
                web::scope("/rybocheck/api/v1")
                    .service(routes::auth::login)
                    .service(routes::auth::register)
                    .service(routes::root::hello),
            )
    })
    .bind((url, port))?
    .run()
    .await
}
