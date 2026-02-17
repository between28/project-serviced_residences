# Source Code Layout

- `00_ingest`: import scripts and source standardization
- `01_clean`: cleaning and harmonization
- `02_linkage`: cross-dataset entity matching
- `03_feature_engineering`: panel and variable construction
- `04_modeling`: estimation scripts for RQ1-RQ4
- `05_outputs`: export scripts for tables and figures

## Execution Principle
- Keep stages modular and deterministic.
- Each stage should read from prior stage outputs, not from ad hoc notebook artifacts.
- Use `scripts/` as the execution layer that calls modules in this folder.
