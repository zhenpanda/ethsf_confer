#![feature(plugin, decl_macro)]
#![plugin(rocket_codegen)]
#[macro_use] extern crate rocket;
extern crate rocket_cors;
#[macro_use] extern crate rocket_contrib;

#[macro_use]
extern crate serde_derive;

extern crate serde;
extern crate serde_json;

use rocket_contrib::{Json, Value};
use std::process::Command;
use std::path::{Path, PathBuf};
use rocket::http::Method;
use rocket_cors::{AllowedOrigins, AllowedHeaders};

#[derive(Serialize)]
struct Proof {
    A: String,
    A_p: String,
    B: String,
    B_p: String,
    C: String,
    C_p: String,
    H: String,
    K: String
}


#[get("/compile/<file>")]
fn compile(file: String) -> String {
    let relative_path = PathBuf::from(format!("../{}", file));
    let mut absolute_path = std::env::current_dir().unwrap();
    absolute_path.push(relative_path);
    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("zokrates compile -i {:?}", absolute_path.display()))
        .output()
        .unwrap_or_else(|e| { 
            panic!("failed to execute process: {}", e) 
        });
    format!("stdout: {} \n {}", 
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr))
}

#[get("/compute-witness/<arg1>")]
fn compute_witness(arg1: String) -> String {
    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("zokrates compute-witness -a {}", arg1))
        .output()
        .unwrap_or_else(|e| { 
            panic!("failed to execute process: {}", e) 
        });
    format!("stdout: {} \n {}", 
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr))
}

#[get("/setup")]
fn setup() -> Json<Value> {
    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("zokrates setup"))
        .output()
        .unwrap_or_else(|e| { 
            panic!("failed to execute process: {}", e) 
        });
    let return_val = String::from_utf8_lossy(&output.stdout);
    let first_phase: Vec<&str> = return_val.split("{").collect();
    let f_phase: Vec<&str> = first_phase[1].split("}").collect();
    let final_phase = f_phase[0]
        .replace("\t", "")
        .replace("Pairing.G1Point(", "")
        .replace("Pairing.G1Point[]3", "")
        .replace("Pairing.G1Point[]", "")
        .replace("Pairing.G2Point(", "")
        .replace(")", "")
        .replace("(", "")
        .replace("\n", "")
        .replace("\\", "")
        .replace("\\", "")
        .replace("[", "['")
        .replace("]", "']")
        .replace(", 0x", "', '0x")
        .replace("vk", "'vk")
        .replace(" =", "' =")
        .replace("'vk.IC' = new 3;", "")
        .replace("['1']", "1")
        .replace("['2']", "2")
        .replace("['0']", "0")
        .replace("= 0x", "= ['0x")
        .replace(";", "'];")
        .replace("']']", "']")
        .replace("'], ['", "','")
        .replace(";", ",")
        .replace("=", ":");
    Json(json!(format!("{} {} {}", "{",  r#final_phase, "}")))
}

#[get("/generate-proof")]
fn generate_proof() -> String {
    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("zokrates generate-proof"))
        .output()
        .unwrap_or_else(|e| { 
            panic!("failed to execute process: {}", e) 
        });
    let return_val = format!("{}", String::from_utf8_lossy(&output.stdout));
    return_val
    //**let v: Vec<&str> = return_val.split("\n").collect();
    //println!("{:?}", v);
    //Json(Proof{
    //    A:String::from(v[2]),
    //    A_p: String::from(v[3]),
    //    B:String::from(v[4]),
    //    B_p:String::from("a"),
    //    C:String::from("a"),
    //    C_p:String::from("a"),
    //    H:String::from("a"),
    //    K:String::from("a")
    //})**/

}

#[get("/export-verifier")]
fn export_verifier() -> String {
    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("zokrates export-verifier"))
        .output()
        .unwrap_or_else(|e| { 
            panic!("failed to execute process: {}", e) 
        });
    format!("stdout: {} \n {}", 
        String::from_utf8_lossy(&output.stdout),
        String::from_utf8_lossy(&output.stderr))
}

fn main() {
    let (allowed_origins, failed_origins) = AllowedOrigins::some(&["*"]);

    // You can also deserialize this
    let options = rocket_cors::Cors {
        allowed_origins: allowed_origins,
        allowed_methods: vec![Method::Get].into_iter().map(From::from).collect(),
        allowed_headers: AllowedHeaders::some(&["Authorization", "Accept"]),
        allow_credentials: true,
        ..Default::default()
    };

    rocket::ignite()
        .mount("/", routes![compile, compute_witness, setup, generate_proof, export_verifier])
        .attach(options)
        .launch();
}

