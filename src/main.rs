#![feature(slice_patterns)]
extern crate getopts;
extern crate uuid;
use getopts::Options;
use std::env;
use std::fs::{File};
use std::path::{Path,PathBuf};
use uuid::Uuid;
use std::process::Command;

fn process_layer(dockerfile: Vec<String>) {
	for line in dockerfile.iter() {
		let command: Vec<&str> = line.split_whitespace().collect();
		match &command[..] {
			["SUB", image] => {
				File::create(PathBuf::from(""))
			},
			["RETURN", file1, file2] => {
			},
			_ => panic!("Invalid instruction {}",line)
		}
	}
}

fn build_file() {
	Command::new("docker").arg("build")
}

fn print_usage(program: &str, opts: Options) {
    let brief = format!("Usage: {} FILE [options]", program);
    print!("{}", opts.usage(&brief));
}

fn main() {
	let args: Vec<String> = env::args().collect();
	let program = args[0].clone();

	let mut opts = Options::new();
	opts.optflag("h", "help", "print usage info");
	opts.optflag("p","push", "push image");
	opts.optopt("t","tag", "tag image","TAG");
	
	let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => panic!(f.to_string())
    };

	if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }
}
