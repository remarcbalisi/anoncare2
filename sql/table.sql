CREATE TABLE Role (
  id       SERIAL8 PRIMARY KEY,
  rolename TEXT
);

-- User is a key word, so the psql parser gets confused when you try to do:
-- create table user
-- but 
-- create table "user" (...
-- will work. All references to the table will have to be in quotes as well.
-- FWIW, I'd use a different table name. e.g. yoyodyne_user.
CREATE TABLE Userinfo (
  id           SERIAL8 PRIMARY KEY,
  fname        TEXT        NOT NULL,
  mname        TEXT        NOT NULL,
  lname        TEXT        NOT NULL,
  email        TEXT        NOT NULL,
  username     TEXT UNIQUE NOT NULL,
  password     TEXT        NOT NULL,
  role_id      INT REFERENCES Role (id),
  is_available BOOLEAN
);