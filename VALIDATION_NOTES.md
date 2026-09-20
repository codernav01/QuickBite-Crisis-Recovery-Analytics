# QuickBite Validation Notes

A core objective of this project is to show that business metrics are not trusted before the underlying data model is checked.

## Validation Coverage

| Validation area | What is checked |
|---|---|
| Table grain | row count vs distinct business keys |
| Key quality | null and duplicate identifiers |
| Referential integrity | orphaned customer, restaurant, partner, menu-item and order relationships |
| Ratings | valid rating range |
| Item economics | positive quantity, non-negative prices, discount consistency |
| Order economics | non-negative financial values |
| Delivery measures | non-negative operational measures |
| Financial reconciliation | order total vs subtotal, discount and fee logic |
| Item/order reconciliation | item-level economics vs order-level subtotal |
| Cancelled orders | financial consistency for cancelled transactions |

## Important Observed Issue

The project’s order-value reconciliation check identified **9,848 records** where the supplied order total did not reconcile within the configured tolerance against the component calculation.

This is intentionally documented rather than overwritten or “fixed” without source-system evidence.

### Analytical treatment

- Preserve the source records.
- Flag the inconsistency.
- Avoid presenting the affected measure as audited financial truth.
- Use the discrepancy as a data-quality limitation when interpreting commercial results.
- Keep the reconciliation query available in the SQL workflow for review.

## Why this matters

A polished chart does not compensate for an unvalidated grain, broken relationship, or inconsistent financial definition. This project therefore treats validation as part of the analysis, not as an optional preprocessing step.
