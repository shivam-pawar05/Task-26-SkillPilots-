# Performance Report: Expression Index for Case-Insensitive Author Search

**Database:** PostgreSQL ____  **Rows in authors:** 500,001  **Date:** ________

## 1. Problem
Searches such as `WHERE lower(author_name) ILIKE ...` apply a function to every row,
so a normal index on `author_name` cannot help and PostgreSQL scans the whole table.

## 2. Solution
    CREATE INDEX idx_authors_lower_name ON authors (lower(author_name));
    CREATE INDEX idx_authors_lower_name_pattern ON authors (lower(author_name) text_pattern_ops);
An expression index stores the already-lowercased value, so the planner can search it directly.

## 3. Results (copy from results/before.txt and results/after.txt)
| Query | Plan BEFORE | Time BEFORE (ms) | Plan AFTER | Time AFTER (ms) | Speed-up |
|---|---|---|---|---|---|
| Q1 `lower(col) ILIKE lower('Jane Au%')` | Seq Scan | | | | |
| Q2 `lower(col) = lower('JANE AUSTEN')` | Seq Scan | | Index Scan / Bitmap Heap Scan | | |
| Q3 `lower(col) LIKE lower('Jane Au')||'%'` | Seq Scan | | Index/Bitmap Scan on pattern index | | |

Look for "Execution Time:" at the bottom of each plan.

## 4. Observations
- Q2 and Q3 should switch from Seq Scan to an index scan and drop from tens/hundreds of ms to well under a few ms.
- Q1 (ILIKE): a btree index cannot be used by the ILIKE operator, so it normally still shows Seq Scan.
  Write the search as Q2 or Q3 to benefit from the index. For "contains" searches (`%jane%`) use a
  pg_trgm GIN index instead: `CREATE EXTENSION pg_trgm; CREATE INDEX ... USING gin (lower(author_name) gin_trgm_ops);`
- Trade-off: the indexes use extra disk space (see `\di+` output) and slow inserts/updates slightly.

## 5. Conclusion
(2-3 sentences using your measured numbers.)
