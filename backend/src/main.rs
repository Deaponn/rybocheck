use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder, middleware::Logger};
use std::env;
mod jwt;
use env_logger::Env;

#[get("")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/login")]
async fn login(req_body: String) -> impl Responder {
    print!("received ");
    HttpResponse::Ok().body(req_body)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = dotenvy::from_filename("dev.env");
    let port: u16 = env::var("API_PORT")
        .expect("API_PORT environment variable is not set")
        .parse::<u16>()
        .expect("Could not parse API_PORT as an int");
    
    env_logger::init_from_env(Env::default().default_filter_or("info"));

    HttpServer::new(|| {
        App::new()
        .wrap(Logger::default()).service(
            web::scope("/rybocheck/api/v1")
            .service(hello)
            .service(login),
        )
    })
    .bind(("127.0.0.1", port))?
    .run()
    .await
}
