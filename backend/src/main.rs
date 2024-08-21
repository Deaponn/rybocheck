use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use std::env;
mod jwt;

#[get("")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/login")]
async fn login(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = dotenvy::from_filename("dev.env");
    let port: u16 = env::var("API_PORT")
        .expect("API_PORT environment variable is not set")
        .parse::<u16>()
        .expect("Could not parse API_PORT as an int");

    HttpServer::new(|| {
        App::new().service(
            web::scope("/rybocheck/api/v1")
            .service(hello)
            .service(login),
        )
    })
    .bind(("127.0.0.1", port))?
    .run()
    .await
}
