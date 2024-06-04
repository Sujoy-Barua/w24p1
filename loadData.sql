-- Insert Users into Users Table
INSERT INTO Users (user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender)
SELECT DISTINCT user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender
FROM project1.Public_User_Information;

-- Insert Friends Relations into Friends Table
INSERT INTO Friends(user1_id, user2_id)
SELECT DISTINCT 
    LEAST(user1_id, user2_id) AS user1_id,
    GREATEST(user1_id, user2_id) AS user2_id
FROM project1.Public_Are_Friends;

-- Insert Cities into Cities Table
INSERT INTO Cities (city_name, state_name, country_name)
SELECT DISTINCT current_city, current_state, current_country
FROM project1.Public_User_Information
UNION
SELECT DISTINCT hometown_city, hometown_state, hometown_country
FROM project1.Public_User_Information
UNION
SELECT DISTINCT event_city, event_state, event_country
FROM project1.Public_Event_Information;

-- Insert User_Current_Cities Relationships
INSERT INTO User_Current_Cities (user_id, current_city_id)
SELECT DISTINCT p.user_id, c.city_id
FROM project1.Public_User_Information p
JOIN Cities c
    ON c.city_name = p.current_city
    AND c.state_name = p.current_state
    AND c.country_name = p.current_country;

-- Insert User_Hometown_Cities Relationships
INSERT INTO User_Hometown_Cities (user_id, hometown_city_id)
SELECT DISTINCT p.user_id, c.city_id
FROM project1.Public_User_Information p
JOIN Cities c
    ON c.city_name = p.hometown_city
    AND c.state_name = p.hometown_state
    AND c.country_name = p.hometown_country;

-- Insert Programs into Programs
INSERT INTO Programs (institution, concentration, degree)
SELECT DISTINCT institution_name, program_concentration, program_degree
FROM project1.Public_User_Information
WHERE institution_name IS NOT NULL;

-- Fill Education Table
INSERT INTO Education (user_id, program_id, program_year)
SELECT u.user_id, p.program_id, u.program_year
FROM project1.Public_User_Information u
JOIN Programs p
    ON p.institution = u.institution_name
    AND p.concentration = u.program_concentration
    AND p.degree = u.program_degree
WHERE u.institution_name IS NOT NULL
    AND u.program_concentration IS NOT NULL
    AND u.program_degree IS NOT NULL;

-- Fill User_Events
INSERT INTO User_Events (event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, event_city_id, event_start_time, event_end_time)
SELECT p.event_id, p.event_creator_id, p.event_name, p.event_tagline, p.event_description, p.event_host, p.event_type, p.event_subtype, p.event_address, c.city_id, p.event_start_time, p.event_end_time
FROM project1.Public_Event_Information p
JOIN Cities c ON c.city_name = p.event_city;

SET AUTOCOMMIT OFF;

-- Fill Albums
INSERT INTO Albums (album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id)
SELECT DISTINCT album_id, owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id
FROM project1.Public_Photo_Information;

-- Fill Photos
INSERT INTO Photos (photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link)
SELECT photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link
FROM project1.Public_Photo_Information;

-- Fill Tags
INSERT INTO Tags (tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y)
SELECT photo_id, tag_subject_id, tag_created_time, tag_x_coordinate, tag_y_coordinate
FROM project1.Public_Tag_Information;

COMMIT;
SET AUTOCOMMIT ON;