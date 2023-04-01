-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student: Bishnu Bhusal
-- Description: a database of occupations

CREATE DATABASE occupations;

\c occupations

DROP TABLE IF EXISTS Occupations;

-- TODO: create table Occupations
CREATE TABLE occupations (
    id SERIAL PRIMARY KEY,
    Code VARCHAR(20) NOT NULL,
    Occupation VARCHAR(200) NOT NULL,
    "Job Family" VARCHAR(200) NOT NULL
);

-- TODO: populate table Occupations
\copy occupations
(Code, Occupation, "Job Family") from /var/lib/postgresql/data/occupations.csv DELIMITER ',' CSV HEADER;

-- TODO: a) the total number of occupations (expect 1016).
SELECT COUNT(*) AS Total FROM occupations;

-- TODO: b) a list of all job families in alphabetical order (expect 23).
SELECT DISTINCT "Job Family" FROM occupations ORDER BY "Job Family";
-- OTHER WAY
SELECT DISTINCT "Job Family" FROM occupations ORDER BY 1;

-- TODO: c) the total number of job families (expect 23)
SELECT COUNT(DISTINCT "Job Family") AS Total FROM occupations;

-- TODO: d) the total number of occupations per job family in alphabetical order of job family.
SELECT "Job Family", COUNT(*) AS Total FROM occupations GROUP BY "Job Family" ORDER BY 1;

-- TODO: e) the number of occupations in the "Computer and Mathematical" job family (expect 38)
SELECT COUNT(*) FROM occupations WHERE "Job Family" = 'Computer and Mathematical';

-- BONUS POINTS

-- TODO: f) an alphabetical list of occupations in the "Computer and Mathematical" job family.
SELECT Occupation FROM occupations WHERE "Job Family" = 'Computer and Mathematical'ORDER BY 1;

-- TODO: g) an alphabetical list of occupations in the "Computer and Mathematical" job family that begins with the word "Database"
SELECT Occupation FROM occupations WHERE "Job Family" = 'Computer and Mathematical' AND Occupation LIKE 'Database%' ORDER BY 1;
