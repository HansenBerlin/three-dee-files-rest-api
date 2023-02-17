use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct File {
    pub pk_id: i32,
    pub name: String,
    pub author: String,
    pub created: std::time::SystemTime,
    pub size: i64,
    pub downloads: i32,
    pub rating: f32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FileHistory {
    pub pk_id: i32,
    pub changed: std::time::SystemTime,
    pub author: String,
    pub state: String,
    pub content: String
}