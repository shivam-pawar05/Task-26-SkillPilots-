-- STEP 1: expression index on lower(author_name).
-- Plain btree: serves equality (Q2) and range/ordering on lower(author_name).
CREATE INDEX idx_authors_lower_name
    ON authors (lower(author_name));

-- Same expression with text_pattern_ops: lets btree serve prefix LIKE 'abc%' (Q3)
-- even when the database collation is not "C".
CREATE INDEX idx_authors_lower_name_pattern
    ON authors (lower(author_name) text_pattern_ops);

ANALYZE authors;   -- refresh planner statistics

\di+ idx_authors_lower_name*
