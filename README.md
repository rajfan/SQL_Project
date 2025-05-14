# Customer Sales Analysis Project

## Overview
SQL-based customer segmentation analysis providing:
- Customer lifetime value calculation
- Age group segmentation
- Purchase recency metrics
- VIP customer identification

## Key Features
- 🎯 Customer tier classification (VIP/Regular/New)
- 📊 Age group categorization
- 📅 Customer activity timeline analysis
- 💰 Revenue potential assessment

## Usage
1. Run in any PostgreSQL-compatible database
2. Requires tables:
   - `c_sales` (sales data)
   - `a_customers` (customer demographics)

## Metrics Calculated
| Metric | Description |
|---|---|
| `total_sales` | Lifetime spending per customer |
| `recency_months` | Months since last purchase |
| `lifespan_months` | Customer engagement duration |
