# AI Verification Log (Part D)

Disclosure: an AI assistant helped draft the files in this repository. Every number was recomputed by running the SQL in SQLite and checked against the other Parts. I am responsible for the final content.

## Task 1: Five-part prompt for q13

**Role:** You are a senior SQL analyst who writes clear, portable queries for a retail sales team.

**Task:** Write one query that compares each sales rep's monthly completed revenue with their monthly target and labels the result with a performance tier.

**Context:** Dialect: SQLite (also valid in MySQL and PostgreSQL). Tables and columns: `reps(rep_id, rep_name, region, monthly_target)`, `customers(customer_id, first_name, last_name, city, region, age, rep_id)`, `orders(order_id, customer_id, item, quantity, amount, status, order_month)`. Joins: `customers.rep_id = reps.rep_id` and `orders.customer_id = customers.customer_id`. `order_month` is text such as 2026-09.

**Constraints:** Use completed orders only (`status = 'completed'`). Group by rep_name, order_month and monthly_target. `performance_tier` is 'Below Target' when revenue < monthly_target, 'On Target' when revenue >= monthly_target and < 1.1 x monthly_target, otherwise 'Above Target'. Output columns exactly: rep_name, order_month, monthly_target, revenue, performance_tier. Order by rep_name then order_month. No WITH clauses. No stored procedures. Write the aggregate expression in full inside CASE; do not use aggregates in WHERE.

**Format:** Raw SQL only, with inline comments, no explanation outside the code.

## Task 2: Inspection of Scenario D1

| # | Defect | Classification | Correct fix |
|---|---|---|---|
| 1 | Table `sales` does not exist | fake method/function | Use the real tables `orders` and `customers` |
| 2 | Columns `region_name` and `total_sales` do not exist | fake method/function | Use `customers.region` and `orders.amount` |
| 3 | `SUM(...)` in WHERE | logic error | Filter groups with `HAVING SUM(o.amount) > 80000` (and put `status = 'completed'` in WHERE) |
| 4 | "Revenue grew 38% month over month" with no source | phantom statistic | Compute from q11 or remove the claim |

## Task 3: Verification of Scenario D1

Corrected query (`sql/d1_corrected.sql`):

```sql
SELECT c.region, SUM(o.amount) AS sales
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
```

Result (2 rows):

| region | sales |
|---|---|
| North | 119300 |
| South | 82500 |

North's completed revenue from q11: 53500 in 2026-09 and 41300 in 2026-10. Change = (41300 - 53500) / 53500 = **-22.8%**. The assistant's claim of 38% growth is contradicted by the data: North revenue fell.

## Task 4: Human-in-the-loop protocol

**Specification.** The question "which regions sell the most?" was vague: it gave no revenue definition, no threshold and no table names. I fixed it as completed revenue by customer region with a 80000 threshold, on the real schema.

**Execution.** I ran the assistant's query as written and it failed (no table `sales`). I then ran my corrected query on the seeded SQLite database and it returned North 119300 and South 82500.

**Inspection.** I read the answer line by line and found four defects: a non-existent table, non-existent columns, an aggregate in WHERE, and a growth figure with no source.

**Verification.** I recomputed North's monthly revenue from q11 (53500 to 41300) and got -22.8%, not +38%. I also checked that 119300 + 82500 are consistent with the pivot in Part B (North 119300, South 82500).

**Decision.** Reject the original answer: its SQL cannot run and its 38% claim is contradicted by the data (-22.8%). Accept my corrected version: it runs, returns exactly 2 rows, and matches q11 and the Part B pivot.

## Task 5: Scenario D2

**Prompt.**
Role: You are a spreadsheet debugging expert.
Task: Find why a VLOOKUP returns "value not found" although the item exists in the table.
Context: Sheet `orders`, cell G2 holds the text ` Smart Watch` (a space before the S). The lookup table is on the products tab, A1:C10 (header row 1, item names in column A, unit prices in column C). Formula: `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`.
Constraints: Keep exact match (FALSE); do not change the products table; explain the cause before giving the fix.
Format: One sentence for the root cause, then the repaired formula in a code block.

**Root cause (my words).** The key in G2 has a leading space, so ` Smart Watch` is not identical to `Smart Watch`; exact-match VLOOKUP compares text character by character and finds nothing.

**Repaired formula.** `=VLOOKUP(TRIM(G2), $A$2:$C$10, 3, FALSE)`

## Task 6: Skeptical-analyst check on my first recommendation

**Prompt.**
Role: You are a skeptical senior analyst reviewing a recommendation before it goes to leadership.
Task: Challenge this recommendation: "Run a targeted Air Fryer promotion in North, because North Home revenue fell from 24600 in 2026-09 to 0 in 2026-11, which explains most of North's total fall from 53500 to 24500."
Context: Synthetic Big Billion Days data, 90 orders, four regions, three months; revenue means completed orders only.
Constraints: List every unstated assumption; ask what evidence would show the promotion caused an improvement, not just a correlation; do not accept the numbers at face value.
Format: A numbered list of assumptions, each with the check you would run.

**Unstated assumptions and checks.**

| # | Assumption | Check from my data |
|---|---|---|
| 1 | The North decline is a demand problem, not a status or timing effect | North had 1 pending (2800) in 2026-10 and 1 disputed (9600) plus 1 pending (1900) in 2026-11; if those completed, 2026-11 would be 24500 + 11500 = 36000, a smaller fall. |
| 2 | North's September level was normal, not a spike from one buyer | Customer 5 alone made 35700 of North's 53500 in 2026-09 (66.7%), and the two Air Fryer orders (1021, 1022) came from customers 21 and 5; if Air Fryer is a one-off durable purchase, no repeat is expected. Check repeat purchases per customer. |
| 3 | Home is the right lever for North's decline | North Sep to Nov change by category: Home -24600, Apparel -5000, Electronics +600 (16700 to 17300); check that Home really explains the 29000 drop and not a status shift. |
| 4 | A promotion will lift volume rather than just discount existing sales | Compare units against revenue: with fixed unit prices, any discount must raise units enough to offset it; track units per order for North (q11 order counts: 8, 6, 5). |
| 5 | Three months and 6 North customers are enough to call a trend | North has only 5 buyers (customer 17 never ordered, per q10); a single customer moves the total, so the trend is weak evidence. |
