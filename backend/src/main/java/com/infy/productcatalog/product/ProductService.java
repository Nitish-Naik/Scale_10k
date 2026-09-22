package com.infy.productcatalog.product;

import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductService {
    private final ProductRepository repository;
    public ProductService(ProductRepository repository){this.repository=repository;}
    public Page<Product> getProducts(Pageable pageable){return repository.findAll(pageable);}
    public Page<Product> getProductsByCategory(String category, Pageable pageable){return repository.findByCategory(category,pageable);}
    public CursorProductResponse getProductsAfterId(long lastId,int size){
        Slice<Product> slice=repository.findByIdGreaterThanOrderByIdAsc(lastId,PageRequest.of(0,size));
        List<Product> products=slice.getContent();
        Long nextCursor=products.isEmpty()?lastId:products.get(products.size()-1).getId();
        return new CursorProductResponse(products,nextCursor,slice.hasNext());
    }
}