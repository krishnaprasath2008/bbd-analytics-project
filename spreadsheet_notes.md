# Spreadsheet Notes (Part B)

Tool: Google Sheets. Input: `data/orders_enriched.csv`. Layout of the `orders` tab: A order_id, B order_month, C first_name, D last_name, E region, F rep_name, G item, H quantity, I amount, J status, then added columns K to O.

## (a) Formulas typed in row 2 of each added column

| Column | Formula (row 2) |
|---|---|
| K clean_first_name | `=PROPER(TRIM(C2))` |
| L clean_last_name | `=PROPER(TRIM(D2))` |
| M category | `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)` |
| N unit_price | `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` |
| O revenue_calc | `=N2*H2` |

All formulas were copied down rows 2 to 91 (90 rows). `order_month` was imported as Plain text so it still reads 2026-09, 2026-10, 2026-11.

## (b) Aggregates of amount on completed_orders

| Measure | Formula | Result |
|---|---|---|
| COUNT | `=COUNT(K2:K64)` (amount column) | 63 |
| SUM | `=SUM(K2:K64)` | 346200 |
| AVERAGE | `=AVERAGE(K2:K64)` | 5495.24 |
| MIN | `=MIN(K2:K64)` | 1100 |
| MAX | `=MAX(K2:K64)` | 15600 |

(Amount is column K on completed_orders because it is the 11th column in the task 8 order; adjust the letter if your sheet differs.)

## (c) Pivot tables (completed_orders)

Pivot (i): sum of amount, rows = category, columns = region

| category | East | North | South | West | Grand Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Grand Total | 69500 | 119300 | 82500 | 74900 | 346200 |

Pivot (ii): rows = order_month

| order_month | Sum of amount | Count of order_id |
|---|---|---|
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| Grand Total | 346200 | 63 |

## (d) Reconciliation with Part A q05

| Figure | Spreadsheet | Part A q05 | Result |
|---|---|---|---|
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## (e) Data validation

**Missing amounts.** Three orders have a blank amount: 1001 (Bluetooth Speaker), 1010 (Wireless Earbuds) and 1064 (Bluetooth Speaker), the same ids returned by q02. All three are `pending`, so none is in the 63 completed rows and none affects revenue. I left them blank rather than filling 0, because 0 would be a false value and would drag down AVERAGE; SUM, COUNT and AVERAGE ignore blank cells. Note that `revenue_calc` still shows unit_price x quantity on those rows in the orders tab, which is an expected value, not a recorded amount.

**Data types.** I checked that amount, quantity and unit_price are right-aligned numbers (not text): `=COUNT(I2:I91)` returns 87 (90 minus the 3 blanks) and `=COUNT(H2:H91)` returns 90. order_month stays text.

**Duplicates and outliers.** `=COUNTA(A2:A91)` equals the count of unique order_id values (90), so there are no duplicate order_ids. Among completed orders the largest amount is 15600, shared by four orders: 1061, 1065, 1069 and 1077. All four are 3 x Air Fryer at 5200, so they are legitimate bulk orders, not errors, and amount equals revenue_calc on all 63 rows.

**Decision for a colleague.** Keep pending and disputed orders out of revenue (use the status filter, never delete rows) and leave missing amounts blank instead of zero.

## (f) Setup

- Tabs created: `orders` and `products` (plus `completed_orders` built from them).
- Rows imported into `orders`: 90 (header excluded).
- products tab range: A1:C10 (header plus 9 items), pasted from `SELECT item, category, unit_price FROM products ORDER BY item`.
- Filter and sort applied before building completed_orders: status = completed, then amount sorted largest to smallest; the 63 visible rows were pasted as values.
- XLOOKUP fallback test in a spare cell: `=XLOOKUP("Mystery Item",products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` displays `UNKNOWN_ITEM`.
