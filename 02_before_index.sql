-- STEP 2 + 3 (BEFORE): case-insensitive searches with NO index on lower(author_name).
\echo '=== Q1: ILIKE with lower() (the query style asked in the task) ==='
EXPLAIN (ANALYZE, BUFFERS)
SELECT author_id, author_name FROM authors
WHERE lower(author_name) ILIKE lower('Jane Au%');

\echo '=== Q2: exact case-insensitive match ==='
EXPLAIN (ANALYZE, BUFFERS)
SELECT author_id, author_name FROM authors
WHERE lower(author_name) = lower('JANE AUSTEN');

\echo '=== Q3: case-insensitive prefix match using LIKE on lower() ==='
EXPLAIN (ANALYZE, BUFFERS)
SELECT author_id, author_name FROM authors
WHERE lower(author_name) LIKE lower('Jane Au') || '%';
