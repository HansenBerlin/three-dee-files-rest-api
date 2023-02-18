pub mod file {

    use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
    use crate::database::database_connection::*;
    use crate::models::file::PostFile;

    #[get("/")]
    pub async fn hello() -> impl Responder {
        HttpResponse::Ok().body("3D Files Management APIv1")
    }

    #[utoipa::path(responses(
    (status = 200, description = "OK", body = Vec<File>),
    (status = 404, description = "Files not found", body = String)))]
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

    #[utoipa::path(responses(
    (status = 200, description = "OK", body = File),
    (status = 500, description = "Internal Server Error", body = String),
    (status = 404, description = "Files not found", body = String)))]
    #[get("/files/{id}")]
    pub async fn get_file(path: web::Path<(u32,)>) -> impl Responder {
        let file = get_single_file(path.into_inner().0)
            .await.expect("Internal Server Error");
        if file.is_empty(){
            HttpResponse::NotFound().json("Files not found")
        }
        else{
            HttpResponse::Ok().json(&file[0])
        }
    }

    #[utoipa::path(
        request_body = PostFile,
        responses(
            (status = 201, description = "File created successfully.", body = String),
            (status = 500, description = "Internal Server Error", body = String),
            (status = 404, description = "Files not found", body = String)
            )
        )
    ]
    #[post("/files")]
    pub async fn add_file(req: web::Json<PostFile>) -> impl Responder {
        let new_file = PostFile {
            name: String::from(&req.name),
            author: String::from(&req.author),
            size: req.size
        };
        let response = add_new_file(new_file).await.expect("File could not be added");
        HttpResponse::Ok().json(response)
    }

    #[utoipa::path(responses(
    (status = 200, description = "OK", body = Vec<FileHistory>),
    (status = 500, description = "Internal Server Error", body = String),
    (status = 404, description = "File history for id not found.", body = String)))]
    #[get("/files/{id}/history")]
    pub async fn get_file_history(path: web::Path<(u32,)>) -> impl Responder {
        let file_history = get_history(path.into_inner().0)
            .await.expect("Error during query");
        if file_history.is_empty(){
            HttpResponse::NotFound().json("File history for id not found")
        }
        else{
            HttpResponse::Ok().json(file_history)
        }
    }
}
