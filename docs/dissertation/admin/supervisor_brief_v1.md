# Supervisor Brief v1 (Draft)

## Project
**Title:** When Accommodation Becomes Housing: Regulatory Arbitrage and Housing Supply Substitution in South Korea  
**Programme:** University of Cambridge MPhil in Planning, Growth and Regeneration  
**Date:** February 17, 2026

## 1. Research Question and Contribution
This dissertation tests whether housing market pressure and policy shocks reallocate development across legal categories (housing vs accommodation-adjacent categories), rather than only changing total supply.

Core contributions:
- Building-level evidence of residentialisation in serviced residences.
- Dynamic policy effects along permit -> start -> completion pipeline.
- Substitution evidence into adjacent categories after tightening.

## 2. Design Summary
Two linked panels:
- `sigungu-month`: permit/substitution outcomes.
- `building-month`: start/completion event-history outcomes.

Policy families are separated:
- Broad housing policy (LTV/DTI/reg-area designation).
- Serviced-residence-specific policy interventions.

Main estimator strategy:
- Staggered-treatment-robust dynamic DID/event-study.
- Cross-check with Callaway-Sant'Anna and Sun-Abraham estimators.

## 3. Data Status (Current)
A formal data intake manifest and automated coverage audit are now in place:
- Manifest: `docs/dissertation/data/data_download_manifest.csv`
- Audit script: `scripts/10_data_download_checklist.ps1`
- Output: `outputs/tables/data_coverage_audit.csv`

Pending immediate work:
- Fill actual download URLs/portals in manifest.
- Complete raw data intake and linkage diagnostics.
- Finalize policy event coding v1.

## 4. Main Risks and Mitigation
- **Measurement risk:** registration status != occupancy.
: mitigation via alternative interpretation thresholds and sensitivity checks.
- **Policy overlap risk:** multiple shocks in short windows.
: mitigation via policy-family separation, exclusion windows, and lead/lag tests.
- **Linkage bias risk:** incomplete matching.
: mitigation via match-rate thresholds and bounded-estimate reporting.

## 5. Next 4-week Plan
Week 1:
- Data intake completion + coverage audit.
- Policy timeline v1 freeze.

Week 2:
- Build `sigungu-month` and `building-month` skeleton panels.
- Freeze variable formulas and coding rules.

Week 3:
- Run baseline RQ1 and RQ3 permit models.
- Produce first diagnostics and event-study plots.

Week 4:
- Run pipeline timing models (start/completion).
- Prepare robustness pack and interim write-up.

## 6. Decisions Requested at Next Meeting
1. Clustering strategy (region-only vs two-way).
2. Preferred lead/lag window length for event-study.
3. Final definition scope for adjacent-category substitution in RQ4.
