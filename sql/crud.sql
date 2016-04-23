

CREATE OR REPLACE FUNCTION newrole(par_rolename TEXT)
  RETURNS TEXT AS
$$
DECLARE
  loc_name TEXT;
  loc_res  TEXT;
BEGIN

  SELECT INTO loc_name rolename
  FROM Role
  WHERE rolename = par_rolename;

  IF loc_name ISNULL
  THEN
    INSERT INTO Role (rolename) VALUES (par_rolename);
    loc_res = 'OK';

  ELSE
    loc_res = 'EXISTED';

  END IF;
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';


 select newrole('doctor');
 select newrole('nurse');
 select newrole('system administrator');

--[POST] Create user info
--select newuserinfo('Josiah', 'Timonera', 'Regencia', 'jetregencia@gmail.com', 'josiah.regencia', 'k6bkW9nUoO8^&C+~', true);
CREATE OR REPLACE FUNCTION newuserinfo(par_fname    TEXT, par_mname TEXT, par_lname TEXT,
                                       par_email    TEXT, par_username TEXT,
                                       par_password TEXT, par_role INT, par_available BOOLEAN)
  RETURNS TEXT AS
$$

DECLARE
  loc_res TEXT;

BEGIN

  --        username := par_fname || '.' || par_lname;
  --        random_password := generate_password();

  INSERT INTO Userinfo (fname, mname, lname, email, username, password, role_id, is_available)
  VALUES (par_fname, par_mname, par_lname, par_email, par_username, par_password, par_role, par_available);


  loc_res = 'OK';
  RETURN loc_res;
END;
$$
LANGUAGE 'plpgsql';


--Generates password of a user
CREATE OR REPLACE FUNCTION generate_password()
  RETURNS TEXT AS
$$
DECLARE
  characters      TEXT;
  random_password TEXT;
  len             INT4;
  placevalue      INT4;

BEGIN
  characters := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()+=';
  len := length(characters);
  random_password := '';


  WHILE (length(random_password) < 16) LOOP

    placevalue := int4(random() * len);
    random_password := random_password || substr(characters, placevalue + 1, 1);

  END LOOP;

  RETURN random_password;
END;
$$
LANGUAGE 'plpgsql';


--[GET] Retrieve information of users
--select * from getUserinfo();
CREATE OR REPLACE FUNCTION getuserinfo(OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT)
  RETURNS SETOF RECORD AS
$$
SELECT
  fname,
  mname,
  lname,
  email,
  username
FROM Userinfo;
$$
LANGUAGE 'sql';

--[GET] Retrieve information of a specific user
--select getuserinfoid(1);
CREATE OR REPLACE FUNCTION getuserinfoid(IN par_id INT, OUT TEXT, OUT TEXT, OUT TEXT, OUT TEXT,
                                         OUT       TEXT)
  RETURNS SETOF RECORD AS
$$
SELECT
  fname,
  mname,
  lname,
  email,
  username
FROM Userinfo
WHERE par_id = id;
$$
LANGUAGE 'sql';

--[PUT] Update password of a user
--select updatepassword(1,'pass1');
CREATE OR REPLACE FUNCTION updatepassword(IN par_id INT, IN par_new_password TEXT)
  RETURNS TEXT AS
$$
DECLARE
  response TEXT;

BEGIN
  UPDATE Userinfo
  SET password = par_new_password
  WHERE id = par_id;
  response := 'OK';

  RETURN response;
END;
$$
LANGUAGE 'plpgsql';


create or replace function getuserroleid(in par_username text, in par_pass text) returns int as
  $$
    declare
      user_role_id int;
    begin
      select into user_role_id role_id from Userinfo where username = par_username and password = par_pass;

      return user_role_id;
    end;
  $$
  language 'plpgsql';
