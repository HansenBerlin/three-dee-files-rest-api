//#![allow(unused)]

mod database;
mod models;
mod routes;
use actix_web::{ App, HttpServer };
use std::error::Error;
use utoipa::{ openapi::security::{ApiKey, ApiKeyValue, SecurityScheme}, Modify, OpenApi };
use utoipa_swagger_ui::SwaggerUi;
use crate::routes::file::*;
use crate::models::file::*;

#[tokio::main]
async fn main() -> Result<(), impl Error> {
    env_logger::init();

    #[derive(OpenApi)]
    #[openapi(
    paths(
    get_files
    ),
    components(
    schemas(File, FileHistory)
    )
    )]
    struct ApiDoc;

    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(get_file)
            .service(get_files)
            .service(get_file_history)
            .service(SwaggerUi::new("/swagger-ui/{_:.*}")
                    .url("/api-doc/openapi.json", ApiDoc::openapi()))
    })
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}