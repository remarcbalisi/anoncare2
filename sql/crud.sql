

CREATE OR REPLACE FUNCTION store_role(par_rolename TEXT)
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


select store_role('system administrator');
select store_role('doctor');
select store_role('nurse');

-----------------------VALIDATING USERNAME AND EMAIL IF EXIST
create or replace function check_username(in par_username text) returns text as
  $$ declare local_response text; local_id bigint;
    begin

      select into local_id id from Userinfo where username = par_username;

      if local_id isnull then
        local_response = 'OK';
      else
        local_response = 'EXISTED';

      end if;

      return local_response;

    end;
  $$
  language 'plpgsql';

create or replace function check_mail(in par_mail text) returns text as
  $$ declare local_response text; local_id bigint;
    begin

      select into local_id id from Userinfo where email = par_mail;

      if local_id isnull then
        local_response = 'OK';
      else
        local_response = 'EXISTED';

      end if;

      return local_response;

    end;
  $$
  language 'plpgsql';