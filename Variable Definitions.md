## Variable Dictionary

### 1) Panel Keys and Time
- `building_id`: unique building identifier
- `sigungu_code`: regional identifier for panel aggregation
- `year_month`: monthly index (`YYYY-MM`)
- `permit_date`, `start_date`, `completion_date`: raw event dates
- `permit_month`, `start_month`, `completion_month`: monthly event dates

### 2) Building Structure and Design
- `gross_floor_area`: total gross floor area
- `num_units`: total number of units
- `unit_area_mean`: mean unit area
- `parking_spaces`: total parking count
- `parking_per_unit`: `parking_spaces / num_units`
- `structure_type`: structural category
- `zoning_category`: zoning label
- `distance_to_station`: distance to nearest rail/subway station
- `station_buffer_500`, `station_buffer_1000`: accessibility flags

### 3) Serviced Residence Coverage and Residentialisation
- `sr_units`: number of serviced residence units in a building
- `registered_sr_units`: number of registered accommodation units
- `coverage_units`: `registered_sr_units / sr_units`
- `coverage_binary`: indicator for any registered operation
- `residentialisation_score`: predicted housing-like probability

### 4) Housing Market Pressure Controls
- `local_price_index`: local house price index
- `hpi_yoy`: year-over-year house price growth
- `transaction_volume`: local transaction count
- `tx_per_1000hh`: transactions per 1,000 households
- `population`: resident population
- `household_count`: number of households

### 5) Policy Variables (Main Specification)
- `housing_policy_event_k`: event dummy for housing policy `k`
- `sr_policy_event_k`: event dummy for serviced residence policy `k`
- `event_time_housing_k`: relative month to housing policy `k`
- `event_time_sr_k`: relative month to serviced residence policy `k`
- `reg_area_dummy`: indicator for regulated area status (if policy-coded by region-month)

### 6) Policy Variables (Robustness Only)
- `housing_policy_intensity`: composite housing policy intensity index
- `sr_policy_intensity`: composite serviced residence policy intensity index

### 7) Outcomes by Analysis Unit

#### 7.1 `sigungu-month` outcomes
- `permit_count_sr`: serviced residence permit count
- `permit_share_sr`: serviced residence share in target supply categories
- `officetel_permit_count`: officetel permit count
- `adjacent_permit_count`: permit count for adjacent categories

#### 7.2 `building-month` outcomes
- `start_event`: `1` if construction starts in month `t`
- `completion_event`: `1` if completion occurs in month `t`
- `at_risk_start`: `1` if permitted but not yet started at beginning of month `t`
- `at_risk_completion`: `1` if started but not yet completed at beginning of month `t`

### 8) Fixed Effects and IDs Used in Estimation
- `fe_sigungu`: regional fixed effects key
- `fe_month`: calendar month fixed effects key
- `cohort_permit_month`: permit cohort identifier for heterogeneity checks
