# Nicholasmus

## Running the app
Start postgres docker and postgraphile:
```
docker start nicholasmus-postgres
postgraphile -c postgres://postgres:password@localhost:5432/nicholasmus --jwt-secret secret --default-role anonymous --jwt-token-identifier nicholasmus.jwt_token -s nicholasmus_private,nicholasmus --watch
```

## Updating the database
```
psql --dbname=nicholasmus --host=localhost --port=5432  --user=postgres --echo-all --file=db.sql
```
## Setting up the app
```
docker run --name nicholasmus-postgres -e POSTGRES_PASSWORD=password -d -p 5432:5432 postgres:10.4
```
then connect to postgres db and create datbase named `nicholasmus`.
