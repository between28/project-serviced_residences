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

## Rule
- Keep business logic in `src/`.
- Keep scripts thin and deterministic.
