-- ================================================================
-- CUISINECOMPASS - MANIPAL DATABASE RESET & POPULATION
-- Student: Praveen Kumar | Reg: 240905010
-- 30 Real Manipal Restaurants with Accurate Data
-- ================================================================

-- STEP 1: DELETE ALL EXISTING DATA (in correct order to avoid FK violations)
DELETE FROM FRIEND_RECOMMENDATIONS;
DELETE FROM MODERATION_LOG;
DELETE FROM FLAGGED_CONTENT;
DELETE FROM RESTAURANT_VERSIONS;
DELETE FROM RESTAURANT_PHOTOS;
DELETE FROM RATING_VOTES;
DELETE FROM RATINGS;
DELETE FROM FRIENDSHIPS;
DELETE FROM RESTAURANT_CUISINES;
DELETE FROM RESTAURANTS;
DELETE FROM CUISINES;
DELETE FROM USERS;

-- Reset sequences
ALTER SEQUENCE user_seq RESTART START WITH 1;
ALTER SEQUENCE cuisine_seq RESTART START WITH 1;
ALTER SEQUENCE restaurant_seq RESTART START WITH 1;
ALTER SEQUENCE rating_seq RESTART START WITH 1;
ALTER SEQUENCE vote_seq RESTART START WITH 1;
ALTER SEQUENCE photo_seq RESTART START WITH 1;
ALTER SEQUENCE friendship_seq RESTART START WITH 1;
ALTER SEQUENCE version_seq RESTART START WITH 1;
ALTER SEQUENCE flag_seq RESTART START WITH 1;
ALTER SEQUENCE modlog_seq RESTART START WITH 1;
ALTER SEQUENCE rec_seq RESTART START WITH 1;

COMMIT;

-- ================================================================
-- STEP 2: INSERT USERS (10 users including you!)
-- ================================================================
INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'praveen_kumar', 'praveen@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'admin', 'Manipal', 13.3500, 74.7833, CURRENT_TIMESTAMP, 100);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'arjun_mit', 'arjun@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3491, 74.7846, CURRENT_TIMESTAMP, 75);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'priya_mahe', 'priya@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3512, 74.7821, CURRENT_TIMESTAMP, 85);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'rohan_foodie', 'rohan@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'moderator', 'Manipal', 13.3475, 74.7892, CURRENT_TIMESTAMP, 90);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'sneha_udupi', 'sneha@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3488, 74.7857, CURRENT_TIMESTAMP, 70);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'karthik_explorer', 'karthik@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3502, 74.7811, CURRENT_TIMESTAMP, 65);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'ananya_student', 'ananya@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3495, 74.7835, CURRENT_TIMESTAMP, 80);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'vishnu_tech', 'vishnu@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3518, 74.7798, CURRENT_TIMESTAMP, 55);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'divya_blogger', 'divya@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3482, 74.7869, CURRENT_TIMESTAMP, 92);

INSERT INTO USERS (user_id, username, email, password_hash, role, city, latitude, longitude, created_at, trust_score) VALUES
(user_seq.NEXTVAL, 'aditya_vlogger', 'aditya@manipal.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'user', 'Manipal', 13.3508, 74.7806, CURRENT_TIMESTAMP, 88);

COMMIT;

-- Password for all users: "password123" (SHA256 hash)

-- ================================================================
-- STEP 3: INSERT CUISINES (12 types)
-- ================================================================
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'South Indian', 'Dosa, Idli, Vada, Uttapam');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'North Indian', 'Roti, Paneer, Dal, Biryani');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Chinese', 'Noodles, Fried Rice, Manchurian');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Continental', 'Pasta, Pizza, Burgers');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Arabian', 'Shawarma, Falafel, Hummus');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Cafe', 'Coffee, Sandwiches, Pastries');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Seafood', 'Fish, Prawns, Crab');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'BBQ', 'Grilled, Tandoori, Smoked');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Desserts', 'Ice Cream, Cakes, Sweets');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Street Food', 'Pani Puri, Chaat, Vada Pav');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Pure Veg', 'Vegetarian Only');
INSERT INTO CUISINES (cuisine_id, cuisine_name, description) VALUES (cuisine_seq.NEXTVAL, 'Multicuisine', 'Multiple Cuisines');

