pub mod jwt;
pub mod encryption;

pub struct Jwt;
pub struct Encryption;

pub trait FromString {
    fn from_string(string: String) -> Self;
}
