SELECT 
    ticket_id,
    agent_name,
    channel,
    created_at,
    resolved_at,
    TIMESTAMPDIFF(MINUTE, created_at, resolved_at) AS duration_minutes,
    csat_score
FROM 
    support_tickets
WHERE 
    issue_category = 'Password Reset'
ORDER BY 
    duration_minutes DESC;