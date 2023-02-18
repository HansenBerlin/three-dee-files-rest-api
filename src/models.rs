pub mod file {

    use serde::{Serialize, Deserialize};
    use utoipa::ToSchema;

    #[derive(Serialize, Deserialize, Debug, ToSchema)]
    pub struct File {
        pub pk_id: i32,
        pub name: String,
        pub author: String,
        pub created: String,
        pub size: i64,
        pub downloads: i32,
        pub rating: f32
    }

    #[derive(Serialize, Deserialize, Debug, ToSchema)]
    pub struct PostFile {
        pub name: String,
        pub author: String,
        pub size: i64,
    }

    #[derive(Serialize, Deserialize, Debug, ToSchema)]
    pub struct FileHistory {
        pub pk_id: i32,
        pub changed: String,
        pub author: String,
        pub state: String,
        pub content: String
    }
}
