use std::process::Command;
use super::ScriptRunner;

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

    pub fn run_all(&self) -> bool {
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
        }
    }
}

pub enum Scripts {
    ResetDatabase,
}

const RESET_DATABASE: fn(&str) -> bool = |db_url| {
    let _ = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/drop_database.sql"])
        .output()
        .expect("Failed to DROP");
    println!("DROP all TABLEs successful");
    let _ = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/setup_database.sql"])
        .output()
        .expect("Failed to CREATE");
    println!("CREATE all TABLEs successful");
    let _ = Command::new("psql")
        .args([db_url, "-a", "-f", "migrations/insert_constants.sql"])
        .output()
        .expect("Failed to populate with constants");
    println!("INSERT all constants successful");
    true
};
