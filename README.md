# Expression Index for Case-Insensitive Author Search (PostgreSQL)

Run: `createdb bookstore && ./run_all.sh bookstore postgres`
(or run the sql/ files 01 -> 04 in order in psql; `\echo` and `\di+` are psql commands - in pgAdmin remove those lines.)

| Step | File |
|---|---|
| 1 Create index on lower(author_name) | sql/03_create_index.sql |
| 2 SELECT with ILIKE + lower() | sql/02_before_index.sql, sql/04_after_index.sql (Q1) |
| 3 Compare plans before/after | results/before.txt vs results/after.txt |
| 4 Brief report | REPORT.md (fill in your measured numbers) |
