package com.infy.productcatalog.product;

import java.util.List;

public record CursorProductResponse(List<Product> content, Long nextCursor, boolean hasNext) {}