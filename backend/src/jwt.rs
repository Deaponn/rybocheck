use base64::prelude::*;
use serde::Serialize;
use serde_json::json;
use sha2::{Digest, Sha256};
use sha2::digest::generic_array::GenericArray;
use std::env;
use std::time::{Duration, SystemTime, UNIX_EPOCH};
use base16ct;

const ACCESS_TOKEN_LIFESPAN: u64 = 5 * 60;
#[derive(Serialize)]
pub enum PermissionLevel {
    User,
    TrustedUser,
    Moderator,
    Admin,
}

fn create_token(
    user_id: u32,
    permission_level: PermissionLevel,
    token_type: &str,
    lifetime: Option<u64>,
) -> String {
    let api_version = env::var("VERSION").expect("VERSION environment variable is not set");
    let server_secret =
        env::var("SERVER_SECRET").expect("SERVER_SECRET environment variable is not set");
    let current_timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();

    let header =
        BASE64_STANDARD.encode(json!({ "tokenType": token_type, "api": api_version }).to_string());
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
    let hash: GenericArray<u8, _> = Sha256::digest(format!("{header}.{payload}.{server_secret}").as_bytes());
    
    let mut signature = [0u8; 64];
    base16ct::lower::encode_str(&hash, &mut signature).unwrap();

    format!("{header}.{payload}.{}", String::from_utf8(signature.to_vec()).unwrap())
}

pub fn create_refresh_token(user_id: u32, permission_level: PermissionLevel) -> String {
    create_token(user_id, permission_level, "refreshToken", None)
}

pub fn create_access_token(user_id: u32, permission_level: PermissionLevel) -> String {
    create_token(
        user_id,
        permission_level,
        "accessToken",
        Some(ACCESS_TOKEN_LIFESPAN),
    )
}
