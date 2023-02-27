CREATE TABLE user_account
(
  "id" SERIAL PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "first_name" varchar(255) NOT NULL ,
  "last_name" varchar(255) NOT NULL ,
  "mail" varchar(255) NOT NULL,
  "member_since" timestamp NOT NULL ,
  "two_factor" bool NOT NULL  
);

CREATE TABLE two_factor
(
    "id" SERIAL PRIMARY KEY ,
    "totp" varchar(128) NOT NULL ,
    "user_fk" integer NOT NULL ,
    CONSTRAINT "two_factor_user_id_fk"
        FOREIGN KEY ("user_fk") REFERENCES user_account ("id")
);

CREATE TABLE two_factor_recovery_codes
(
  "id" SERIAL PRIMARY KEY,
  "code" varchar(16) NOT NULL ,
  "user_fk" integer NOT NULL ,
  CONSTRAINT "two_factor_recovery_codes_user_id_fk"
    FOREIGN KEY ("user_fk") REFERENCES user_account ("id")
);

-- ToDo need to add more at implementation
CREATE TABLE token
(
  "id" SERIAL PRIMARY KEY ,
  "token" varchar(512) NOT NULL ,
  "expire" timestamp NOT NULL ,
  "user_fk" integer NOT NULL ,
  CONSTRAINT "token_user_id_fk"
    FOREIGN KEY ("user_fk") REFERENCES user_account ("id")
);

CREATE TABLE manufacturer
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) NOT NULL ,
    "contact" varchar(1024) ,
    "website" varchar(512)
);

CREATE TABLE printer
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) NOT NULL ,
    "release" timestamp,
    "manufacturer_fk" integer,
    CONSTRAINT "printer_manufacturer_id_fk"
        FOREIGN KEY ("manufacturer_fk") REFERENCES Manufacturer ("id")
);

CREATE TABLE material_group
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) 
);

CREATE TABLE material
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) NOT NULL ,
    "color" varchar(255),
    "temperature_nozzle" float,
    "temperature_bed" float,
    "material_group_fk" integer not null ,
    CONSTRAINT "material_material_group_id_fk"
        FOREIGN KEY ("material_group_fk") REFERENCES material_group ("id"),
    "manufacturer_fk" integer NOT NULL,
    CONSTRAINT "material_manufacturer_id_fk"
        FOREIGN KEY ("manufacturer_fk") REFERENCES manufacturer ("id")
);

CREATE TABLE category
(
    "name" varchar(255) PRIMARY KEY 
);

CREATE TABLE model
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) NOT NULL ,
    "created" timestamp NOT NULL ,
    "author" integer NOT NULL,
    CONSTRAINT "model_user_account_id_fk"
        FOREIGN KEY ("author") REFERENCES user_account ("id"),
    "modified" timestamp NOT NULL ,
    "category_fk" varchar(255),
    CONSTRAINT "model_category_id_fk"
        FOREIGN KEY ("category_fk") REFERENCES category ("name")    
);

CREATE TABLE file
(
    "id" SERIAL PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "author" integer NOT NULL,
    CONSTRAINT "file_user_account_id_fk"
        FOREIGN KEY ("author") REFERENCES user_account ("id"),
    "created" timestamp NOT NULL,
    "size" bigint NOT NULL,
    "downloads" integer NOT NULL,
    "average_Rating" real NOT NULL
);

CREATE TABLE model_file
(
    "id" SERIAL PRIMARY KEY ,
    "model_fk" integer NOT NULL ,
    CONSTRAINT "model_file_model_id_fk"
        FOREIGN KEY ("model_fk") REFERENCES model ("id"),
    "file_fk" integer NOT NULL ,
    CONSTRAINT "model_file_id_fk"
        FOREIGN KEY ("file_fk") REFERENCES file ("id")
);

--ToDo Settings need to specify
CREATE TABLE gcode
(
    "id" SERIAL PRIMARY KEY ,
    "name" varchar(255) NOT NULL ,
    "settings" varchar(255),
    "model_file_fk" integer NOT NULL ,
    CONSTRAINT "gcode_model_file_id_fk"
        FOREIGN KEY ("model_file_fk") REFERENCES model_file ("id"),
    "file_fk" integer NOT NULL ,
    CONSTRAINT "gcode_file_id_fk"
        FOREIGN KEY ("file_fk") REFERENCES file ("id"),
    "printer_fk" integer NOT NULL ,
    CONSTRAINT "gcode_printer_id_fk"
        FOREIGN KEY ("printer_fk") REFERENCES Printer ("id"),
    "material_fk" integer NOT NULL ,
    CONSTRAINT "gcode_material_id_fk"
        FOREIGN KEY ("material_fk") REFERENCES material ("id")
);

CREATE TABLE file_history
(
    "id" SERIAL PRIMARY KEY,
    "changed_on" timestamp NOT NULL,
    "by_author" integer NOT NULL,
    CONSTRAINT "file_history_user_account_id_fk"
        FOREIGN KEY ("by_author") REFERENCES user_account ("id"),
    "state" varchar(255) NOT NULL,
    "content" text NOT NULL,
    "file_old_fk" integer NOT NULL,
    CONSTRAINT "file_history_file_old_id_fk"
        FOREIGN KEY ("file_old_fk") REFERENCES file ("id"),
    "file_new_fk" integer NOT NULL,
    CONSTRAINT "file_history_file_new_id_fk"
        FOREIGN KEY ("file_new_fk") REFERENCES file ("id")
);
