## Data Sources and Fields

| Dataset | Unit | Key Fields | Role in Analysis |
|---------|------|------------|------------------|
| Building Register | Building | `building_id`, `permit_date`, `start_date`, `completion_date`, `gross_floor_area`, `num_units`, `parking_spaces`, `structure_type`, `zoning_category`, address fields | Core building life-cycle and design data |
| Lodging Registration (2026-02 snapshot) | Unit/Business | `registered_unit_id`, `registration_status`, `business_status`, address fields, update timestamp | Coverage proxy for accommodation operation |
| Zoning and Parcel Data | Parcel | `parcel_id`, `zoning_category`, `land_use_code`, geometry | Local regulatory context and spatial controls |
| Housing Market Data | Region-month | `local_price_index`, `hpi_yoy`, `transaction_volume`, `avg_price` | Housing market pressure controls |
| Population and Household Data | Region-year/month | `population`, `household_count`, `one_person_share` | Demand-side controls |
| Transit Location Data | Point | `station_id`, `latitude`, `longitude` | Accessibility features (`distance_to_station`, buffers) |
| Housing Policy Events | Policy-date-region | `policy_id`, `effective_date`, `policy_type`, `ltv_cap`, `dti_cap`, `reg_area_scope`, `direction` | Main policy event regressors for housing policy shocks |
| Serviced Residence Policy Events | Policy-date | `policy_id`, `effective_date`, `policy_type`, `scope`, `direction` | Main policy event regressors for serviced-residence-specific shocks |

## Analysis Panels

| Panel | Unit | Core Outcomes | Typical Controls |
|-------|------|---------------|------------------|
| Permit Panel | `sigungu-month` | `permit_count_sr`, `permit_share_sr`, `officetel_permit_count` | Market pressure, demographic controls, policy event dummies, fixed effects |
| Construction Pipeline Panel | `building-month` | `start_event`, `completion_event` | Building characteristics, local controls, policy event dummies, fixed effects |

## Notes

- Geographic base unit is `sigungu`.
- Time window will be finalized after data profiling (earliest available month to latest available month with reliable linkage).
- Composite policy intensity indices are prepared for robustness checks only, not for the main specification.
