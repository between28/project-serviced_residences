# Research Proposal - Detailed Version
## When Accommodation Becomes Housing: Regulatory Arbitrage and Housing Supply Substitution in South Korea

## 1. Motivation and Scope

This project examines a boundary category problem in urban regulation. In South Korea, serviced residences are legally classified as accommodation, but in practice some projects are developed, sold, and occupied in housing-like ways. The core claim is that policy and market pressure can reallocate supply across legal categories rather than simply reduce total supply.

The empirical scope covers:

- Housing market pressure effects on serviced residence permits
- Building-level residentialisation patterns
- Policy shock effects across the permit-start-completion pipeline
- Post-shock substitution into adjacent categories (officetel and other small-unit types)

## 2. Research Questions

### RQ1. Housing Market Pressure
Do serviced residence permits rise where housing prices and transaction pressure increase?

### RQ2. Residentialisation
Which serviced residence buildings are most likely to function as housing rather than active accommodation?

### RQ3. Regulatory Shock and Pipeline
How do housing policy shocks and serviced-residence-specific regulations affect permit, start, and completion timing?

### RQ4. Substitution
After tightening, does development shift to adjacent categories?

## 3. Identification Logic

### 3.1 Why Hybrid Unit Design

The design uses two panel structures:

- `sigungu-month` for permit outcomes
- `building-month` for start/completion outcomes

Reason:

- Permit is a flow outcome and needs a regional risk set.
- Start/completion are building life-cycle outcomes and naturally fit event-history panels.

This avoids forcing all outcomes into one unit where identification would be weaker.

### 3.2 Policy Families

Policy shocks are coded in two families:

- Broad housing policy shocks (for example LTV/DTI changes, regulated area updates)
- Serviced-residence-specific policy shocks

Main models use policy event dummies and event-time terms. Composite intensity indices are used only in robustness checks.

## 4. Data Design

### 4.1 Core Sources

- Building register: permit/start/completion dates, structure, unit composition, parking, location
- Lodging registration: registered accommodation status and business operation fields
- Zoning and parcel data: local regulatory context
- Housing market and demography: price pressure and demand controls
- Accessibility: station distance and buffers
- Policy calendar data: dated and geocoded policy events

### 4.2 Geographic Unit

- Regional panel unit is `sigungu`
- Building-level records are mapped to `sigungu_code`

### 4.3 Time Window

- Candidate window is maximum feasible range from earliest available month to latest available month.
- Final window is fixed after profiling data completeness, linkage quality, and missingness patterns.

## 5. Key Variables

### 5.1 Housing-like Operation Signal

`coverage_units = registered_sr_units / sr_units`

Low coverage is interpreted as higher probability of non-accommodation operation, with alternative interpretation checks.

### 5.2 Residentialisation Features

- Unit size profile
- Parking per unit
- Zoning context
- Transit accessibility
- Building composition and ownership proxies

### 5.3 Market Pressure

- `hpi_yoy` (house price growth)
- `transaction_volume`
- `tx_per_1000hh` (normalized transaction pressure)

### 5.4 Policy Terms

Main:

- `housing_policy_event_k`
- `sr_policy_event_k`
- lead/lag event-time terms

Robustness only:

- `housing_policy_intensity`
- `sr_policy_intensity`

## 6. Empirical Plan

### Stage A. RQ1: Market Pressure and Permit Expansion (`sigungu-month`)

Outcomes:

- `permit_count_sr`
- `permit_share_sr`

Base specification:

- Region fixed effects
- Month fixed effects
- Housing market pressure controls
- Macro controls

### Stage B. RQ2: Residentialisation Model (Building Level)

Outcomes:

- `coverage_units` (fractional)
- `coverage_binary` (binary alternative)

Output:

- `residentialisation_score`

### Stage C. RQ3: Policy Shock and Pipeline Timing

#### C1. Permit Effects (`sigungu-month`)

Event-study model with policy-family separation:

- Housing policy events
- Serviced-residence events

#### C2. Start and Completion Effects (`building-month`)

Discrete-time event-history models:

- `start_event` among permitted and not-yet-started buildings
- `completion_event` among started and not-yet-completed buildings

### Stage D. RQ4: Substitution (`sigungu-month`)

Outcomes:

- `officetel_permit_count`
- permits for other adjacent categories
- category shares in total small-unit supply

## 7. Robustness and Diagnostics

- Alternative coverage thresholds and interpretations
- Alternative event windows and placebo dates
- Excluding overlapping policy months
- Composite intensity index specifications (robustness only)
- Linkage quality diagnostics and sensitivity to unmatched observations

## 8. Risks and Mitigation

### Measurement Risk
Coverage is an administrative operation proxy, not direct occupancy.

Mitigation:

- Strong/weak interpretation scenarios
- Triangulation with ancillary indicators where available

### Policy Overlap Risk
Policy shocks may overlap and interact.

Mitigation:

- Policy-family separation
- lead/lag structure
- placebo timing and exclusion windows

### Data Linkage Risk
Cross-source matching may be incomplete.

Mitigation:

- Match-rate reporting by region and period
- Selection diagnostics
- Bounded estimates

## 9. Deliverables

- Clean analysis-ready panels (`sigungu-month`, `building-month`)
- Policy event calendar and codebook
- Main regression tables for RQ1-RQ4
- Robustness appendix (including intensity index models)
- Final dissertation chapters and reproducible scripts
