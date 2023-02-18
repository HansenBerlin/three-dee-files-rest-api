pub mod file {

    use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
    use crate::database::database_connection::*;

    #[get("/")]
    pub async fn hello() -> impl Responder {
        HttpResponse::Ok().body("3D Files Management APIv1")
    }

    #[utoipa::path(
    responses(
    (status = 200, description = "OK", body = Vec<File>),
    (status = 404, description = "Files not found", body = String)
    )
    )]
    #[get("/files")]
    pub async fn get_files() -> impl Responder {
        let files = get_all_files().await.expect("Error");
        if files.is_empty(){
            HttpResponse::NotFound().json("Files not found")
        }
        else{
            HttpResponse::Ok().json(files)
        }
    }

    #[get("/files/{id}")]
    pub async fn get_file(path: web::Path<(u32,)>) -> impl Responder {
        let file = get_single_file(path.into_inner().0)
            .await.expect("File not found. error during query");
        if file.is_empty(){
            HttpResponse::NotFound().json("Files not found")
        }
        else{
            HttpResponse::Ok().json(&file[0])
        }
    }

    #[get("/files/{id}/history")]
    pub async fn get_file_history(path: web::Path<(u32,)>) -> impl Responder {
        let file_history = get_history(path.into_inner().0)
            .await.expect("Error during query");
        if file_history.is_empty(){
            HttpResponse::NotFound().json("File History not found")
        }
        else{
            HttpResponse::Ok().json(file_history)
        }
    }

}
