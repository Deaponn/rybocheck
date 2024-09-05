use error::{InternalErrors, UserErrors};
use run_scripts::Script;

pub mod run_scripts;
pub mod error;

pub struct ScriptRunner<'a> {
    args: Vec<String>,
    scripts: Vec<Script<'a>>,
}

#[derive(Debug)]
pub enum Error {
    InternalError(InternalErrors),
    UserError(UserErrors)
}
