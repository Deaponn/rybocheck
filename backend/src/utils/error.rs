use std::fmt::Display;

use super::Error;
use actix_web::{error, http::{header::ContentType, StatusCode}, HttpResponse};

#[derive(Debug)]
pub enum InternalErrors {
    Argon2Error,
    SqlxError,
}

// TODO: add BAD_REQUEST
#[derive(Debug)]
pub enum UserErrors {
    WrongCredentials,
    UserExists,
    Unauthenticated,
    Unauthorized,
}

impl Display for InternalErrors {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        match *self {
            InternalErrors::Argon2Error => write!(f, "argon2Error"),
            InternalErrors::SqlxError => write!(f, "sqlxError")
        }
    }
}

impl Display for UserErrors {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        match *self {
            UserErrors::WrongCredentials => write!(f, "wrongCredentials"),
            UserErrors::UserExists => write!(f, "userExists"),
            UserErrors::Unauthenticated => write!(f, "unauthenticated"),
            UserErrors::Unauthorized => write!(f, "unauthorized"),
        }
    }
}

impl Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        match self {
            Error::InternalError(error) => write!(f, "InternalError: {error}"),
            Error::UserError(error) => write!(f, "{error}")
        }
    }
}

impl InternalErrors {
    fn status_code(&self) -> StatusCode {
        match *self {
            InternalErrors::Argon2Error => StatusCode::INTERNAL_SERVER_ERROR,
            InternalErrors::SqlxError => StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}

impl UserErrors {
    fn status_code(&self) -> StatusCode {
        match *self {
            UserErrors::WrongCredentials => StatusCode::BAD_REQUEST,
            UserErrors::UserExists => StatusCode::CONFLICT,
            UserErrors::Unauthenticated => StatusCode::UNAUTHORIZED,
            UserErrors::Unauthorized => StatusCode::FORBIDDEN,
        }
    }
}

impl error::ResponseError for Error {
    fn error_response(&self) -> HttpResponse {
        HttpResponse::build(self.status_code())
            .insert_header(ContentType::json())
            .body(format!("{{\"status\": \"error\", \"error\": \"{}\"}}", self.to_string()))
    }

    fn status_code(&self) -> StatusCode {
        match self {
            Error::InternalError(error) => error.status_code(),
            Error::UserError(error) => error.status_code()
        }
    }
}

// TODO: add logging for those errors??

impl From<argon2::password_hash::Error> for Error {
    fn from(_: argon2::password_hash::Error) -> Self {
        Error::InternalError(InternalErrors::Argon2Error)
    }
}

impl From<sqlx::Error> for Error {
    fn from(_: sqlx::Error) -> Self {
        Error::InternalError(InternalErrors::SqlxError)
    }
}
