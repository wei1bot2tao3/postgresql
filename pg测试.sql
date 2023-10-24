CREATE USER myuser WITH PASSWORD 'mypassword';
CREATE DATABASE testtable
    OWNER = myuser
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;

\c testtable;
CREATE TABLE mytable (
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(100),
                         age INTEGER
);

GRANT ALL PRIVILEGES ON mytable TO myuser;
GRANT CREATE ON DATABASE testtable TO myuser;
INSERT INTO mytable (name, age) VALUES ('John', 25), ('Jane', 30);
SELECT * FROM mytable;
DELETE FROM mytable WHERE age > 25;
GRANT ALL PRIVILEGES ON mytable TO myuser;

ALTER USER postgres WITH PASSWORD 'password';



SET ROLE myuser;
SET SESSION AUTHORIZATION your_username;

SELECT COUNT(*) FROM pg_user;


GRANT SELECT ON mytable TO myuser;
\c your_database_name your_username;

GRANT ALL PRIVILEGES ON mytable TO myuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myuser;

SELECT setting AS port
FROM pg_settings
WHERE name = 'port';


GRANT SELECT ON TABLE mytable TO myuser;
psql -h 172.31.254.180 -p 5432 -U myuser -d testtable
