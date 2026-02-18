# When Accommodation Becomes Housing
## Regulatory Arbitrage and Housing Supply Substitution in South Korea

**Author:** [Chae Hoon Lee]  
**Programme:** MPhil in Planning, Growth and Regeneration  
**Institution:** University of Cambridge  
**Supervisor:** [Dr. Ozge Oner]  
**Date:** February 17, 2026

---

# Table of Contents

1. Introduction  
2. Research Questions  
3. Institutional Background  
4. Data  
5. Measurement Strategy  
6. Empirical Strategy  
7. Expected Contributions  
8. Limitations and Risk Management  
9. Work Plan  
10. Data Appendix  
11. Variable Dictionary  
12. References  

---

# 1. Introduction

This dissertation studies how a property category legally defined as accommodation can operate as housing in practice.

In South Korea, serviced residences (saenghwal-sukbak-siseol) are formally classified as accommodation. However, some have been marketed, purchased, and occupied in ways similar to housing. This created legal disputes and repeated policy interventions.

This case is treated as a broader supply-allocation problem:

> When formal housing channels are constrained by regulation or market pressure, development may shift into adjacent legal categories.

The project tests whether policy and market pressure change the timing and composition of supply across categories. This framing follows the housing supply constraint and spatial misallocation literature (Glaeser et al., 2008; Hsieh and Moretti, 2015).

---

# 2. Research Questions

### RQ1. Housing Market Pressure
Do serviced residence permits expand when local housing markets become more constrained or more expensive?

### RQ2. Residentialisation
Which serviced residence buildings are most likely to function as housing in practice rather than short-stay accommodation?

### RQ3. Regulatory Shock and Pipeline
How do housing policy shocks and serviced-residence-specific regulations affect permit, start, and completion timing?

### RQ4. Substitution
After regulatory tightening, does development shift into adjacent categories such as officetels or other small-unit housing types?

---

# 3. Institutional Background

Serviced residences are legally accommodation, but they differ from traditional hotels in several ways:

- Individual unit sales are possible.
- Unit design may resemble small apartments.
- Credit and housing regulations have not always treated them like standard housing.

The policy environment has changed multiple times through:

- Broad housing policy interventions (for example LTV and DTI tightening, regulated area designation changes).
- Serviced-residence-specific interventions (illegal residential use controls, grace periods, conversion support).

This research estimates how those policy layers changed development behavior, consistent with macroprudential housing-policy evidence (Kuttner and Shim, 2013; Jung and Lee, 2016).

---

# 4. Data

The project combines nationwide administrative, spatial, and policy data.

## 4.1 Core Building Register (National Coverage)

- Permit date
- Construction start date
- Completion date
- Floor area, unit count
- Unit-level composition
- Parking
- Building use and structure
- Address and local administrative code

## 4.2 Lodging Registration Data (February 2026 Snapshot)

- Unit-level registration status
- Business status and update timestamp
- Location fields for linkage

## 4.3 Zoning and Parcel Data

- Zoning category
- Parcel boundary and location context

## 4.4 Housing Market and Demographic Data

- Housing price index and growth
- Transaction volume
- Population and household structure

## 4.5 Accessibility Data

- Rail/subway station coordinates
- Distance and buffer measures

## 4.6 Policy Event Data

- Housing policy timeline: LTV/DTI changes, regulated area designation changes
- Serviced-residence policy timeline: direct legal and administrative interventions
- Event metadata: effective date, geography, policy type, and direction (tightening/relaxation)

---

# 5. Measurement Strategy

## 5.1 Coverage Indicator (Accommodation Operation Signal)

For each serviced residence building:

Coverage (unit-based) =  
Registered accommodation units / Total serviced residence units

Interpretation:

- High coverage: more likely active accommodation operation
- Low coverage: more likely non-accommodation operation, including possible residential use

Sensitivity checks will test both interpretations:

1. Low coverage as non-accommodation likelihood
2. Low coverage as housing-use assumption

## 5.2 Residentialisation Score

A model will estimate the probability that a building functions like housing using:

- Unit size profile
- Parking per unit
- Zoning category
- Distance to station
- Ownership and unit composition structure

Output: continuous residentialisation score at building level.

## 5.3 Market Pressure and Policy Variables

Main covariates:

- Local housing market pressure (price growth, transaction pressure)
- Housing policy event dummies (no intensity index in main specification)
- Serviced-residence policy event dummies

Robustness only:

- Composite policy intensity indices (housing and serviced residence)

## 5.4 Analysis Unit and Time Window

- Permit analysis: `sigungu-month` panel
- Start/completion analysis: `building-month` event panel
- Geographic unit: `sigungu` as the common regional layer
- Time window: earliest available month to latest available month after data profiling and linkage quality checks

---

# 6. Empirical Strategy

## Stage 0: Policy Calendar and Exposure Mapping

- Build a dated policy calendar.
- Map policy exposure to `sigungu-month`.
- Separate broad housing policies from serviced-residence-specific policies.

## Stage 1: RQ1 Housing Market Pressure and Permit Expansion

Outcome:

- Serviced residence permit count (and share) at `sigungu-month`

Approach:

- Count model or linear panel with `sigungu` and month fixed effects
- Controls for local demand and macro conditions

Interpretation is anchored in the supply-constraint channel documented in prior research (Glaeser et al., 2008; Hsieh and Moretti, 2015).

## Stage 2: RQ2 Residentialisation Model

Outcome:

- Coverage ratio or low-coverage probability

Approach:

- Fractional response / binary response model at building level

Output:

- Residentialisation score

## Stage 3: RQ3 Regulatory Shock and Pipeline Timing

