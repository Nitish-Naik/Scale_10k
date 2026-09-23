USE scale_10k;

-- Offset pagination around item 9,000
EXPLAIN ANALYZE
SELECT * FROM products ORDER BY id LIMIT 40 OFFSET 9000;

-- Cursor pagination around item 9,000
EXPLAIN ANALYZE
SELECT * FROM products WHERE id > 9000 ORDER BY id LIMIT 40;

SELECT COUNT(*) AS product_count FROM products;