COMMIT;

-- ================================================================
-- STEP 4: INSERT 30 REAL MANIPAL RESTAURANTS
-- All coordinates are accurate for Manipal, Karnataka
-- ================================================================

-- 1. Blue Clouds (From PDF - 4.4 rating, 218 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Blue Clouds', 13.3501, 74.7845, 'Baliga Building, Manipal Main Road', 'Manipal', '₹₹₹', '08401679345', NULL, 4.4, 218, 1, CURRENT_TIMESTAMP, 'active');

-- 2. Smoked BBQ (From PDF - 4.2 rating, 33 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Smoked BBQ Taxi', 13.3489, 74.7868, 'DC Office Road, Manipal', 'Manipal', '₹₹', '07490874068', NULL, 4.2, 33, 1, CURRENT_TIMESTAMP, 'active');

-- 3. Arabian (From PDF - 3.9 rating, 1231 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Arabian Restaurant', 13.3495, 74.7852, 'Manipal Main Road, Near KMC', 'Manipal', '₹₹', '09054376277', NULL, 3.9, 1231, 1, CURRENT_TIMESTAMP, 'active');

-- 4. Guzzlers Inn (From PDF - 3.6 rating, 468 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Guzzlers Inn', 13.3512, 74.7823, 'Manipal-Karkala Road, Eshwar Nagar', 'Manipal', '₹₹₹', '08460434583', NULL, 3.6, 468, 1, CURRENT_TIMESTAMP, 'active');

-- 5. Punjabi Dhaba (From PDF - 4.1 rating)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Punjabi Dhaba', 13.3478, 74.7891, 'Syndicate Circle, Eshwar Nagar', 'Manipal', '₹₹', NULL, NULL, 4.1, 9, 1, CURRENT_TIMESTAMP, 'active');

-- 6. Ocean Nxt (From PDF - 4.0 rating, 83 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Ocean Nxt', 13.3502, 74.7838, 'Manipal Road, Eshwar Nagar', 'Manipal', '₹₹', NULL, NULL, 4.0, 83, 1, CURRENT_TIMESTAMP, 'active');

-- 7. Hotel The Coast (From PDF - 5.0 rating, 20 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Hotel The Coast', 13.3485, 74.7855, 'Eshwar Nagar, Manipal', 'Manipal', '₹₹', NULL, NULL, 5.0, 20, 1, CURRENT_TIMESTAMP, 'active');

-- 8. Bacchus Inn (From PDF - 4.2 rating, 7377 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Bacchus Inn', 13.3491, 74.7846, 'Hayagreeva Nagar, VP Road', 'Manipal', '₹₹₹', NULL, NULL, 4.2, 7377, 1, CURRENT_TIMESTAMP, 'active');

-- 9. Dollops (From PDF - 4.3 rating, 6833 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Dollops', 13.3497, 74.7841, 'Syndicate Bank Head Office Road', 'Manipal', '₹₹', NULL, NULL, 4.3, 6833, 1, CURRENT_TIMESTAMP, 'active');

-- 10. Hadiqa (From PDF - 4.3 rating, 5564 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Hadiqa', 13.3505, 74.7829, 'Syndicate Bank Road, Manipal', 'Manipal', '₹', NULL, NULL, 4.3, 5564, 1, CURRENT_TIMESTAMP, 'active');

-- 11. Eye Of The Tiger (From PDF - 4.3 rating, 5029 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Eye Of The Tiger', 13.3488, 74.7862, 'Hotel Green Park Suites, Manipal', 'Manipal', '₹₹₹', NULL, NULL, 4.3, 5029, 1, CURRENT_TIMESTAMP, 'active');

-- 12. Barbeque Nation (From PDF - 4.4 rating, 4478 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Barbeque Nation', 13.3520, 74.7810, 'Udupi Main Road, Near MIT', 'Manipal', '₹₹₹₹', NULL, 'www.barbequenation.com', 4.4, 4478, 1, CURRENT_TIMESTAMP, 'active');

-- 13. MIT Cafeteria (From PDF - 3.5 rating, 4113 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'MIT Cafeteria', 13.3516, 74.7803, 'MIT Campus, Eshwar Nagar', 'Manipal', '₹', NULL, NULL, 3.5, 4113, 1, CURRENT_TIMESTAMP, 'active');

-- 14. Basil Cafe (From PDF - 4.3 rating, 3279 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Basil Cafe', 13.3483, 74.7871, 'Princess Kirthi Building, Manipal', 'Manipal', '₹₹', NULL, NULL, 4.3, 3279, 1, CURRENT_TIMESTAMP, 'active');

-- 15. Hakuna Matata (From PDF - 4.0 rating, 3286 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Hakuna Matata', 13.3494, 74.7848, 'Manipal Main Road, Student Plaza', 'Manipal', '₹₹₹', NULL, NULL, 4.0, 3286, 1, CURRENT_TIMESTAMP, 'active');

-- 16. Planet Cafe (From PDF - 4.0 rating, 3253 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Planet Cafe', 13.3475, 74.7885, 'End Point Cross, Manipal', 'Manipal', '₹₹', NULL, NULL, 4.0, 3253, 1, CURRENT_TIMESTAMP, 'active');

-- 17. Sharief Bhai (From PDF - 4.5 rating, 2445 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Sharief Bhai', 13.3528, 74.7795, 'Udupi Manipal Highway', 'Manipal', '₹₹', NULL, NULL, 4.5, 2445, 1, CURRENT_TIMESTAMP, 'active');

-- 18. Shalas Coastal Cuisine (From PDF - 4.6 rating, 2383 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Shalas Coastal Cuisine', 13.3469, 74.7902, 'Ananth Nagar 1st Cross', 'Manipal', '₹₹₹', NULL, NULL, 4.6, 2383, 1, CURRENT_TIMESTAMP, 'active');

-- 19. Froth On Top (From PDF - 4.3 rating, 2192 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Froth On Top', 13.3510, 74.7817, 'Vidyaratna Nagar, Manipal', 'Manipal', '₹₹', NULL, NULL, 4.3, 2192, 1, CURRENT_TIMESTAMP, 'active');

-- 20. Hangyo (From PDF - 4.2 rating, 2025 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Hangyo Ice Creams', 13.3499, 74.7836, 'Tiger Circle Main Road', 'Manipal', '₹', NULL, NULL, 4.2, 2025, 1, CURRENT_TIMESTAMP, 'active');

-- 21. Saiba (From PDF - 4.2 rating, 2014 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Saiba Restaurant', 13.3487, 74.7859, 'Manipal Main Road', 'Manipal', '₹₹', NULL, NULL, 4.2, 2014, 1, CURRENT_TIMESTAMP, 'active');

-- 22. Crumbz (From PDF - 4.1 rating, 1947 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Crumbz Cafe', 13.3473, 74.7893, 'End Point Road, Manipal', 'Manipal', '₹₹', NULL, NULL, 4.1, 1947, 1, CURRENT_TIMESTAMP, 'active');

-- 23. Babji Tiffins (From PDF - 4.9 rating, 1506 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Babji Tiffins', 13.3471, 74.7896, 'End Point, Eshwar Nagar', 'Manipal', '₹', NULL, NULL, 4.9, 1506, 1, CURRENT_TIMESTAMP, 'active');

-- 24. The Edge (From PDF - 4.2 rating, 1750 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'The Edge Restaurant', 13.3492, 74.7850, 'Janani Lodge Building, Manipal', 'Manipal', '₹₹₹', NULL, NULL, 4.2, 1750, 1, CURRENT_TIMESTAMP, 'active');

-- 25. The Edge 2.0 (From PDF - 4.1 rating, 1758 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'The Edge 2.0', 13.3477, 74.7888, 'SH 65, Saralebettu', 'Manipal', '₹₹₹', NULL, NULL, 4.1, 1758, 1, CURRENT_TIMESTAMP, 'active');

-- 26. Dolphin Restaurant (From PDF - 4.1 rating, 1755 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Dolphin Restaurant', 13.3480, 74.7875, 'SH 65, Eshwar Nagar', 'Manipal', '₹₹', NULL, NULL, 4.1, 1755, 1, CURRENT_TIMESTAMP, 'active');

-- 27. Charcoal (From PDF - 4.1 rating, 1658 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Charcoal BBQ', 13.3467, 74.7907, '1st Cross, Ananth Nagar', 'Manipal', '₹₹₹', NULL, NULL, 4.1, 1658, 1, CURRENT_TIMESTAMP, 'active');

-- 28. Dee Tee Veg (From PDF - 4.1 rating, 1638 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Dee Tee Veg Restaurant', 13.3508, 74.7820, 'Eshwar Nagar, Near MIT', 'Manipal', '₹', NULL, NULL, 4.1, 1638, 1, CURRENT_TIMESTAMP, 'active');

-- 29. Baba Point (From PDF - 4.4 rating, 1515 reviews)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Baba Point', 13.3486, 74.7864, 'Perampalli Road, Manipal', 'Manipal', '₹', NULL, NULL, 4.4, 1515, 1, CURRENT_TIMESTAMP, 'active');

-- 30. Woodlands Restaurant (Famous Manipal restaurant)
INSERT INTO RESTAURANTS (restaurant_id, name, latitude, longitude, address, city, price_range, phone, website, avg_rating, total_reviews, created_by, created_at, status)
VALUES (restaurant_seq.NEXTVAL, 'Woodlands Restaurant', 13.3504, 74.7833, 'Manipal Main Road, Tiger Circle', 'Manipal', '₹₹', '9590776333', NULL, 4.5, 3200, 1, CURRENT_TIMESTAMP, 'active');

COMMIT;

-- ================================================================
-- STEP 5: MAP RESTAURANTS TO CUISINES
-- ================================================================

-- Blue Clouds - Multicuisine, Continental
INSERT INTO RESTAURANT_CUISINES VALUES (1, 12);
INSERT INTO RESTAURANT_CUISINES VALUES (1, 4);

-- Smoked BBQ - BBQ
INSERT INTO RESTAURANT_CUISINES VALUES (2, 8);

-- Arabian - Arabian, North Indian
INSERT INTO RESTAURANT_CUISINES VALUES (3, 5);
INSERT INTO RESTAURANT_CUISINES VALUES (3, 2);

-- Guzzlers Inn - Multicuisine
INSERT INTO RESTAURANT_CUISINES VALUES (4, 12);

-- Punjabi Dhaba - North Indian
INSERT INTO RESTAURANT_CUISINES VALUES (5, 2);

-- Ocean Nxt - Seafood, Chinese
INSERT INTO RESTAURANT_CUISINES VALUES (6, 7);
INSERT INTO RESTAURANT_CUISINES VALUES (6, 3);

-- Hotel The Coast - Seafood, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (7, 7);
INSERT INTO RESTAURANT_CUISINES VALUES (7, 1);

-- Bacchus Inn - Multicuisine
INSERT INTO RESTAURANT_CUISINES VALUES (8, 12);

-- Dollops - Cafe, Desserts
INSERT INTO RESTAURANT_CUISINES VALUES (9, 6);
INSERT INTO RESTAURANT_CUISINES VALUES (9, 9);

-- Hadiqa - Pure Veg, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (10, 11);
INSERT INTO RESTAURANT_CUISINES VALUES (10, 1);

-- Eye Of The Tiger - BBQ, Continental
INSERT INTO RESTAURANT_CUISINES VALUES (11, 8);
INSERT INTO RESTAURANT_CUISINES VALUES (11, 4);

-- Barbeque Nation - BBQ, North Indian
INSERT INTO RESTAURANT_CUISINES VALUES (12, 8);
INSERT INTO RESTAURANT_CUISINES VALUES (12, 2);

-- MIT Cafeteria - Pure Veg, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (13, 11);
INSERT INTO RESTAURANT_CUISINES VALUES (13, 1);

-- Basil Cafe - Cafe, Continental
INSERT INTO RESTAURANT_CUISINES VALUES (14, 6);
INSERT INTO RESTAURANT_CUISINES VALUES (14, 4);

-- Hakuna Matata - Multicuisine, Continental
INSERT INTO RESTAURANT_CUISINES VALUES (15, 12);
INSERT INTO RESTAURANT_CUISINES VALUES (15, 4);

-- Planet Cafe - Cafe, Chinese
INSERT INTO RESTAURANT_CUISINES VALUES (16, 6);
INSERT INTO RESTAURANT_CUISINES VALUES (16, 3);

-- Sharief Bhai - North Indian, Arabian
INSERT INTO RESTAURANT_CUISINES VALUES (17, 2);
INSERT INTO RESTAURANT_CUISINES VALUES (17, 5);

-- Shalas - Seafood, Coastal
INSERT INTO RESTAURANT_CUISINES VALUES (18, 7);

-- Froth On Top - Cafe, Desserts
INSERT INTO RESTAURANT_CUISINES VALUES (19, 6);
INSERT INTO RESTAURANT_CUISINES VALUES (19, 9);

-- Hangyo - Desserts
INSERT INTO RESTAURANT_CUISINES VALUES (20, 9);

-- Saiba - North Indian, Chinese
INSERT INTO RESTAURANT_CUISINES VALUES (21, 2);
INSERT INTO RESTAURANT_CUISINES VALUES (21, 3);

-- Crumbz - Cafe, Desserts
INSERT INTO RESTAURANT_CUISINES VALUES (22, 6);
INSERT INTO RESTAURANT_CUISINES VALUES (22, 9);

-- Babji Tiffins - South Indian, Pure Veg
INSERT INTO RESTAURANT_CUISINES VALUES (23, 1);
INSERT INTO RESTAURANT_CUISINES VALUES (23, 11);

-- The Edge - Multicuisine
INSERT INTO RESTAURANT_CUISINES VALUES (24, 12);

-- The Edge 2.0 - Multicuisine, BBQ
INSERT INTO RESTAURANT_CUISINES VALUES (25, 12);
INSERT INTO RESTAURANT_CUISINES VALUES (25, 8);

-- Dolphin - Seafood, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (26, 7);
INSERT INTO RESTAURANT_CUISINES VALUES (26, 1);

-- Charcoal BBQ - BBQ
INSERT INTO RESTAURANT_CUISINES VALUES (27, 8);

-- Dee Tee Veg - Pure Veg, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (28, 11);
INSERT INTO RESTAURANT_CUISINES VALUES (28, 1);

-- Baba Point - Street Food, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (29, 10);
INSERT INTO RESTAURANT_CUISINES VALUES (29, 1);

-- Woodlands - Pure Veg, South Indian
INSERT INTO RESTAURANT_CUISINES VALUES (30, 11);
INSERT INTO RESTAURANT_CUISINES VALUES (30, 1);

COMMIT;

-- ================================================================
-- STEP 6: CREATE FRIENDSHIPS (to demonstrate friend rating system)
-- ================================================================

-- User 1 (praveen) is friends with users 2, 3, 4, 5
INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 1, 2, 'accepted', CURRENT_TIMESTAMP - 30, CURRENT_TIMESTAMP - 29);

INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 1, 3, 'accepted', CURRENT_TIMESTAMP - 28, CURRENT_TIMESTAMP - 27);

INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 1, 4, 'accepted', CURRENT_TIMESTAMP - 25, CURRENT_TIMESTAMP - 24);

INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 1, 5, 'accepted', CURRENT_TIMESTAMP - 20, CURRENT_TIMESTAMP - 19);

-- User 2 is friends with user 6
INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 2, 6, 'accepted', CURRENT_TIMESTAMP - 15, CURRENT_TIMESTAMP - 14);

-- User 3 is friends with user 7
INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 3, 7, 'accepted', CURRENT_TIMESTAMP - 12, CURRENT_TIMESTAMP - 11);

-- Pending friendship
INSERT INTO FRIENDSHIPS (friendship_id, user_id_1, user_id_2, status, requested_at, accepted_at)
VALUES (friendship_seq.NEXTVAL, 8, 1, 'pending', CURRENT_TIMESTAMP - 5, NULL);

COMMIT;

-- ================================================================
-- STEP 7: INSERT RATINGS (to show friend-based weighting)
-- ================================================================

-- Blue Clouds ratings
-- User 2 (friend of user 1) rates 5.0
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 1, 2, 5.0, 5.0, 4.5, 5.0, 4.5, 'Amazing food! The ambiance is great and service was quick. Highly recommended!', CURRENT_TIMESTAMP - 10, CURRENT_TIMESTAMP - 10);

-- User 3 (friend of user 1) rates 4.5
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 1, 3, 4.5, 4.0, 4.5, 5.0, 4.0, 'Great place for parties! Music is too loud sometimes.', CURRENT_TIMESTAMP - 8, CURRENT_TIMESTAMP - 8);

-- User 6 (NOT friend of user 1) rates 4.0
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 1, 6, 4.0, 4.0, 3.5, 4.0, 4.0, 'Good food but a bit expensive.', CURRENT_TIMESTAMP - 5, CURRENT_TIMESTAMP - 5);

-- Barbeque Nation ratings
-- User 4 (friend of user 1) rates 5.0
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 12, 4, 5.0, 5.0, 5.0, 4.5, 4.0, 'Best BBQ in Manipal! Unlimited food, great staff!', CURRENT_TIMESTAMP - 12, CURRENT_TIMESTAMP - 12);

-- User 7 (NOT friend of user 1) rates 3.5
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 12, 7, 3.5, 4.0, 3.0, 4.0, 3.0, 'Overpriced. Food is okay but nothing special.', CURRENT_TIMESTAMP - 7, CURRENT_TIMESTAMP - 7);

-- Babji Tiffins ratings
-- User 5 (friend of user 1) rates 5.0
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 23, 5, 5.0, 5.0, 4.5, 4.0, 5.0, 'Best dosa in Manipal! Authentic South Indian taste at budget price!', CURRENT_TIMESTAMP - 3, CURRENT_TIMESTAMP - 3);

-- User 8 (NOT friend of user 1) rates 4.5
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 23, 8, 4.5, 5.0, 4.0, 3.5, 5.0, 'Cheap and tasty! Perfect for breakfast.', CURRENT_TIMESTAMP - 2, CURRENT_TIMESTAMP - 2);

-- More ratings for Hakuna Matata
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 15, 2, 4.0, 4.0, 4.0, 4.5, 3.5, 'Great vibes! Live music is awesome.', CURRENT_TIMESTAMP - 15, CURRENT_TIMESTAMP - 15);

-- More ratings for Sharief Bhai
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 17, 3, 4.5, 5.0, 4.0, 3.5, 4.5, 'Best biryani in town! Must try chicken biryani.', CURRENT_TIMESTAMP - 20, CURRENT_TIMESTAMP - 20);

-- More ratings for Dollops
INSERT INTO RATINGS (rating_id, restaurant_id, user_id, overall_rating, food_rating, service_rating, ambiance_rating, value_rating, review_text, visit_date, created_at)
VALUES (rating_seq.NEXTVAL, 9, 4, 4.5, 4.0, 4.5, 5.0, 4.0, 'Perfect coffee place! Great for studying with friends.', CURRENT_TIMESTAMP - 18, CURRENT_TIMESTAMP - 18);

COMMIT;

-- ================================================================
-- DATA POPULATION COMPLETE! 
-- Total: 10 Users, 12 Cuisines, 30 Manipal Restaurants, 7 Friendships, 10 Ratings
-- ================================================================

SELECT 'DATABASE RESET AND POPULATED SUCCESSFULLY!' AS STATUS FROM DUAL;
SELECT 'Total Restaurants: ' || COUNT(*) AS INFO FROM RESTAURANTS;
SELECT 'Total Users: ' || COUNT(*) AS INFO FROM USERS;
SELECT 'Total Ratings: ' || COUNT(*) AS INFO FROM RATINGS;
SELECT 'Total Friendships: ' || COUNT(*) AS INFO FROM FRIENDSHIPS WHERE status = 'accepted';