package com.infy.productcatalog.product;

import org.springframework.data.domain.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    Page<Product> findByCategory(String category, Pageable pageable);
    Slice<Product> findByIdGreaterThanOrderByIdAsc(Long lastId, Pageable pageable);
}