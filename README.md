# EGX Financials Dashboard

A Power BI dashboard that shows the quarterly financial statements of companies listed on the **Egyptian Exchange (EGX)**.

The project covers the full path: scrape the data, store it in SQL Server, model it as a star schema, and visualize it in Power BI.

## How It Works

```
stockanalysis.com  →  Python (scraping)  →  SQL Server  →  Star Schema  →  Power BI
```

1. **Scrape:** A Python notebook collects quarterly financial statements for each EGX company.
2. **Clean:** The data is reshaped into one table with these columns: `Company`, `Statement Type`, `Financial Term`, `End Of Quarter`, `Amount`.
3. **Store:** The table is loaded into SQL Server as `FactFinancial`.
4. **Model:** A SQL script turns it into a star schema.
5. **Visualize:** Power BI reads the star schema and builds the dashboard.

## Data

- **Source:** [stockanalysis.com](https://stockanalysis.com)
- **Frequency:** Quarterly
- **Statements:** Income Statement, Balance Sheet, Cash Flow Statement

## Star Schema

**Fact table**
- `FactFinancial_Star` — one row per company, quarter, and financial term, with the `Amount`

**Dimension tables**
- `DimCompany` — company ticker
- `DimDate` — quarter end date, year, quarter
- `DimStatement` — statement type
- `DimFinancialTerm` — financial term (for example Revenue, Net Income)

## Dashboard Pages

| Page | What it shows |
|------|---------------|
| Overview | Main numbers at a glance |
| Profit & Loss | Revenue, costs, and profit |
| Balance Sheet | Assets, liabilities, and equity |
| Liquidity & Leverage | Short-term ability to pay and debt level |
| Working Capital | Working capital and its components |
| Compare Companies | Side-by-side comparison of companies |

## Project Files

| File | Description |
|------|-------------|
| `webScraping_CampanyEGX.ipynb` | Scrapes and cleans the data, then loads it into SQL Server |
| `SQL_StarSchema.sql` | Builds the dimension tables and the star schema fact table |
| `EGX_Dashboard.pbix` | The Power BI dashboard |

## Tools Used

Python (requests, pandas) · SQL Server · Power BI (DAX)

