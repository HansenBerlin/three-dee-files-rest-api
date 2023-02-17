mod file;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use std::env;


fn get_database_url() -> String {
    let key = "DATABASE_URL";
    match env::var(key) {
        Ok(val) => val,
        _ => "127.0.0.1".to_string()
    }
}

//#[actix_web::main]
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
    HttpResponse::Ok().body("3D Files Management API v1")
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
    let file = file::get_single_file(path.into_inner().0).expect("File not found. error during query");
    if file.is_empty(){
        HttpResponse::NotFound().json("Files not found")
    }
    else{
        HttpResponse::Ok().json(&file[0])
    }
}

#[get("/files/{id}/history")]
async fn get_file_history(path: web::Path<(u32,)>) -> impl Responder {
    let file_history = file::get_file_history(path.into_inner().0).expect("Error during query");
    if file_history.is_empty(){
        HttpResponse::NotFound().json("File History not found")
    }
    else{
        HttpResponse::Ok().json(file_history)
    }
}

//fn read_files_from_db(query: String) -> std::result::Result<Vec<file>, Box<dyn std::error::Error>> {
//    let url = &*get_database_url();
//    //let url = &*format!("mysql://root:example@{}:3306/ThreeDeeFilesManagement", endpoint);
//    //println!("{}", url);
//    let pool = Pool::new(url)?;
//    let mut conn = pool.get_conn()?;
//    let files:Vec<file> = conn
//        .query_map(
//            query,
//            |(pk_id, name, author, created, size, downloads, rating)| {
//                file { pk_id, name, author, created, size, downloads, rating }
//            },
//        )?;
//    Ok(files)
//}
//
//fn read_file_history_from_db(query: String) -> std::result::Result<Vec<FileHistory>, Box<dyn std::error::Error>> {
//    let url = &*get_database_url();
//    //let url = &*format!("mysql://root:example@{}:3306/ThreeDeeFilesManagement", endpoint);
//    let pool = Pool::new(url)?;
//    let mut conn = pool.get_conn()?;
//
//    let selected_payments:Vec<FileHistory> = conn
//        .query_map(
//            query,
//            |(pk_id, changed, author, state, content)| {
//                FileHistory {pk_id, changed, author, state, content }
//            },
//        )?;
//
//    Ok(selected_payments)
//}