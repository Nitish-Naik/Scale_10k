#!/usr/bin/env python3
import csv
import sys
from collections import defaultdict
from decimal import Decimal
from pathlib import Path


def load(path):
    with Path(path).open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def money(value):
    return Decimal(str(value or "0")).quantize(Decimal("0.01"))


def index(rows):
    result = defaultdict(list)
    for row in rows:
        result[(row["reference"].strip().lower(), money(row["amount"]))].append(row)
    return result


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: python reconcile.py bank.csv ledger.csv")

    left = load(sys.argv[1])
    right = load(sys.argv[2])
    right_index = index(right)

    matched = []
    unmatched_left = []
    duplicate_keys = []

    for row in left:
        key = (row["reference"].strip().lower(), money(row["amount"]))
        matches = right_index.get(key, [])
        if len(matches) == 1:
            matched.append((row, matches[0]))
        elif len(matches) > 1:
            duplicate_keys.append(key)
        else:
            unmatched_left.append(row)

    left_keys = {
        (r["reference"].strip().lower(), money(r["amount"])) for r in left
    }
    unmatched_right = []
    for row in right:
        key = (row["reference"].strip().lower(), money(row["amount"]))
        if key not in left_keys:
            unmatched_right.append(row)

    report = {
        "bank_rows": len(left),
        "ledger_rows": len(right),
        "matched": len(matched),
        "unmatched_bank": unmatched_left,
        "unmatched_ledger": unmatched_right,
        "duplicate_match_keys": [
            {"reference": k[0], "amount": str(k[1])} for k in duplicate_keys
        ],
        "match_rate": round(len(matched) / len(left), 4) if left else 1,
    }

    print(report)


if __name__ == "__main__":
    main()
