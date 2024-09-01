use sqlx::Error;
use super::DatabaseConnection;

impl DatabaseConnection {
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

pub enum OperationStatus {
    Success,
    UserExists,
}
