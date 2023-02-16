CREATE DATABASE ThreeDeeFilesManagement;
USE ThreeDeeFilesManagement;

create table ThreeDeeFilesManagement.File
(
    Id            int auto_increment
        primary key,
    Name          varchar(255) not null,
    Author        varchar(255) not null,
    Created       datetime     not null,
    Size          bigint       not null,
    Downloads     int          not null,
    AverageRating float        not null
);

create table ThreeDeeFilesManagement.FileHistory
(
    Id        int auto_increment
        primary key,
    ChangedOn datetime     not null,
    ByAuthor  varchar(255) not null,
    State     varchar(255) not null,
    Content   text         not null,
    File_fk   int          not null,
    constraint FileHistory_File_Id_fk
        foreign key (File_fk) references ThreeDeeFilesManagement.File (Id)
);



-- Insert dummy data into the File table
INSERT INTO ThreeDeeFilesManagement.File (Name, Author, Created, Size, Downloads, AverageRating)
VALUES
    ('jazzcat.stl', 'Maxine Jenkins', '2022-05-01 10:30:00', FLOOR(RAND()*(100000000-100000+1)+100000), 10, ROUND(RAND()*(5-1)+1,1)),
    ('quantumquark.stl', 'Caitlin Lee', '2022-02-14 13:45:00', FLOOR(RAND()*(100000000-100000+1)+100000), 5, ROUND(RAND()*(5-1)+1,1)),
    ('silverstar.stl', 'Rocco Ramirez', '2022-08-27 08:20:00', FLOOR(RAND()*(100000000-100000+1)+100000), 8, ROUND(RAND()*(5-1)+1,1)),
    ('neonbutterfly.stl', 'Janae Burke', '2022-11-21 16:10:00', FLOOR(RAND()*(100000000-100000+1)+100000), 3, ROUND(RAND()*(5-1)+1,1)),
    ('astrodrone.stl', 'Deangelo Burgess', '2022-04-08 09:00:00', FLOOR(RAND()*(100000000-100000+1)+100000), 12, ROUND(RAND()*(5-1)+1,1)),
    ('cyberpuma.stl', 'Leila Mccormick', '2022-09-05 14:15:00', FLOOR(RAND()*(100000000-100000+1)+100000), 7, ROUND(RAND()*(5-1)+1,1)),
    ('frostblade.stl', 'Jessie Moreno', '2022-06-30 11:25:00', FLOOR(RAND()*(100000000-100000+1)+100000), 9, ROUND(RAND()*(5-1)+1,1)),
    ('emeraldgolem.stl', 'Randy Bennett', '2022-03-12 15:50:00', FLOOR(RAND()*(100000000-100000+1)+100000), 6, ROUND(RAND()*(5-1)+1,1)),
    ('glitchunicorn.stl', 'Simone Chandler', '2022-10-17 07:40:00', FLOOR(RAND()*(100000000-100000+1)+100000), 4, ROUND(RAND()*(5-1)+1,1)),
    ('dystopianangel.stl', 'Reese Ferguson', '2022-07-23 12:35:00', FLOOR(RAND()*(100000000-100000+1)+100000), 11, ROUND(RAND()*(5-1)+1,1));




INSERT INTO ThreeDeeFilesManagement.FileHistory (ChangedOn, ByAuthor, State, Content, File_fk)
SELECT
    DATE_ADD(CURDATE(), INTERVAL -RAND()*3650 DAY) AS ChangedOn,
    CONCAT(names.first, ' ', names.last) AS ByAuthor,
    CASE
        WHEN RAND() < 0.5 THEN 'Changed'
        ELSE 'Modified'
        END AS State,
    CONCAT('This is the content for ', files.Name, ' version ', seq) AS Content,
    files.Id AS File_fk
FROM
    ThreeDeeFilesManagement.File AS files
        CROSS JOIN
    (SELECT
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
     UNION ALL SELECT 'Madison', 'Yang') AS names
        CROSS JOIN
    (SELECT 1 AS seq UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
     UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
     UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
     UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20) AS seq
WHERE
        files.Name LIKE '%.stl%'
ORDER BY RAND()
LIMIT 100;
