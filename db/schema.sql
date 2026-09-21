CREATE DATABASE IF NOT EXISTS scale_10k;
USE scale_10k;

CREATE TABLE IF NOT EXISTS products (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  color VARCHAR(50),
  price DECIMAL(10,2),
  category VARCHAR(50),
  image_url VARCHAR(500),
  source VARCHAR(50) DEFAULT 'seed',
  source_product_id VARCHAR(100),
  source_url VARCHAR(1000),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_product_source (source, source_product_id),
  KEY idx_products_category_id (category, id)
);