use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use mysql::*;
use mysql::prelude::*;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct File {
    pk_id: i32,
    name: String,
    author: String,
    created: String,
    size: i64,
    downloads: i32,
    rating: f32
}

#[derive(Serialize, Deserialize, Debug)]
struct FileHistory {
    pk_id: i32,
    changed: String,
    author: String,
    state: String,
    content: String
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(get_file)
            .service(get_files)
            .service(get_file_history)
    })
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("3D Files Management API v1")
}

#[get("/files")]
async fn get_files() -> impl Responder {
    let query = format!("SELECT Id, Name, Author, Created, Size, Downloads, AverageRating FROM File;");
    let sk = read_files_from_db(query).expect("Error");
    if sk.is_empty(){
        HttpResponse::NotFound().json("not found")
    }
    else{
        HttpResponse::Ok().json(sk)
    }
}

#[get("/files/{id}")]
async fn get_file(path: web::Path<(u32,)>) -> impl Responder {
    let query = format!("SELECT * FROM File WHERE Id={};", path.into_inner().0);
    let sk = read_files_from_db(query).expect("Error");
    if sk.is_empty(){
        HttpResponse::NotFound().json("not found")
    }
    else{
        HttpResponse::Ok().json(&sk[0])
    }
}

#[get("/files/{id}/history")]
async fn get_file_history(path: web::Path<(u32,)>) -> impl Responder {
    let query = format!("SELECT Id, ChangedOn, ByAuthor, State, Content FROM FileHistory WHERE File_fk={};", path.into_inner().0);
    let sk = read_file_history_from_db(query).expect("Error");
    HttpResponse::Ok().json(sk)
}

fn read_files_from_db(query: String) -> std::result::Result<Vec<File>, Box<dyn std::error::Error>> {
    let url = "mysql://root:example@127.0.0.1:3307/ThreeDeeFilesManagement";
    let pool = Pool::new(url)?;
    let mut conn = pool.get_conn()?;
    let files:Vec<File> = conn
        .query_map(
            query,
            |(pk_id, name, author, created, size, downloads, rating)| {
                File { pk_id, name, author, created, size, downloads, rating }
            },
        )?;
    Ok(files)
}

fn read_file_history_from_db(query: String) -> std::result::Result<Vec<FileHistory>, Box<dyn std::error::Error>> {
    let url = "mysql://root:example@127.0.0.1:3307/ThreeDeeFilesManagement";
    let pool = Pool::new(url)?;
    let mut conn = pool.get_conn()?;

    let selected_payments:Vec<FileHistory> = conn
        .query_map(
            query,
            |(pk_id, changed, author, state, content)| {
                FileHistory {pk_id, changed, author, state, content }
            },
        )?;
    Ok(selected_payments)
}