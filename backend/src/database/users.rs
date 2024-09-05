use crate::{security::jwt::Roles, utils::Error};

use super::DatabaseConnection;
use crate::security::FromString;
use sqlx::{postgres::PgRow, types::time::PrimitiveDateTime, FromRow, Row};

impl DatabaseConnection {
    pub async fn get_user_by_username(&self, username: &str) -> Result<Option<User>, Error> {
        let user: Option<User> = sqlx::query_as(
            "SELECT 
            u.user_id, u.username, u.password_hash, u.created_at,
            r.role_name AS role, s.status_name AS status,
            ud.email, ud.phone_number, ud.description, ud.profile_picture_path, ud.settings
            FROM users AS u
            INNER JOIN user_data AS ud ON u.user_id = ud.user_id
            INNER JOIN user_statuses AS s ON u.status_id = s. status_id
            INNER JOIN roles AS r ON u.role_id = r.role_id
            WHERE username=$1",
        )
        .bind(username)
        .fetch_optional(&self.pool)
        .await?;

        Ok(user)
    }
}

#[derive(Debug, PartialEq, Eq)]
pub struct User {
    pub user_id: i32,
    pub username: String,
    pub password_hash: String,
    pub role: Roles,
    pub status: UserStatuses,
    pub email: Option<String>,
    pub phone_number: Option<String>,
    pub description: Option<String>,
    pub profile_picture_path: Option<String>,
    pub settings: Option<String>,
    pub created_at: PrimitiveDateTime,
}

impl FromRow<'_, PgRow> for User {
    fn from_row(row: &PgRow) -> Result<Self, sqlx::Error> {
        Ok(User {
            user_id: row.try_get("user_id")?,
            username: row.try_get("username")?,
            password_hash: row.try_get("password_hash")?,
            role: Roles::from_string(row.try_get::<String, &str>("role")?),
            status: UserStatuses::from_string(row.try_get::<String, &str>("status")?),
            email: row.try_get("email")?,
            phone_number: row.try_get("phone_number")?,
            description: row.try_get("description")?,
            profile_picture_path: row.try_get("profile_picture_path")?,
            settings: row.try_get("settings")?,
            created_at: row.try_get("created_at")?,
        })
    }
}

#[derive(Debug, PartialEq, Eq)]
pub enum UserStatuses {
    Active,
    Private,
    Reported,
    Banned,
    Deleted,
}

impl FromString for UserStatuses {
    fn from_string(string: String) -> Self {
        match string.to_lowercase().as_str() {
            "active" => UserStatuses::Active,
            "private" => UserStatuses::Private,
            "reported" => UserStatuses::Reported,
            "banned" => UserStatuses::Banned,
            "deleted" => UserStatuses::Deleted,
            _ => panic!("Wrong input for UserStatuses enum from_string"),
        }
    }
}
