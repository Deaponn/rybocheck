use super::ScriptRunner;
use std::process::{Command, Stdio};

impl<'a> ScriptRunner<'a> {
    pub fn new(args: Vec<String>) -> Self {
        ScriptRunner {
            args,
            scripts: Vec::<Script>::new(),
        }
    }

    pub fn add_new(&mut self, script: Scripts, arg: &'a str) -> &mut Self {
        let new_script = Script::new(script, arg);
        self.scripts.push(new_script);
        self
    }

    pub fn try_all(&self) -> bool {
        let mut should_exit = false;
        for arg in &self.args {
            for script in &self.scripts {
                if arg == script.invoke_on {
                    should_exit = (script.action)(script.arg);
                }
            }
        }
        should_exit
    }
}

pub struct Script<'a> {
    pub invoke_on: &'a str,
    pub arg: &'a str,
    pub action: fn(&'a str) -> bool,
}

impl<'a> Script<'a> {
    pub fn new(script: Scripts, arg: &'a str) -> Self {
        match script {
            Scripts::ResetDatabase => Script {
                invoke_on: "reset-database",
                arg,
                action: RESET_DATABASE,
            },
            Scripts::SetupDatabase => Script {
                invoke_on: "setup-database",
                arg,
                action: SETUP_DATABASE,
            },
            Scripts::DropDatabase => Script {
                invoke_on: "drop-database",
                arg,
                action: DROP_DATABASE,
            },
        }
    }
}

pub enum Scripts {
    ResetDatabase,
    SetupDatabase,
    DropDatabase,
}

const RESET_DATABASE: fn(&str) -> bool = |db_url| {
    DROP_DATABASE(db_url);
    SETUP_DATABASE(db_url);
    true
};

const SETUP_DATABASE: fn(&str) -> bool = |db_url| {
    let setup = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/setup_database.sql"])
        .stdout(Stdio::null())
        .status()
        .expect("Failed to invoke CREATE command");
    if setup.success() {
        println!("Finished CREATE all TABLEs");
    } else {
        println!("Failed to CREATE TABLEs. Reason: {setup}");
    }
    let constants = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/insert_constants.sql"])
        .stdout(Stdio::null())
        .status()
        .expect("Failed to invoke populate with constants command");
    if constants.success() {
        println!("Finished INSERT all constants");
    } else {
        println!("Failed to INSERT constants. Reason: {constants}");
    }
    true
};

const DROP_DATABASE: fn(&str) -> bool = |db_url| {
    let drop = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/drop_database.sql"])
        .stdout(Stdio::null())
        .status()
        .expect("Failed to invoke DROP command");
    if drop.success() {
        println!("Finished DROP all TABLEs");
    } else {
        println!("Failed to DROP TABLEs. Reason: {drop}");
    }
    true
};
