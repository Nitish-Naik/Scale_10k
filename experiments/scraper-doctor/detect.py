#!/usr/bin/env python3
import json
import sys
from collections import Counter
from pathlib import Path


def load(path):
    data = json.loads(Path(path).read_text())
    if not isinstance(data, list):
        raise ValueError(f"{path} must contain a JSON array")
    return data


def profile(rows):
    fields = sorted({k for row in rows for k in row})
    null_rates = {}
    for field in fields:
        nulls = sum(row.get(field) in (None, "") for row in rows)
        null_rates[field] = nulls / len(rows) if rows else 0

    keys = []
    for row in rows:
        stable = row.get("id") or row.get("asin") or row.get("url")
        if stable is not None:
            keys.append(str(stable))

    duplicate_rate = (
        (len(keys) - len(set(keys))) / len(keys) if keys else 0
    )

    return {
        "rows": len(rows),
        "fields": fields,
        "null_rates": null_rates,
        "duplicate_rate": duplicate_rate,
    }


def compare(baseline, current):
    b = profile(baseline)
    c = profile(current)

    missing_fields = sorted(set(b["fields"]) - set(c["fields"]))
    new_fields = sorted(set(c["fields"]) - set(b["fields"]))

    null_regressions = {}
    for field in set(b["fields"]) & set(c["fields"]):
        delta = c["null_rates"][field] - b["null_rates"][field]
        if delta >= 0.10:
            null_regressions[field] = round(delta, 4)

    row_loss = (
        (b["rows"] - c["rows"]) / b["rows"] if b["rows"] else 0
    )

    findings = []
    if row_loss >= 0.10:
        findings.append({
            "type": "row_loss",
            "severity": "high" if row_loss >= 0.25 else "medium",
            "delta": round(row_loss, 4),
        })
    if missing_fields:
        findings.append({
            "type": "schema_removed",
            "severity": "high",
            "fields": missing_fields,
        })
    if null_regressions:
        findings.append({
            "type": "null_rate_regression",
            "severity": "high",
            "fields": null_regressions,
        })
    if c["duplicate_rate"] - b["duplicate_rate"] >= 0.05:
        findings.append({
            "type": "duplicate_rate_regression",
            "severity": "medium",
            "delta": round(c["duplicate_rate"] - b["duplicate_rate"], 4),
        })

    return {
        "baseline": b,
        "current": c,
        "findings": findings,
        "status": "regression" if findings else "healthy",
    }


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: python detect.py baseline.json current.json")

    report = compare(load(sys.argv[1]), load(sys.argv[2]))
    print(json.dumps(report, indent=2, sort_keys=True))
    raise SystemExit(1 if report["status"] == "regression" else 0)


if __name__ == "__main__":
    main()
