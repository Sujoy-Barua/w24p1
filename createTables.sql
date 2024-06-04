-- Drop All Tables
-- DROP TABLE IF EXISTS Users, Friends, Cities, User_Current_Cities, User_Hometown_Cities, Messages, Programs, Education, User_Events, Participants, Albums, Photos, Tags;

-- Create Users Table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY NOT NULL,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    year_of_birth INTEGER,
    month_of_birth INTEGER,
    day_of_birth INTEGER,
    gender VARCHAR2(100)
);

-- Create Friends Table
CREATE TABLE Friends (
    user1_id INTEGER NOT NULL,
    user2_id INTEGER NOT NULL,
    PRIMARY KEY (user1_id, user2_id),
    CONSTRAINT friends_user1 FOREIGN KEY (user1_id) REFERENCES Users(user_id),
    CONSTRAINT friends_user2 FOREIGN KEY (user2_id) REFERENCES Users(user_id)
);

-- Order friends trigger - from p1 spec
CREATE TRIGGER Order_Friend_Pairs
    BEFORE INSERT ON Friends
    FOR EACH ROW
        DECLARE temp INTEGER;
        BEGIN
            IF :NEW.user1_id > :NEW.user2_id THEN
                temp := :NEW.user2_id;
                :NEW.user2_id := :NEW.user1_id;
                :NEW.user1_id := temp;
            END IF;
        END;
        
/

-- Create Cities Table
CREATE TABLE Cities (
    city_id INTEGER PRIMARY KEY NOT NULL,
    city_name VARCHAR2(100) NOT NULL,
    state_name VARCHAR2(100) NOT NULL,
    country_name VARCHAR2(100) NOT NULL, 
    CONSTRAINT no_dup_city UNIQUE (city_name, state_name, country_name)
);

-- Create unique city_id in Cities
CREATE SEQUENCE create_city_id
    START WITH 1
    INCREMENT BY 1;

CREATE TRIGGER city_id_trigger
    BEFORE INSERT ON Cities
    FOR EACH ROW
        BEGIN
            SELECT create_city_id.NEXTVAL INTO :NEW.city_id FROM DUAL;
        END;
/

-- Create User_Current_Cities
CREATE TABLE User_Current_Cities (
    user_id INTEGER PRIMARY KEY NOT NULL,
    current_city_id INTEGER NOT NULL,
    CONSTRAINT cur_cities_user FOREIGN KEY (user_id) REFERENCES Users,
    CONSTRAINT cur_cities_cities FOREIGN KEY (current_city_id) REFERENCES Cities(city_id)
);

-- Create User_Hometown_Cities
CREATE TABLE User_Hometown_Cities (
    user_id INTEGER PRIMARY KEY NOT NULL,
    hometown_city_id INTEGER NOT NULL,
    CONSTRAINT hometown_user FOREIGN KEY (user_id) REFERENCES Users,
    CONSTRAINT hometown_hometown FOREIGN KEY (hometown_city_id) REFERENCES Cities(city_id)
);

