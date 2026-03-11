# Runbook

## Standard local execution cycle
1. Environment check
2. Compile
3. State snapshot
4. Heartbeat emission
5. Benchmark run
6. Verification
7. Evidence bundle generation
8. Optional LLM export

## Stop conditions
- Missing required files
- Failed write to `08_evidence/` or `09_logs/`
- Missing hash inventory before verify
- Verification verdict not equal to `PASS`
