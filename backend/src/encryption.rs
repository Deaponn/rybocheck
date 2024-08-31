use argon2::{
    password_hash::{
        rand_core::OsRng,
        PasswordHash, PasswordHasher, PasswordVerifier, SaltString
    },
    Argon2, password_hash::Error
};
use sha2::{Digest, Sha256};
use sha2::digest::generic_array::GenericArray;

pub fn encrypt_with_sha2(input: String) -> String {
    let hash: GenericArray<u8, _> = Sha256::digest(input.as_bytes());
    
    let mut signature = [0u8; 64];
    base16ct::lower::encode_str(&hash, &mut signature).unwrap();
    
    String::from_utf8(signature.to_vec()).unwrap()
}

pub fn encrypt_with_argon2(password: &str) -> Result<String, Error> {
    let password = password.as_bytes();
    let salt = SaltString::generate(&mut OsRng);
    
    Ok(Argon2::default().hash_password(password, &salt)?.to_string())
}

pub fn verify_password(password: &str, password_hash: &str) -> Result<bool, Error> {
    let parsed_hash = PasswordHash::new(&password_hash)?;

    Ok(Argon2::default().verify_password(password.as_bytes(), &parsed_hash).is_ok())
}
