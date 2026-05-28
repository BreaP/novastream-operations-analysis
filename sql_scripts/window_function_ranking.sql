SELECT 
    agent_name,
    COUNT(ticket_id) AS total_tickets_handled,
    ROUND(AVG(csat_score), 2) AS avg_csat_score,
    DENSE_RANK() OVER (ORDER BY AVG(csat_score) DESC) AS performance_rank
FROM 
    support_tickets
GROUP BY 
    agent_name;