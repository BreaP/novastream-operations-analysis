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