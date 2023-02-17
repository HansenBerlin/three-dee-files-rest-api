

CREATE TABLE test.File
(
    "Id" SERIAL PRIMARY KEY,
    "Name" varchar(255) NOT NULL,
    "Author" varchar(255) NOT NULL,
    "Created" timestamp NOT NULL,
    "Size" bigint NOT NULL,
    "Downloads" integer NOT NULL,
    "AverageRating" real NOT NULL
);

CREATE TABLE test.FileHistory
(
    "Id" SERIAL PRIMARY KEY,
    "ChangedOn" timestamp NOT NULL,
    "ByAuthor" varchar(255) NOT NULL,
    "State" varchar(255) NOT NULL,
    "Content" text NOT NULL,
    "File_fk" integer NOT NULL,
    CONSTRAINT "FileHistory_File_Id_fk"
        FOREIGN KEY ("File_fk") REFERENCES test.File ("Id")
);

-- Insert dummy data into the file table
INSERT INTO test.File ("Name", "Author", "Created", "Size", "Downloads", "AverageRating")
VALUES
    ('jazzcat.stl', 'Maxine Jenkins', '2022-05-01 10:30:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 10, ROUND(RANDOM()*(5-1)+1)),
    ('quantumquark.stl', 'Caitlin Lee', '2022-02-14 13:45:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 5, ROUND(RANDOM()*(5-1)+1)),
    ('silverstar.stl', 'Rocco Ramirez', '2022-08-27 08:20:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 8, ROUND(RANDOM()*(5-1)+1)),
    ('neonbutterfly.stl', 'Janae Burke', '2022-11-21 16:10:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 3, ROUND(RANDOM()*(5-1)+1)),
    ('astrodrone.stl', 'Deangelo Burgess', '2022-04-08 09:00:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 12, ROUND(RANDOM()*(5-1)+1)),
    ('cyberpuma.stl', 'Leila Mccormick', '2022-09-05 14:15:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 7, ROUND(RANDOM()*(5-1)+1)),
    ('frostblade.stl', 'Jessie Moreno', '2022-06-30 11:25:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 9, ROUND(RANDOM()*(5-1)+1)),
    ('emeraldgolem.stl', 'Randy Bennett', '2022-03-12 15:50:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 6, ROUND(RANDOM()*(5-1)+1)),
    ('glitchunicorn.stl', 'Simone Chandler', '2022-10-17 07:40:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 4, ROUND(RANDOM()*(5-1)+1)),
    ('dystopianangel.stl', 'Reese Ferguson', '2022-07-23 12:35:00', FLOOR(RANDOM()*(100000000-100000+1)+100000), 11, ROUND(RANDOM()*(5-1)+1));

WITH files AS (
    SELECT
        "Id",
        "Name"
    FROM
        test.File
    WHERE
            "Name" LIKE '%.stl%'
), history AS (
    SELECT
        f."Id" AS File_fk,
        (DATE '2023-02-17' - (FLOOR(RANDOM() * 3650) || ' days')::INTERVAL)::TIMESTAMP AS ChangedOn,
            CONCAT(n.first, ' ', n.last) AS ByAuthor,
        CASE
            WHEN RANDOM() < 0.5 THEN 'Changed'
            ELSE 'Modified'
            END AS State,
        CONCAT('This is the content for ', f."Name", ' version ', s.seq) AS Content
    FROM
        files f
            JOIN (
            SELECT 1 AS seq UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
            UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
        ) s ON RANDOM() < 0.6
            CROSS JOIN (
            SELECT
                'Emma' AS first, 'Williams' AS last
            UNION ALL SELECT 'Noah', 'Johnson'
            UNION ALL SELECT 'Liam', 'Brown'
            UNION ALL SELECT 'Ava', 'Jones'
            UNION ALL SELECT 'Olivia', 'Garcia'
            UNION ALL SELECT 'Sophia', 'Miller'
            UNION ALL SELECT 'Isabella', 'Davis'
            UNION ALL SELECT 'Mia', 'Rodriguez'
            UNION ALL SELECT 'Charlotte', 'Martinez'
            UNION ALL SELECT 'Amelia', 'Hernandez'
            UNION ALL SELECT 'Evelyn', 'Lopez'
            UNION ALL SELECT 'Abigail', 'Gonzalez'
            UNION ALL SELECT 'Harper', 'Perez'
            UNION ALL SELECT 'Emily', 'Gomez'
            UNION ALL SELECT 'Elizabeth', 'Smith'
            UNION ALL SELECT 'Sofia', 'Lee'
            UNION ALL SELECT 'Victoria', 'Liu'
            UNION ALL SELECT 'Chloe', 'Brown'
            UNION ALL SELECT 'Camila', 'Kim'
            UNION ALL SELECT 'Madison', 'Yang'
        ) n
)
INSERT INTO
    test.FileHistory ("File_fk", "ChangedOn", "ByAuthor", "State", "Content")
SELECT
    File_fk,
    ChangedOn,
    ByAuthor,
    State,
    Content
FROM
    history
ORDER BY
    RANDOM()
LIMIT 100;
