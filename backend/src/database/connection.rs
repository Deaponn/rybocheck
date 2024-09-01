use sqlx::{Error, PgPool};
use super::DatabaseConnection;

impl DatabaseConnection {
    pub async fn new(db_url: &str) -> Result<Self, Error> {
        let pool = PgPool::connect(db_url).await?;
        Ok(Self { pool })
    }
}
