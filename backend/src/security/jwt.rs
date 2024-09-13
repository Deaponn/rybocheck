use base64::prelude::*;
use serde::Serialize;
use serde_json::json;
use std::env;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

use super::{Encryption, FromString};
use super::Jwt;

const ACCESS_TOKEN_LIFESPAN: u64 = 5 * 60;
#[derive(Serialize, Debug, PartialEq, Eq)]
pub enum Roles {
    User,
    TrustedUser,
    Moderator,
    Admin,
}

impl FromString for Roles {
    fn from_string(string: String) -> Self {
        match string.to_lowercase().as_str() {
            "user" => Roles::User,
            "trusted-user" => Roles::TrustedUser,
            "moderator" => Roles::Moderator,
            "admin" => Roles::Admin,
            _ => panic!("Wrong input for Roles enum from_string"),
        }
    }
}

impl Jwt {
    fn create_token(user_id: i32, permission_level: &Roles, token_type: &str, lifetime: Option<u64>) -> String {
        let api_version = env::var("VERSION").expect("VERSION environment variable is not set");
        let server_secret = env::var("SERVER_SECRET").expect("SERVER_SECRET environment variable is not set");
        let current_timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();

        let header = BASE64_STANDARD.encode(json!({ "tokenType": token_type, "api": api_version }).to_string());
        let payload = BASE64_STANDARD.encode(match lifetime {
            Some(lifetime) => json!({
                "sub": user_id,
                "permissionLevel": permission_level,
                "iat": current_timestamp.as_secs(),
                "exp": (current_timestamp + Duration::new(lifetime, 0)).as_secs()
            })
            .to_string(),
            _ => json!({
                "sub": user_id,
                "permissionLevel": permission_level,
                "iat": current_timestamp.as_secs()
            })
            .to_string(),
        });
        let signature: String = Encryption::encrypt_with_sha2(format!("{header}.{payload}.{server_secret}"));

        format!("{header}.{payload}.{signature}")
    }

    // TODO: create proper error
    pub fn check_if_valid(jwt_token: String) -> Result<bool, String> {
        let server_secret = env::var("SERVER_SECRET").expect("SERVER_SECRET environment variable is not set");

        let jwt_data: Vec<&str> = jwt_token.split(".").collect();
        if jwt_data.len() != 3 {
            return Err(String::from("Invalid JWT"));
        };
        let header = jwt_data[0];
        let payload = jwt_data[1];
        let res = jwt_data[2] == Encryption::encrypt_with_sha2(format!("{header}.{payload}.{server_secret}"));
        Ok(res)
    }

    pub fn create_refresh_token(user_id: i32, permission_level: &Roles) -> String {
        Jwt::create_token(user_id, permission_level, "refreshToken", None)
    }

    pub fn create_access_token(user_id: i32, permission_level: &Roles) -> String {
        Jwt::create_token(user_id, permission_level, "accessToken", Some(ACCESS_TOKEN_LIFESPAN))
    }

    // TODO: implement
    pub fn access_from_refresh(refresh_token: String) -> String {
        Jwt::create_access_token(0, &Roles::User)
    }
}
