# Data-Driven Operations: Optimizing Help Desk Efficiency and Dynamic SLA Triggers

## 📌 Project Overview
This project analyzes a transactional dataset of customer support interactions for **NovaStream Technologies**, a fictional premium technology ecosystem. By transforming raw support logs into structured SQL metrics and building an interactive Tableau dashboard, this analysis isolates core operational bottlenecks, evaluates workforce performance, and uncovers tracking anomalies caused by internal workflow behaviors. 

## 📊 Business Objectives
Our support organization noted perceived queue delays. This analysis was engineered to solve two primary operational metrics:
1. **Friction Point Diagnostics:** Isolate which specific technical categories or service channels yield disproportionate processing delays.
2. **Workforce Performance Analytics:** Evaluate individual agent performance rankings while validating the underlying data integrity of our system logging.

## 🛠️ Tech Stack & Skills Highlighted
- **Database Engine:** MySQL (MySQL Workbench)
- **Data Engineering:** Schema Architecture, Aggregations, Window Functions (`DENSE_RANK()`), Time-Series Performance Metrics
- **Business Intelligence:** Tableau Desktop / Tableau Public
- **Core Domain Competencies:** QA & Data Integrity, Process Improvement, Dynamic SLA Configuration

## 🗄️ Database Schema
The analysis utilizes a relational table model structured inside MySQL:
- **Table Name:** `support_tickets`
  - `ticket_id` (INT, Primary Key) - Unique identifier for every customer interaction.
  - `agent_id` (INT, Foreign Key) - Employee database reference identifier.
  - `agent_name` (VARCHAR) - Name of the handling technical support specialist.
  - `issue_category` (VARCHAR) - The classified nature of the support request.
  - `channel` (VARCHAR) - Incoming workflow medium (LiveChat, Email, Phone).
  - `created_at` / `resolved_at` (DATETIME) - Strict timestamps used for precise duration math.
  - `csat_score` (INT) - Post-interaction Customer Satisfaction score (Scale: 1-5).

## 🔍 Core SQL Analysis & Key Insights

### 1. Identifying Category Bottlenecks
Initial high-level aggregation revealed an unexpected bottleneck: basic **Password Resets** averaged a staggering **284.5 minutes** to resolve—historically performing slower than complex device repairs.

```sql
SELECT 
    issue_category,
    COUNT(ticket_id) AS total_tickets,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_at, resolved_at)), 1) AS avg_resolution_time_minutes,
    ROUND(AVG(csat_score), 2) AS avg_csat
FROM 
    support_tickets
GROUP BY 
    issue_category
ORDER BY 
    avg_resolution_time_minutes DESC;
```
