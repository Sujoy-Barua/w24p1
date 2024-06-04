-- Insert data into view_user_information
-- Attempt one
CREATE VIEW View_User_Information AS
SELECT u.user_id, u.first_name, u.last_name, u.year_of_birth, u.month_of_birth, u.day_of_birth, u.gender, c.city_name AS current_city, c.state_name AS current_state, c.country_name AS current_country, h.city_name AS hometown_city, h.state_name AS hometown_state, h.country_name AS hometown_country, p.institution AS institution_name, e.program_year, p.concentration AS program_concentration, p.degree AS program_degree
FROM Users u
LEFT JOIN User_Current_Cities u_cur ON u.user_id = u_cur.user_id
LEFT JOIN Cities c ON u_cur.current_city_id = c.city_id
LEFT JOIN User_Hometown_Cities u_home ON u.user_id = u_home.user_id
LEFT JOIN Cities h ON u_home.hometown_city_id = h.city_id
LEFT JOIN Education e ON u.user_id = e.user_id
LEFT JOIN Programs p ON e.program_id = p.program_id;

-- Insert data into view_are_friends
CREATE VIEW View_Are_Friends AS
SELECT user1_id, user2_id
FROM Friends;

-- Insert data into view_photo_information
CREATE VIEW View_Photo_Information AS
SELECT a.album_id, a.album_owner_id, a.cover_photo_id, a.album_name, a.album_created_time, a.album_modified_time, a.album_link, a.album_visibility, p.photo_id, p.photo_caption, p.photo_created_time, p.photo_modified_time, p.photo_link
FROM Albums a
LEFT JOIN Photos p ON a.album_id = p.album_id;

-- Insert data into view_event_information
CREATE VIEW View_Event_Information AS
SELECT u.event_id, u.event_creator_id, u.event_name, u.event_tagline, u.event_description, u.event_host, u.event_type, u.event_subtype, u.event_address, c.city_name, c.state_name, c.country_name, u.event_start_time, u.event_end_time
FROM User_Events u
LEFT JOIN Cities c ON u.event_city_id = c.city_id;

-- Insert data into view_tag_information
CREATE VIEW View_Tag_Information AS
SELECT tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y
FROM Tags;