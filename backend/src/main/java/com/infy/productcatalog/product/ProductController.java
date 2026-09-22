package com.infy.productcatalog.product;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.data.domain.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins="http://localhost:5173")
public class ProductController {
    private final ProductService service;
    public ProductController(ProductService service){this.service=service;}

    @GetMapping
    public Page<Product> getProducts(@RequestParam(required=false) String category,
        @RequestParam(defaultValue="0") @Min(0) int page,
        @RequestParam(defaultValue="40") @Min(1) @Max(100) int size){
        Pageable pageable=PageRequest.of(page,size,Sort.by(Sort.Direction.ASC,"id"));
        return category==null||category.isBlank()?service.getProducts(pageable):service.getProductsByCategory(category,pageable);
    }

    @GetMapping("/cursor")
    public CursorProductResponse getProductsAfterId(
        @RequestParam(defaultValue="0") long lastId,
        @RequestParam(defaultValue="40") @Min(1) @Max(100) int size){
        return service.getProductsAfterId(lastId,size);
    }
}