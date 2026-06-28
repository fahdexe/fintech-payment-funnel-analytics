# Fintech Operational Analytics & Payment Funnel Optimisation

An end to end analytics project simulating an enterprise transactional environment across India (INR), KSA (SAR), and UAE (AED) to detect and quantify revenue leakage.

## Tech Stack & Architecture
* **Data Generation:** Python (Pandas, NumPy) via Google Colab
* **Database & Pipeline:** MySQL Workbench (CTEs, Window Functions)
* **Business Intelligence:** Tableau Desktop (SLA Heatmaps, Dynamic Filtering)

## Live Interactive Dashboard
👉 [https://public.tableau.com/app/profile/mutalib.ilyas.mohammed/viz/PaymentFunnelRouteOptimization/Sheet1]

## Core Insights Discovered
* Isolated a distinct systemic `SYSTEM_TIMEOUT` anomaly hitting Checkout.com in the KSA market.
* Quantified technical revenue leakage to separate preventable engineering infrastructure bugs from standard user errors (e.g., insufficient funds).
