echo "Drop database"
psql --dbname=nicholasmus --host=localhost --port=5432  --user=postgres --file=clear_db.sql
echo "---"
echo "---"
echo "Create database"
psql --dbname=nicholasmus --host=localhost --port=5432  --user=postgres --file=main.sql
psql --dbname=nicholasmus --host=localhost --port=5432  --user=postgres --file=auth.sql
echo "---"
echo "---"
echo "Insert test data"
psql --dbname=nicholasmus --host=localhost --port=5432  --user=postgres --file=./test_data/users.sql
