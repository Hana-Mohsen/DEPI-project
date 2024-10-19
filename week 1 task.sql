-- This query counts the total number of feedback entries each customer has submitted.
SELECT 
    c.customer_id,  -- Selects the customer ID
    c.name AS customer_name,  -- Selects the customer name
    COUNT(*) AS total_feedback  -- Counts the total number of rows (feedback entries) for each customer
FROM FeedbackForms f  -- Uses the FeedbackForms table
JOIN CustomerProfiles c ON f.customer_id = c.customer_id  -- Joins the CustomerProfiles table to match feedback with customers
GROUP BY c.customer_id, c.name  -- Groups the results by customer ID and name to count feedback for each customer
ORDER BY total_feedback DESC;  -- Orders the results by the total number of feedback entries in descending order


-- This query calculates the average feedback count and average feedback text length for each category.
SELECT 
    cat.category_name,  -- Selects the category name
    COUNT(*) AS feedback_count,  -- Counts the total number of feedback entries in each category
    AVG(LEN(CAST(f.feedback_text AS VARCHAR(MAX)))) AS avg_feedback_length  -- Calculates the average length of feedback texts (converting TEXT to VARCHAR)
FROM FeedbackForms f  -- Uses the FeedbackForms table
JOIN FeedbackCategories cat ON f.category_id = cat.category_id  -- Joins the FeedbackCategories table to match feedback with categories
GROUP BY cat.category_name  -- Groups the results by category name to calculate the count and average for each category
ORDER BY feedback_count DESC;  -- Orders the results by feedback count in descending order





-- This query retrieves the top 5 customers who have submitted the most feedback.
SELECT TOP 5
    c.customer_id,  -- Selects the customer ID
    c.name AS customer_name,  -- Selects the customer name
    COUNT(*) AS feedback_count  -- Counts the total number of feedback entries submitted by the customer
FROM FeedbackForms f  -- Uses the FeedbackForms table
JOIN CustomerProfiles c ON f.customer_id = c.customer_id  -- Joins the CustomerProfiles table to match feedback with customers
GROUP BY c.customer_id, c.name  -- Groups the results by customer ID and name to count feedback for each customer
ORDER BY feedback_count DESC;  -- Orders the results by feedback count in descending order





-- This query summarizes the number of feedback entries for each feedback category.
SELECT 
    cat.category_name,  -- Selects the category name
    COUNT(*) AS feedback_count  -- Counts the total number of feedback entries for each category
FROM FeedbackForms f  -- Uses the FeedbackForms table
JOIN FeedbackCategories cat ON f.category_id = cat.category_id  -- Joins the FeedbackCategories table to match feedback with categories
GROUP BY cat.category_name  -- Groups the results by category name to count feedback entries for each category
ORDER BY feedback_count DESC;  -- Orders the results by feedback count in descending order






-- This query retrieves all feedback entries along with the corresponding customer names.
-- This query retrieves all feedback entries from the Reviews table without joining with CustomerProfiles.
SELECT 
    f.Id AS feedback_id,  -- Selects the feedback ID
    f.ProfileName AS customer_name,  -- Selects the customer's profile name
    f.Score,  -- Selects the score given by the customer for the feedback
    f.Summary,  -- Selects the summary of the feedback
    f.Text  -- Selects the full text of the feedback
FROM [project].[dbo].[Reviews$] f  -- Uses the Reviews$ table
ORDER BY f.Id;  -- Orders the results by feedback ID in ascending order


