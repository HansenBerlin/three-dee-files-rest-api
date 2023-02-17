mod file;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use std::env;


#[tokio::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(get_file)
            .service(get_files)
            .service(get_file_history)
    })
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("3D Files Management APIv1")
}

#[get("/files")]
async fn get_files() -> impl Responder {
    let files = file::get_all_files().await.expect("Error");
    if files.is_empty(){
        HttpResponse::NotFound().json("Files not found")
    }
    else{
        HttpResponse::Ok().json(files)
    }
}

#[get("/files/{id}")]
async fn get_file(path: web::Path<(u32,)>) -> impl Responder {
    let file = file::get_single_file(path.into_inner().0)
        .await.expect("File not found. error during query");
    if file.is_empty(){
        HttpResponse::NotFound().json("Files not found")
    }
    else{
        HttpResponse::Ok().json(&file[0])
    }
}

#[get("/files/{id}/history")]
async fn get_file_history(path: web::Path<(u32,)>) -> impl Responder {
    let file_history = file::get_file_history(path.into_inner().0)
        .await.expect("Error during query");
    if file_history.is_empty(){
        HttpResponse::NotFound().json("File History not found")
    }
    else{
        HttpResponse::Ok().json(file_history)
    }
}