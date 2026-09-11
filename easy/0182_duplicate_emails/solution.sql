-- LeetCode 182: Duplicate Emails
-- Language: MySQL / PostgreSQL / MS SQL Server

SELECT 
    email AS Email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;
