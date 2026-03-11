# QUICK START — WV_REPRODUCIBILITY_VALIDATION_RUNTIME_v1

## Objective
Turn this prepared pack into a locally executed evidence cycle.

## Commands
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\10_scripts\check_environment.ps1
.\10_scripts\compile_pack.ps1
.\10_scripts\build_state_snapshot.ps1
.\10_scripts\run_heartbeat.ps1
.\10_scripts\run_benchmark.ps1
.\10_scripts\verify_pack.ps1
.\10_scripts\generate_evidence_bundle.ps1
.\10_scripts\export_for_llm.ps1
```

## Fastest path to PARTIAL_VERIFIED
If all commands succeed and the evidence files are generated, the pack crosses from pure chat design into locally evidenced runtime.
