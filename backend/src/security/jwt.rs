use base64::prelude::*;
use serde::Serialize;
use serde_json::json;
use std::env;
use std::time::{Duration, SystemTime, UNIX_EPOCH};

use super::Encryption;
use super::Jwt;

const ACCESS_TOKEN_LIFESPAN: u64 = 5 * 60;
#[derive(Serialize)]
pub enum PermissionLevel {
    User,
    TrustedUser,
    Moderator,
    Admin,
}

impl Jwt {
    fn create_token(
        user_id: u32,
        permission_level: PermissionLevel,
        token_type: &str,
        lifetime: Option<u64>,
    ) -> String {
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

    pub fn create_refresh_token(user_id: u32, permission_level: PermissionLevel) -> String {
        Jwt::create_token(user_id, permission_level, "refreshToken", None)
    }

    pub fn create_access_token(user_id: u32, permission_level: PermissionLevel) -> String {
        Jwt::create_token(user_id, permission_level, "accessToken", Some(ACCESS_TOKEN_LIFESPAN))
    }
}
