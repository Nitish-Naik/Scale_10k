# Database scripts

Create the schema:
```bash
mysql -u root -p < schema.sql
```

Seed 10,000 products:
```bash
mysql -u root -p < seed.sql
```

Reset:
```bash
mysql -u root -p < reset.sql
```

The source columns let seeded and scraped records coexist and support source-aware upserts.