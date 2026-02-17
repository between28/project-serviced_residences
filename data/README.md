# Data Directory

- `raw/`: original source datasets (never manually edited)
- `interim/`: cleaned and linked intermediate files
- `processed/`: analysis-ready panels and feature tables

## Rules
- Keep large raw files out of Git where possible.
- Keep schemas, codebooks, and tiny metadata snapshots in Git.
- Build `processed/` using scripts from `src/` only.