# Scraper Doctor — Validation Prototype

Purpose: measure whether scraper reliability is a painful, monetizable problem.

## What this prototype measures

- row-count loss
- null-rate regression
- schema drift
- new/missing fields
- duplicate-rate changes
- value distribution anomalies

It compares a known-good baseline export with a current export and emits a machine-readable incident report.

## Run

```bash
python detect.py baseline.json current.json
```

Exit code:
- 0 = no material regression
- 1 = regression detected

## Validation experiment

Run this against 3 real production-like scraper outputs and record:

| Metric | Baseline | Current | Result |
|---|---:|---:|---|
| rows | | | |
| null rate | | | |
| schema changes | | | |
| duplicates | | | |
| anomalies | | | |

The business question is not whether detection works. It is whether detecting these failures saves enough engineering/data-loss cost that a team will pay for continuous monitoring.