-- Create Messages Table
CREATE TABLE Messages (
    message_id INTEGER PRIMARY KEY NOT NULL,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message_content VARCHAR2(2000) NOT NULL,
    sent_time TIMESTAMP NOT NULL,
    CONSTRAINT messages_sender FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    CONSTRAINT messages_receiver FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

-- Create Programs Table
CREATE TABLE Programs (
    program_id INTEGER PRIMARY KEY NOT NULL,
    institution VARCHAR2(100) NOT NULL,
    concentration VARCHAR2(100) NOT NULL,
    degree VARCHAR2(100) NOT NULL,
    CONSTRAINT no_dup_programs UNIQUE (institution, concentration, degree)
);

-- Create unique program_id in Programs
CREATE SEQUENCE create_program_id
    START WITH 1
    INCREMENT BY 1;

CREATE TRIGGER program_id_trigger
    BEFORE INSERT ON Programs
    FOR EACH ROW
        BEGIN
            SELECT create_program_id.NEXTVAL INTO :NEW.program_id FROM DUAL;
        END;
/

-- Create Education Table
CREATE TABLE Education (
    user_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    program_year INTEGER NOT NULL,
    PRIMARY KEY (user_id, program_id),
    CONSTRAINT education_users FOREIGN KEY (user_id) REFERENCES Users,
    CONSTRAINT education_programs FOREIGN KEY (program_id) REFERENCES Programs
);


-- Create user events table
CREATE TABLE User_Events (
    event_id INTEGER PRIMARY KEY NOT NULL,
    event_creator_id INTEGER NOT NULL,
    event_name VARCHAR2(100) NOT NULL,
    event_tagline VARCHAR2(100),
    event_description VARCHAR2(100),
    event_host VARCHAR2(100),
    event_type VARCHAR2(100),
    event_subtype VARCHAR2(100),
    event_address VARCHAR2(2000),
    event_city_id INTEGER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    CONSTRAINT user_events_creator FOREIGN KEY (event_creator_id) REFERENCES Users(user_id),
    CONSTRAINT user_events_city FOREIGN KEY (event_city_id) REFERENCES Cities(city_id)
);


-- Create Participants Table
CREATE TABLE Participants (
    event_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    confirmation VARCHAR2(100) NOT NULL,
    CHECK (confirmation IN ('Attending', 'Unsure', 'Declines', 'Not_Replied')),
    PRIMARY KEY (event_id, user_id),
    CONSTRAINT participants_event FOREIGN KEY (event_id) REFERENCES User_Events,
    CONSTRAINT Participants_user FOREIGN KEY (user_id) REFERENCES Users
);


-- Create Albums Table
CREATE TABLE Albums (
    album_id INTEGER PRIMARY KEY NOT NULL,
    album_owner_id INTEGER NOT NULL,
    album_name VARCHAR2(100) NOT NULL,
    album_created_time TIMESTAMP NOT NULL,
    album_modified_time TIMESTAMP,
    album_link VARCHAR2(2000) NOT NULL,
    album_visibility VARCHAR2(100) NOT NULL,
    cover_photo_id INTEGER NOT NULL,
    CHECK (album_visibility IN ('Everyone', 'Friends', 'Friends_Of_Friends', 'Myself')),
    CONSTRAINT albums_owner FOREIGN KEY (album_owner_id) REFERENCES Users(user_id)
);


-- Create Photos Table
CREATE TABLE Photos (
    photo_id INTEGER PRIMARY KEY NOT NULL,
    album_id INTEGER NOT NULL,
    photo_caption VARCHAR2(2000),
    photo_created_time TIMESTAMP NOT NULL,
    photo_modified_time TIMESTAMP,
    photo_link VARCHAR2(2000) NOT NULL
);

-- Add Foreign Key for cover_photo_id in Albums after Photos gets created
ALTER TABLE Albums
ADD CONSTRAINT coverphototophotos
FOREIGN KEY (cover_photo_id) REFERENCES Photos(photo_id)
INITIALLY DEFERRED DEFERRABLE;

ALTER TABLE Photos
ADD CONSTRAINT phototoalbum
FOREIGN KEY (album_id) REFERENCES Albums
INITIALLY DEFERRED DEFERRABLE;

-- Create Tags Table
CREATE TABLE Tags (
    tag_photo_id INTEGER NOT NULL,
    tag_subject_id INTEGER NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMBER NOT NULL,
    tag_y NUMBER NOT NULL,
    PRIMARY KEY (tag_photo_id, tag_subject_id),
    CONSTRAINT tags_photo FOREIGN KEY (tag_photo_id) REFERENCES Photos(photo_id),
    CONSTRAINT tags_subject FOREIGN KEY (tag_subject_id) REFERENCES Users(user_id)
);