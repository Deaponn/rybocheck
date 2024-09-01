use super::DatabaseConnection;
use sqlx::{types::time::PrimitiveDateTime, Error};

impl DatabaseConnection {
    pub async fn get_user_by_username(&self, username: &str) -> Result<Option<User>, Error> {
        let user: Option<User> = sqlx::query_as("SELECT * FROM users WHERE username=$1")
            .bind(username)
            .fetch_optional(&self.pool)
            .await?;

        Ok(user)
    }
}

#[derive(sqlx::FromRow, Debug, PartialEq, Eq)]
pub struct User {
    user_id: i32,
    username: String,
    password_hash: String,
    role_id: i32,
    status_id: i32,
    created_at: PrimitiveDateTime,
}
