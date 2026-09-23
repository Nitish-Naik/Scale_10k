# Reconciliation Investigator — Validation Prototype

Purpose: determine whether businesses will pay to explain why two transaction datasets do not match.

The prototype deliberately starts with CSVs rather than accounting integrations.

## Run

```bash
python reconcile.py bank.csv ledger.csv
```

It performs:
- normalized exact matching
- amount mismatch detection
- unmatched-record detection
- duplicate detection
- summary statistics

The next experiment is to add deterministic fuzzy matching and then an AI explanation layer.

## Validation question

Do finance/accounting operators prefer:
1. a reconciliation tool that performs matching, or
2. a tool that investigates and explains the remaining exceptions?

The second is the intended wedge.
