use base64::prelude::*;

enum PermissionLevel {
    User,
    TrustedUser,
    Moderator,
    Admin
}

fn create_access_token(user_id: u32, permission_level: PermissionLevel) {

}
