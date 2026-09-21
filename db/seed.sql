USE scale_10k;

INSERT INTO products (name, color, price, category, image_url, source, source_product_id)
SELECT CONCAT(ELT(((n - 1) % 10) + 1, 'Laptop', 'Phone', 'Headphones', 'Monitor', 'Keyboard', 'Mouse', 'Camera', 'Tablet', 'Speaker', 'Watch'), ' Product ', n),
  ELT(((n - 1) % 8) + 1, 'Black', 'White', 'Silver', 'Blue', 'Red', 'Green', 'Gray', 'Gold'),
  ROUND(10 + (n * 37.17) % 4990, 2),
  ELT(((n - 1) % 8) + 1, 'Electronics', 'Computers', 'Audio', 'Accessories', 'Cameras', 'Mobile', 'Gaming', 'Wearables'),
  CONCAT('https://picsum.photos/seed/product-', n, '/300/300'), 'seed', CONCAT('seed-', n)
FROM (
  SELECT ones.n + tens.n * 10 + hundreds.n * 100 + thousands.n * 1000 + tenthousands.n * 10000 AS n
  FROM (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) ones
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) hundreds
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) thousands
  CROSS JOIN (SELECT 0 n UNION ALL SELECT 1) tenthousands
) numbers
WHERE n BETWEEN 1 AND 10000
  AND NOT EXISTS (SELECT 1 FROM products p WHERE p.source = 'seed' AND p.source_product_id = CONCAT('seed-', n));