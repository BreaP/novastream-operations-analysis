# Help Desk Efficiency Analysis: Solving Tracking Anomalies with Smart Data

## 📌 Project Overview
This project looks at customer support data for **NovaStream Technologies**, a fictional tech company that handles subscriptions, cancellations, apps, and device repairs. By importing raw support logs into a MySQL database and building an interactive dashboard in Tableau, this project finds out why some customer tickets take longer to close and sets up a better system to track team workflows accurately. 

## 📊 Business Objectives
The support team noticed that customer wait times and open ticket queues seemed high. This analysis was built to answer two main questions:
1. **Where are the bottlenecks?** Figure out which types of technical issues or communication channels (like LiveChat vs. Email) take the longest to resolve.
2. **How is the team performing?** Rank individual agents by their true customer satisfaction (CSAT) scores while checking the data for tracking errors.


## 🛠️ Tech Stack & Skills Highlighted
- **Database Engine:** MySQL (MySQL Workbench)
- **Data Engineering:** Database Design, Data Aggregations, Window Functions (`DENSE_RANK()`), Time Calculations
- **Business Intelligence:** Tableau Public
- **Core Domain Competencies:** Data Integrity, Workflow Quality Assurance, Process Improvement

## 🗄️ Database Schema
The raw support data was imported into a table named `support_tickets` using these columns:
- `ticket_id` (INT, Primary Key) - A unique ID generated for every customer interaction.
- `agent_id` (INT, Foreign Key) - The ID number for the support employee.
- `agent_name` (VARCHAR) - The name of the support agent.
- `issue_category` (VARCHAR) - The type of problem (Password Reset, Subscription Charge, etc.).
- `channel` (VARCHAR) - How the customer reached out (LiveChat, Email, Phone).
- `created_at` / `resolved_at` (DATETIME) - Exact dates and timestamps used to calculate resolution times.
- `csat_score` (INT) - The customer's satisfaction rating from 1 to 5.

## 🔍 Core SQL Analysis & Key Insights

### 1. Spotting the 5-Hour Password Reset
When first aggregating the data to find the average resolution time for each type of issue, the data flagged **Password Resets** as a massive bottleneck, showing an average resolution time of **284.5 minutes** (nearly 5 hours). Knowing from real-world support experience that password resets should take minutes, this was a major red flag.

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

### 2. Finding the Ghost Tickets (Data Hygiene Audit)
**The Discovery:** The 5-hour average was a data-tracking error, not a slow service issue. Because those long-duration rows had perfect CSAT scores, the data proves the agents solved the customer's problem instantly but forgot to hit the "Close Ticket" button in their CRM dashboard when they finished, leaving the background clock running.

```sql
SELECT 
    ticket_id,
    agent_name,
    channel,
    TIMESTAMPDIFF(MINUTE, created_at, resolved_at) AS duration_minutes,
    csat_score
FROM 
    support_tickets
WHERE 
    issue_category = 'Password Reset'
ORDER BY 
    duration_minutes DESC;
```

### 3. Agent Performance Leaderboard
This query uses a SQL Window Function to group and rank the support team based on their true average customer satisfaction scores without messing up the raw data lines.

```sql
SELECT 
    agent_name,
    COUNT(ticket_id) AS total_tickets_handled,
    ROUND(AVG(csat_score), 2) AS avg_csat_score,
    DENSE_RANK() OVER (ORDER BY AVG(csat_score) DESC) AS performance_rank
FROM 
    support_tickets
GROUP BY 
    agent_name;
```



## 📈 Tableau Dashboard Deliverables
**Interactive Dashboard Link:** [View Interactive Tableau Dashboard](https://public.tableau.com/app/profile/breana.palmer/viz/NovaStreamOperationsAnalysis/NovaStreamDashboard)

The final interactive dashboard uses a dual-axis chart to map Average Resolution Time vs. Average CSAT side-by-side. This layout visually proves to stakeholders that the password reset delay was just a documentation lag, because the customer satisfaction remained flawless.

## 💡 Strategic Recommendations & Operational Insights
Instead of setting a generic, blanket system timeout that kicks agents off active screens, the following practical fixes were proposed:

**Category-Specific CRM Triggers:** Set up automated CRM closure triggers based on how complex the specific issue is. Simple fixes (like a Password Reset) get an automatic 30-minute idle reminder to close the screen. More complex tasks (like an App Crashing or scheduling a Device Repair) are given a longer window so the system doesn't trigger mid-diagnostics.

**Targeted Team Coaching:** Use the agent leaderboard to find specific workflow-closure patterns. This allows managers to give quick, targeted reminders to specific team segments about closing out live chat sessions, rather than forcing the whole company into a redundant training meeting.

