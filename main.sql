-- Schemas
CREATE SCHEMA nicholasmus_private;
CREATE SCHEMA nicholasmus;


-- Enable pgcrypto
create extension if not exists "pgcrypto";


-- Roles
create role anonymous;
create role authenticated;


-- Default privileges
alter default privileges revoke execute on functions from public;

grant usage on schema nicholasmus to anonymous, authenticated;
