use sqlx::PgPool;

mod connection;
pub mod auth;
mod users;

pub struct DatabaseConnection {
    pool: PgPool,
}
