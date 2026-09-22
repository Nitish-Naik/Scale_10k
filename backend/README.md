# Spring Boot Backend

Backend for the Scale_10k product catalog.

Stack: Java 17, Spring Boot, Spring Data JPA/Hibernate, MySQL, HikariCP, Actuator.

Run with Maven from the backend directory after setting DB_PASSWORD.

Environment variables:
- DB_URL (default jdbc:mysql://localhost:3306/scale_10k)
- DB_USERNAME (default root)
- DB_PASSWORD

Endpoints:
- GET /api/products?page=0&size=40
- GET /api/products?category=Electronics&page=0&size=40
- GET /api/products/cursor?lastId=0&size=40
- GET /actuator/health
- GET /actuator/metrics/http.server.requests

The cursor endpoint is used by the React frontend for the 10k+ item scaling experiment.
