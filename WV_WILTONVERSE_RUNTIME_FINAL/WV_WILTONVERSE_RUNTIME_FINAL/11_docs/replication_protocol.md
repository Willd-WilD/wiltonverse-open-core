# Replication Protocol

## Purpose
Provide a clean second-machine verification path.

## Required from reproducer
- The original package
- Generated evidence bundle from the original run
- Notes about any local environment differences

## Output expected from reproducer
- `08_evidence/independent_reproduction_report.json`
- `09_logs/verify.log`
- Optional comments on mismatches or required environment fixes

## Anti-illusion rule
A second operator saying "it looks fine" is not evidence.
Reproduction requires running the same cycle and emitting comparable artifacts.
