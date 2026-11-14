-- Authors table with 500,000 rows of mixed-case names (deterministic, no randomness).
DROP TABLE IF EXISTS authors CASCADE;
CREATE TABLE authors (
    author_id   SERIAL PRIMARY KEY,
    author_name TEXT NOT NULL,
    country     TEXT
);

INSERT INTO authors (author_name, country)
SELECT
    CASE i % 3
        WHEN 0 THEN initcap(fn || ' ' || ln)      -- Mary Smith
        WHEN 1 THEN upper(fn || ' ' || ln)        -- MARY SMITH
        ELSE        lower(fn || ' ' || ln)        -- mary smith
    END || ' ' || i,
    (ARRAY['India','USA','UK','Japan','Brazil'])[1 + i % 5]
FROM (
    SELECT i,
           (ARRAY['James','Mary','Robert','Patricia','John','Jennifer','Michael','Linda','David','Priya'])[1 + (i * 7) % 10] AS fn,
           (ARRAY['Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Patel','Sharma'])[1 + (i * 11) % 10] AS ln
    FROM generate_series(1, 500000) AS i
) t;

-- A known single target row with odd casing
INSERT INTO authors (author_name, country) VALUES ('jAnE AuStEn', 'UK');

ANALYZE authors;
SELECT count(*) AS total_rows FROM authors;
