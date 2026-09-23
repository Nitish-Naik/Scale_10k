# Scale_10k Benchmark

Run this against the current Spring Boot + MySQL stack before making performance changes.

## Run

From repository root:

    .\benchmark\run-baseline.ps1

The script checks backend health, warms each endpoint, then makes 10 measured requests for:
- Offset pagination around item 9,000
- Cursor pagination around item 9,000

Results are written to benchmark/results/baseline.csv.

## Database-only baseline

Run benchmark/sql-baseline.sql in MySQL. It uses EXPLAIN ANALYZE for the offset and cursor queries and reports the current row count.

Do not change indexes, caching, pool size, or application architecture before recording this baseline.
