use sqlx::PgPool;

mod connection;
pub mod auth;
mod users;

#[derive(Clone)]
pub struct DatabaseConnection {
    pool: PgPool,
}
