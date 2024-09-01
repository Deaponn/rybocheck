use sqlx::PgPool;

mod connection;
mod auth;
mod users;

pub struct DatabaseConnection {
    pool: PgPool,
}
