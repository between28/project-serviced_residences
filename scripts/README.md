# Execution Scripts

This folder is for pipeline entry points.

## `src/` vs `scripts/`
- `src/`: reusable functions/modules
- `scripts/`: runnable commands that orchestrate `src/` in sequence

## Naming Convention
- `10_*.py`: ingest and profiling
- `20_*.py`: cleaning and linkage
- `30_*.py`: feature engineering
- `40_*.py`: modeling
- `50_*.py`: output export

Current utility scripts:
- `10_data_download_checklist.ps1`: reads manifest and writes `outputs/tables/data_coverage_audit.csv`
- `11_building_register_intake_validate.ps1`: validates building-register raw files (field counts + key date parse checks)
- `12_permit_intake_validate.ps1`: validates building/housing permit raw files (field counts + date-like column profiling)
- `13_extract_core_columns.ps1`: runs core-column extraction from raw files into `data/interim/core_columns`
- `run_pipeline.ps1`: placeholder pipeline entry template

## Rule
- Keep business logic in `src/`.
- Keep scripts thin and deterministic.
