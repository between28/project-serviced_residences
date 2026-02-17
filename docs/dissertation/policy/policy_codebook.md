# Policy Codebook Template

## Required Fields
- `policy_id`
- `policy_family` (`housing` or `serviced_residence`)
- `policy_name`
- `effective_date`
- `effective_scope`
- `direction` (`tightening` or `relaxation`)
- `legal_basis`
- `source_file`
- `notes`

## Coding Rules
- Main regressions use event dummies and event-time terms.
- Intensity scores are optional and used only for robustness.
- Use absolute dates (`YYYY-MM-DD`) for all events.
