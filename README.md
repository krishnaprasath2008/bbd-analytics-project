# BBD Regional Performance Review: SQL, Spreadsheet, Dashboard and AI-Verified Analysis

- **SQL compiler and dialect:** SQLite (run via Python's sqlite3; the same SQL also runs in browser SQLite compilers).
- **Spreadsheet tool:** Google Sheets (formulas documented in `docs/spreadsheet_notes.md`).
- **Dashboard:** Not built in Tableau Public; `docs/dashboard_spec.md` is the written specification, with every number computed and reconciled.

## Key findings
Completed revenue is INR 346,200 from 63 orders (106 units). North leads (119300) but its monthly revenue fell from 53500 to 41300 (-22.8%) and then to 24500, mostly because North Home sales dropped from 24600 to 0, while the assistant's claim of 38% growth is contradicted by the data. Home revenue surged from 12600 to 83200 in November, driven by Air Fryer (104000 in total, the top product), and East rose from 6400 to 50900 over the three months.

## File index

| File | Part |
|---|---|
| sql/00_schema_and_seed.sql | A |
| sql/q01.sql to sql/q13.sql | A |
| results/query_results.md | A |
| data/orders_enriched.csv | A (input to B) |
| data/orders_clean.csv | B (input to C) |
| docs/spreadsheet_notes.md | B |
| docs/dashboard_spec.md | C |
| docs/ai_log.md | D |
| sql/d1_corrected.sql | D |

## Assumptions
- Revenue means completed orders only. Missing amounts were left blank, not zero.
- Ties in the descending amount sort keep order_id order.
- Name cleaning uses PROPER(TRIM(...)); no screenshots or binary files are included.
