# Pre-analysis Checklist (Draft v1)

## 1. Scope Freeze
- Confirm four RQs are final (RQ1-RQ4).
- Confirm analysis units are final: `sigungu-month` (permit/substitution), `building-month` (start/completion).
- Confirm geographic scope is all `sigungu` with valid administrative codes.

## 2. Data Intake and Quality
- `data_download_manifest.csv` filled for all datasets with actual portal/API links.
- `scripts/10_data_download_checklist.ps1` run and `outputs/tables/data_coverage_audit.csv` generated.
- Match-rate threshold defined (proposed minimum: 85% at key linkage step).
- Missingness dashboard prepared by dataset, region, and time.

## 3. Variable Construction Freeze
- Outcome formulas finalized:
- `permit_count_sr`, `permit_share_sr`, `officetel_permit_count`, `start_event`, `completion_event`.
- Exposure variables finalized:
- `housing_policy_event_k`, `sr_policy_event_k`, event-time leads/lags.
- Control variable windows and transformations finalized (`hpi_yoy`, `tx_per_1000hh`, etc.).
- Variable definitions synced in `docs/dissertation/data/variable_definitions.md`.

## 4. Identification and Estimation
- Main design: staggered-treatment-robust event-study DID.
- Robustness estimators: Callaway-Sant'Anna and Sun-Abraham.
- Fixed effects and clustering rule explicitly written in methods note.
- Policy overlap handling rule finalized (policy-family separation + exclusion window).
- Anticipation tests specified with pre-policy leads.

## 5. Robustness Menu
- Alternative coverage thresholds for residentialisation.
- Placebo event dates.
- Excluding high-overlap policy months.
- Intensity-index specifications (robustness only; not main).

## 6. Reproducibility and Governance
- Script-first workflow confirmed (`scripts/` -> `src/`).
- No manual transformations outside scripts.
- Raw sensitive identifiers removed from analysis outputs.
- All event dates stored as absolute dates (`YYYY-MM-DD`).

## 7. Supervisor Review Pack
- Two-page brief updated (`supervisor_brief_v1.md`).
- One-slide model map prepared (RQ -> data -> estimator -> output).
- Open decisions list reduced to 3 items or fewer before meeting.
