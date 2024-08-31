use sqlx::{types::time::PrimitiveDateTime, Error, PgPool};

pub struct DatabaseConnection {
    pool: PgPool,
}

impl DatabaseConnection {
    pub async fn new(db_url: &str) -> Result<Self, Error> {
        let pool = PgPool::connect(db_url).await?;
        Ok(Self { pool })
    }

    pub async fn get_user_by_username(&self, username: &str) -> Result<Option<User>, Error> {
        let user: Option<User> = sqlx::query_as("SELECT * FROM users WHERE username=$1")
            .bind(username)
            .fetch_optional(&self.pool)
            .await?;

        Ok(user)
    }

    pub async fn register(
        &self,
        username: &str,
        password_hash: &str,
        email: Option<&str>,
        phone_number: Option<&str>,
    ) -> Result<OperationStatus, Error> {
        let existing_user = self.get_user_by_username(username).await?;

        if existing_user != None {
            return Ok(OperationStatus::UserExists);
        }

        let mut tx = self.pool.begin().await?;

        println!("username {}", username);

        let user_id: (i32,) = sqlx::query_as(
            "INSERT INTO users(username, password_hash, role_id, status_id) VALUES($1, $2, 4, 1) RETURNING user_id",
        )
        .bind(username)
        .bind(password_hash)
        .fetch_one(&mut *tx)
        .await?;

        println!("new user id {}", user_id.0);

        sqlx::query("INSERT INTO user_data(user_id, email, phone_number) VALUES ($1, $2, $3)")
            .bind(user_id.0)
            .bind(email)
            .bind(phone_number)
            .execute(&mut *tx)
            .await?;

        println!("tx success");

        tx.commit().await?;

        Ok(OperationStatus::Success)
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

pub enum OperationStatus {
    Success,
    UserExists,
}
