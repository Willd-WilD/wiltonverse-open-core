# Reproduction Instructions

## Goal
Reproduce the Wiltonverse runtime pack on a second machine or by a second operator.

## Minimum sequence
1. Extract the package.
2. Run `10_scripts/check_environment.ps1`.
3. Run `10_scripts/compile_pack.ps1`.
4. Run `10_scripts/build_state_snapshot.ps1`.
5. Run `10_scripts/run_heartbeat.ps1`.
6. Run `10_scripts/run_benchmark.ps1`.
7. Run `10_scripts/verify_pack.ps1`.
8. Run `10_scripts/generate_evidence_bundle.ps1`.
9. Compare the generated `08_evidence/hash_inventory.txt` and `08_evidence/verification_report.json` with the original cycle.

## Acceptance criteria
- Required artifacts exist.
- Verification verdict is `PASS`.
- Evidence bundle is generated.
- Any expected changes are documented in `01_state/changelog.yaml` or a local run note.

## Truth policy reminder
A successful local run can justify `PARTIAL_VERIFIED`.
Independent reproduction on another machine is required before any `VERIFIED` portability claim.
