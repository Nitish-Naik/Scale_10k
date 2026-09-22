package com.infy.productcatalog.product;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "products")
public class Product {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false, length = 100) private String name;
    @Column(length = 50) private String color;
    @Column(precision = 10, scale = 2) private BigDecimal price;
    @Column(length = 50) private String category;
    @Column(name = "image_url", length = 500) private String imageUrl;
    protected Product() {}
    public Long getId(){return id;} public String getName(){return name;} public String getColor(){return color;}
    public BigDecimal getPrice(){return price;} public String getCategory(){return category;} public String getImageUrl(){return imageUrl;}
}