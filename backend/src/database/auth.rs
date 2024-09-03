use crate::security::Encryption;

use super::{users::User, DatabaseConnection};
use sqlx::Error;

impl DatabaseConnection {
    pub async fn login(&self, username: &str, password: &str) -> Result<Option<User>, Error> {
        let user = self.get_user_by_username(username).await?;
        if user == None {
            return Ok(None);
        }
        let existing_user = user.unwrap();
        let passwords_match_or_err = Encryption::verify_password(password, &existing_user.password_hash);
        if let Err(_) = passwords_match_or_err {
            println!("src/database/auth.rs: Encryption::verify_password Error");
            return Ok(None);
        }
        let passwords_match = passwords_match_or_err.unwrap();
        if passwords_match {
            return Ok(Some(existing_user));
        } else {
            return Ok(None);
        }
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

pub enum OperationStatus {
    Success,
    UserExists,
}