### 3A. Permit Pipeline (Region-Month)

- Event-study style policy dummies in `sigungu-month` panel
- Separate housing policy effects from serviced-residence policy effects
- Estimation with staggered-treatment-robust event-study DID estimators (Callaway and Sant'Anna, 2018; Sun and Abraham, 2018)

### 3B. Start and Completion Pipeline (Building-Month)

- Event-history setup for `start_event` and `completion_event`
- Building enters risk set after permit (for start) and after start (for completion)
- Month fixed effects and regional controls

Main specification uses policy event dummies only. Policy intensity index is reserved for robustness.

## Stage 4: RQ4 Substitution Across Categories

Test post-policy changes in:

- Officetel permits
- Small-unit housing permits
- Category share in total small-unit supply

Use `sigungu-month` panel with policy event terms and local controls.

---

# 7. Expected Contributions

- Show whether housing pressure predicts growth of hybrid supply categories.
- Provide building-level evidence on residentialisation patterns.
- Identify dynamic policy effects across permit/start/completion stages.
- Quantify substitution into adjacent categories after regulation.
- Contribute to planning and regulatory design debates on boundary categories.

---

# 8. Limitations and Risk Management

**Measurement limitation:**  
Coverage reflects registration status, not direct observed occupancy.

**Mitigation:**  
Report alternative interpretations and sensitivity scenarios.

**Linkage limitation:**  
Administrative matching may be imperfect across datasets.

**Mitigation:**  
Report match rates, conduct linkage-bias diagnostics, and provide bounded estimates.

**Policy overlap and anticipation:**  
Multiple policy shocks can overlap in time.

**Mitigation:**  
Use lead/lag event windows, policy-family separation, and placebo timing checks.

**Ethics and data governance:**  
Administrative data may include sensitive fields even when analysis is aggregated.

**Mitigation:**  
Restrict analysis outputs to non-identifiable aggregates, remove direct identifiers after linkage keys are generated, and document data access and storage controls in the appendix.

---

# 9. Work Plan

Month 1-2: Data profiling, cleaning, linkage, and policy calendar coding  
Month 3: Residentialisation model (RQ2)  
Month 4-5: Permit/start/completion policy models (RQ1, RQ3)  
Month 6: Substitution analysis (RQ4) and robustness  
Month 7: Writing, revisions, and appendix finalization  

---

# 10. Data Appendix

| Dataset | Unit | Key Fields | Role |
|---------|------|------------|------|
| Building Register | Building | Permit/start/completion dates, floor area, units, parking, use type, address | Core structural and timing dataset |
| Lodging Registration | Unit | Registration status, business status, address | Coverage calculation |
| Zoning and Parcel Data | Parcel | Zoning category, parcel attributes | Regulatory and location controls |
| Housing Market Data | Region-month | Price index, transactions | Market pressure controls |
| Demographic Data | Region-year/month | Population, households | Demand structure controls |
| Station Locations | Point | Coordinates | Accessibility measures |
| Housing Policy Events | Policy-date-region | LTV/DTI changes, regulated area designations | Housing policy shocks |
| Serviced Residence Policy Events | Policy-date | Direct serviced residence interventions | Category-specific shocks |

---

# 11. Variable Dictionary

## ID and Time
- `building_id`
- `sigungu_code`
- `year_month`
- `permit_date`, `start_date`, `completion_date`
- `permit_month`, `start_month`, `completion_month`

## Structure and Design
- `gross_floor_area`
- `num_units`
- `unit_area_mean`
- `parking_spaces`
- `parking_per_unit`
- `structure_type`

## Coverage and Residentialisation
- `sr_units`
- `registered_sr_units`
- `coverage_units`
- `coverage_binary`
- `residentialisation_score`

## Market Pressure
- `local_price_index`
- `hpi_yoy`
- `transaction_volume`
- `tx_per_1000hh`

## Policy Events (Main)
- `housing_policy_event_k`
- `sr_policy_event_k`
- `event_time_housing_k`
- `event_time_sr_k`

## Policy Intensity (Robustness Only)
- `housing_policy_intensity`
- `sr_policy_intensity`

## Outcomes
- `permit_count_sr` (region-month)
- `permit_share_sr` (region-month)
- `start_event` (building-month)
- `completion_event` (building-month)
- `officetel_permit_count` (region-month)

---

# 12. References

Core reference set for this proposal draft (6 papers):

- Callaway, Brantly, and Pedro H. C. Sant'Anna (2018). Difference-in-Differences with Multiple Time Periods. https://arxiv.org/pdf/1803.09015.pdf
- Glaeser, Edward L., Joseph Gyourko, and Albert Saiz (2008). Housing Supply and Housing Bubbles. https://www.nber.org/system/files/working_papers/w14193/w14193.pdf
- Hsieh, Chang-Tai, and Enrico Moretti (2015). Housing Constraints and Spatial Misallocation. https://www.nber.org/system/files/working_papers/w21154/w21154.pdf
- Jung, Hosung, and Jieun Lee (2016). The Effects of Macro-prudential Policies on House Prices Using Real Transaction Data: Evidence from Korea. https://www.bok.or.kr/fileSrc/imerEng/56d07b1e2d804cdd84a2a80d28aca232/1/FILE_201803300854535991.pdf
- Kuttner, Kenneth N., and Ilhyock Shim (2013). Can non-interest rate policies stabilise housing markets? https://www.bis.org/publ/work433.pdf
- Sun, Liyang, and Sarah Abraham (2018). Estimating Dynamic Treatment Effects in Event Studies with Heterogeneous Treatment Effects. https://arxiv.org/pdf/1804.05785.pdf
