-- Types
CREATE TYPE nicholasmus.jwt_token as (
  role        text,
  person_id   integer
);
comment on type nicholasmus.jwt_token is 'JWT Token type';


-- Tables
CREATE TABLE nicholasmus.user (
  id          serial primary key,
  username    text,
  created_at  timestamp default now()
);
comment on table nicholasmus.user is E'@omit create\n@omit update\n@omit delete\nUsers of Nicholasmus';

CREATE TABLE nicholasmus_private.account (
  user_id         integer primary key references nicholasmus.user(id) on delete cascade,
  email           text not null unique check (email ~* '^.+@.+\..+$'),
  password_hash   text not null,
  is_admin        boolean not null
);
comment on table nicholasmus_private.account is E'@omit\nAccounts for Nicholasmus';


-- Functions
create function nicholasmus.register_user (
  username  text,
  email     text,
  password  text
) returns text as $$
declare
  u_id integer;
begin
  insert into nicholasmus.user ("username") values
    (username)
    returning id into u_id;
  insert into nicholasmus_private.account (user_id, email, password_hash, is_admin) values
    (u_id, email, crypt(password, gen_salt('bf')), false);

  return username;
end;
$$ language plpgsql strict security definer;
comment on function nicholasmus.register_user(text, text, text) is 'Registers a single user';

create function nicholasmus.authenticate(
  email text,
  password text
) returns nicholasmus.jwt_token as $$
declare
  account nicholasmus_private.account;
begin
  select a.* into account
    from nicholasmus_private.account as a
    where a.email = $1;

  if account.password_hash = crypt(password, account.password_hash)
  then
    return ('nicholasmus_user', account.user_id)::nicholasmus.jwt_token;
  else
    return null;
  end if;
end;
$$ language plpgsql strict security definer;


-- Privileges
grant select on table nicholasmus.user to anonymous, authenticated;
grant update, delete on table nicholasmus.user to authenticated;

grant execute on function nicholasmus.register_user to anonymous;
grant execute on function nicholasmus.authenticate to anonymous, authenticated;
