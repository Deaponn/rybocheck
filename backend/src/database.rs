use sqlx::{postgres::PgPoolOptions, query_file, Error, Executor, Pool, Postgres};

pub struct DatabaseConnection {
    pool: Pool<Postgres>,
}

impl DatabaseConnection {
    pub async fn new(db_url: &str) -> Result<Self, Error> {
        let pool = PgPoolOptions::new().max_connections(5).connect(db_url).await?;
        Ok(Self { pool })
    }

    pub async fn register(
        &self,
        username: String,
        passwordHash: String,
        email: Option<String>,
        phoneNumber: Option<String>,
    ) -> Result<bool, Error> {
        let existingUser: (String,) = sqlx::query_as("SELECT * FROM users WHERE 'username'=$1")
            .bind(username)
            .fetch_one(&self.pool)
            .await?;

        println!("user: {:?}", existingUser);

        Ok(true)
    }
}
