pub mod common;
use std::error::*;
use std::error::Error;
use postgres::*;
use tokio_postgres::{NoTls};

static PG_CONNECTION_STRING: &str =  "postgresql://postgres:mysecretpassword@192.168.176.2/threedeefilesmanagement";

pub async fn get_all_files() -> Result<Vec<common::File>, Box<dyn Error>> {
    let (client, connection) = tokio_postgres::connect(PG_CONNECTION_STRING, NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    let mut vec = Vec::new();
    let query = "SELECT \"Id\", \"Name\", \"Author\", \"Created\", \"Size\", \"Downloads\", \"AverageRating\" FROM file;";
    for row in client.query(query, &[]).await? {
        let person = common::File {
            pk_id: row.get(0),
            name: row.get(1),
            author: row.get(2),
            created: row.get(3),
            size: row.get(4),
            downloads: row.get(5),
            rating: row.get(6)
        };
        vec.push(person);
    }
    Ok(vec)
}

pub async fn get_single_file(id: u32) -> Result<Vec<common::File>, Box<dyn Error>> {
    let (client, connection) = tokio_postgres::connect(PG_CONNECTION_STRING, NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    let query = format!("SELECT \"Id\", \"Name\", \"Author\", \"Created\", \"Size\", \"Downloads\", \"AverageRating\" FROM file WHERE \"Id\" = {};", id);
    let mut vec:Vec<common::File> = Vec::new();
    for row in client.query(&*query, &[]).await? {
        let person = common::File {
            pk_id: row.get(0),
            name: row.get(1),
            author: row.get(2),
            created: row.get(3),
            size: row.get(4),
            downloads: row.get(5),
            rating: row.get(6)
        };
        vec.push(person);
    }
    Ok(vec)
}

pub async fn get_file_history(file_fk: u32) -> Result<Vec<common::FileHistory>, Box<dyn Error>> {
    let (client, connection) = tokio_postgres::connect(PG_CONNECTION_STRING, NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    let query = format!("SELECT \"Id\", \"ChangedOn\", \"ByAuthor\", \"State\", \"Content\" FROM filehistory WHERE \"File_fk\" = {};", file_fk);

    let mut vec = Vec::new();
    for row in &client.query(&*query, &[]).await? {
        let person = common::FileHistory {
            pk_id: row.get(0),
            changed: row.get(1),
            author: row.get(2),
            state: row.get(3),
            content: row.get(4)
        };
        vec.push(person);
    }
    Ok(vec)
}

