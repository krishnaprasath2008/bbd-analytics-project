# Dashboard Specification (Part C)

## Data source

Connect Tableau Public to `data/orders_clean.csv` (63 rows).

| # | Column | Classification |
|---|---|---|
| 1 | order_id | Dimension |
| 2 | order_month | Dimension |
| 3 | clean_first_name | Dimension |
| 4 | clean_last_name | Dimension |
| 5 | region | Dimension |
| 6 | rep_name | Dimension |
| 7 | item | Dimension |
| 8 | category | Dimension |
| 9 | unit_price | Measure |
| 10 | quantity | Measure |
| 11 | amount | Measure |
| 12 | revenue_calc | Measure |
| 13 | status | Dimension |

9 Dimensions, 4 Measures. Set order_month to a String dimension so it stays 2026-09 etc.

## KPI cards

| Card | Definition | Value |
|---|---|---|
| Total Revenue | SUM(amount) | INR 346,200 |
| Total Units Sold | SUM(quantity) | 106 |

The Total Revenue card equals Part A q05 `total_revenue` (346200).

## Worksheets

### 1. Revenue by Region (bar chart)
- Columns: region. Rows: SUM(amount). Colour: none (single colour), sorted descending.
- Why: a bar chart compares a measure across a few categories by length, which is easy to judge.

| region | revenue |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |
| Total | 346200 |

### 2. Revenue by Category (bar chart)
- Columns: category. Rows: SUM(amount). Colour: none, sorted descending.
- Why: same reason; three categories compare cleanly as bars.

| category | revenue |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |
| Total | 346200 |

### 3. Revenue Trend by Month and Category (line chart)
- Columns: order_month. Rows: SUM(amount). Colour: category (one line per category).
- Why: a line chart shows change over ordered time, and one line per category lets trends be compared.

| order_month | Apparel | Electronics | Home | Month total |
|---|---|---|---|---|
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |
| Total | 77500 | 142300 | 126400 | 346200 |

### 4. Region x Category Detail (text table)
- Rows: category. Columns: region. Text (label): SUM(amount). Add row and column grand totals.
- Why: a text table gives exact values for every region and category pair, which bars cannot.

| category | East | North | South | West | Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Total | 69500 | 119300 | 82500 | 74900 | 346200 |

## Dashboard layout (top to bottom)

1. Top band, KPI cards: a horizontal container holding Total Revenue and Total Units Sold.
2. Directly below the KPI cards: the category filter (single-value dropdown or multi-select list) set to apply to all four worksheets using this data source.
3. Trend chart: Revenue Trend by Month and Category, full width.
4. Comparison charts: a horizontal container with Revenue by Region and Revenue by Category side by side.
5. Detail table: Region x Category Detail, full width at the bottom.

The whole dashboard sits in one vertical container; rows 1, 4 are horizontal containers inside it.

With Use as Filter switched on, clicking a bar in Revenue by Region (for example North) filters the other worksheets (the KPI cards, category chart, trend and detail table) to that region only; clicking the bar again clears it.

## Insight and recommendation narrative

### Visualization summary
The dashboard shows INR 346,200 of completed revenue from 63 orders and 106 units, split by region, category and month, with a detail table for exact region-by-category values.

### Summary analysis
1. Region comparison: North leads with 119300 (34.5% of revenue), while East is lowest at 69500, so North earns 49800 more than East.
2. Category comparison: Electronics is the largest category at 142300, and North alone contributes 73400 of it (51.6%).
3. Change across months: Home revenue jumped from 12600 in 2026-10 to 83200 in 2026-11, which lifted total revenue from 93100 to 154800.
4. Regional trend: North fell from 53500 in 2026-09 to 41300 in 2026-10 (-22.8%) and to 24500 in 2026-11, while East grew from 6400 to 50900 over the same period.

### Recommendations
1. **North, Home (Air Fryer).** Run a targeted Air Fryer promotion in North, because North Home revenue fell from 24600 in 2026-09 to 0 in 2026-11 and that drop explains most of North's total fall from 53500 to 24500 (Electronics was flat: 16700 to 17300). Watch North monthly Home revenue and North total against its 40000 target.
2. **South and East, Home (Air Fryer).** Raise Air Fryer stock for South and East ahead of the next sale peak, because Home revenue reached 83200 in 2026-11 and these two regions hold 81300 of Home's 126400 (South 43800, East 37500). Watch Air Fryer units sold against stock-out days.
3. **West, Electronics.** Cross-sell Electronics to West's Apparel buyers, because West Electronics is only 18800 (25.1% of West's 74900) while West Apparel is 37500. Watch West Electronics revenue share of West total.

## Reconciliation

| Source | Value |
|---|---|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |

All four are equal.
