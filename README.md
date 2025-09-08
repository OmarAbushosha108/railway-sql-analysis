Railway Data Analysis using SQL

This project is a case study focused on analyzing railway operational data using SQL. The goal is to explore, clean, and extract meaningful insights from real-world transportation datasets.

Dataset Overview

The analysis is based on two CSV files:

railway.csv – Contains the core railway dataset with operational records.

railway_data_dictionary.csv – Provides descriptions for each field in the main dataset.

Objective

The main objective was to:

Analyze train schedules and performance.

Identify delays and punctuality trends.

Extract meaningful KPIs (Key Performance Indicators) to support decision-making.

SQL Analysis

The analysis was performed using SQL queries, focusing on:

Identifying trains with the highest delays.

Comparing scheduled vs. actual arrival times.

Aggregating passenger counts and train frequencies.

Highlighting operational bottlenecks.

Example Output

Below is a sample SQL query with its result (query code on the left and resulting table on the right):

Figure: Example SQL query showing average delay (minutes) by time-of-day (Morning vs Evening).

Results & Insights

Several trains demonstrated consistent delays during peak hours (morning rush shows larger average delays in this dataset).

Certain routes exhibited a notable deviation between scheduled and actual arrival times, suggesting potential operational bottlenecks.

Data inconsistencies were detected (e.g., missing or malformed timestamps); cleaning steps were required prior to reliable analysis.

How to Use

Download the dataset files and SQL script from this repository.

Open the provided .sql file in any SQL client (SQLite, DBeaver, or similar).

Import railway.csv into a table named railway (or adjust table names in the script).

Run the queries in the provided SQL script (some queries were adapted to SQLite).

Check outputs/ for exported CSV results and screenshots/ for visual examples.

Note: Large raw datasets are better hosted externally (e.g., Google Drive) and linked from this README if file size prevents direct inclusion in the repo.

Files Included

railway.csv – Main dataset.

railway_data_dictionary.csv – Column descriptions.

SQLQuery__Project UK Train.sql – Original SQL queries (source).

sql_queries_sqlite.sql – Converted/SQLite-ready queries used for execution.

outputs/ – Exported query result CSV files (e.g., query_result_longest.csv).

screenshots/ – Visualizations / example query result image(s) (e.g., query_result_preview.png).

README.md – This file.

Reproducing the Analysis

Recommended: use DB Browser for SQLite or DBeaver.

Steps:

Create/open a new SQLite database.

Import railway.csv into a table named railway (or adjust queries to your table name).

Open sql_queries_sqlite.sql and run statements sequentially.

Export any result tables as CSV to outputs/ and capture visualizations as PNG into screenshots/.

About

This case study was created as part of a Data Analysis learning initiative.
The project focuses on practical SQL-based data analysis and serves as a foundational step towards building a data analyst portfolio.
