USE financial_loan;
-- Converting date columns data type from TEXT to DATE --
ALTER TABLE bank_loan
ADD COLUMN issue_date_c DATE;

UPDATE bank_loan
SET issue_date_c = STR_TO_DATE(issue_date, '%d-%m-%Y');

ALTER TABLE bank_loan
ADD COLUMN last_credit_pull_date_c DATE;

UPDATE bank_loan
SET last_credit_pull_date_c = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y');

ALTER TABLE bank_loan
ADD COLUMN last_payment_date_c DATE;

UPDATE bank_loan
SET last_payment_date_c = STR_TO_DATE(last_payment_date, '%d-%m-%Y');

ALTER TABLE bank_loan
ADD COLUMN next_payment_date_c DATE;

UPDATE bank_loan
SET next_payment_date_c = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
-- FIRST DASHBOARD --
-- KPI --
  -- Total_loan_application --
  SELECT COUNT(id) AS Total_loan_application FROM bank_loan;
  -- MTD_loan_application--
  SELECT COUNT(id) AS  MTD_loan_application FROM bank_loan
  WHERE MONTH(issue_date_c) = 12 AND YEAR(issue_date_c) = 2021;
  -- PMTD_loan_application--
  SELECT COUNT(id) AS  PMTD_loan_application FROM bank_loan
  WHERE MONTH(issue_date_c) = 11 AND YEAR(issue_date_c) = 2021;
  
-- Total Funded Amount --
  -- Total Funded amount --
  SELECT SUM(loan_amount) AS Total_funded_amount FROM bank_loan;
  -- MTD_total_funded_amount --
  SELECT SUM(loan_amount) AS MTD_total_funded_amount FROM bank_loan
  WHERE MONTH(issue_date_c) = 12 AND YEAR(issue_date_c) = 2021;
  -- PMTD_total_funded_amount --
  SELECT SUM(loan_amount) AS PMTD_total_funded_amount FROM bank_loan
  WHERE MONTH(issue_date_c) = 11 AND YEAR(issue_date_c) = 2021;
  
-- Total Amount Received --
  -- Total Amount Received --
  SELECT SUM(total_payment) AS Total_amount_received FROM bank_loan;
  -- MTD_total_funded_amount --
  SELECT SUM(total_payment) AS MTD_Total_amount_received FROM bank_loan
  WHERE MONTH(issue_date_c) = 12 AND YEAR(issue_date_c) = 2021;
  -- PMTD_total_funded_amount --
  SELECT SUM(total_payment) AS PMTD_Total_amount_received FROM bank_loan
  WHERE MONTH(issue_date_c) = 11 AND YEAR(issue_date_c) = 2021;
  
-- Average Interest Rate --
  -- Avg_interest_rate--
  SELECT FORMAT(AVG(int_rate) * 100, 2) AS Avg_interest_rate FROM bank_loan;
  -- MTD_Avg_interest_rate --
  SELECT FORMAT(AVG(int_rate) * 100, 2) AS MTD_Avg_interest_rate FROM bank_loan
  WHERE MONTH(issue_date_c) = 12 AND YEAR(issue_date_c) = 2021;
  -- PMTD_Avg_interest_rate --
  SELECT FORMAT(AVG(int_rate) * 100, 2) AS PMTD_Avg_interest_rate FROM bank_loan
  WHERE MONTH(issue_date_c) = 11 AND YEAR(issue_date_c) = 2021;
  
  -- Average debt-to-income(dti) Rate --
  -- Avg_dti_rate--
  SELECT FORMAT(AVG(dti) * 100, 2) AS Avg_dti_rate FROM bank_loan;
  -- MTD_Avg_dti_rate --
  SELECT FORMAT(AVG(dti) * 100, 2) AS MTD_Avg_dti_rate FROM bank_loan
  WHERE MONTH(issue_date_c) = 12 AND YEAR(issue_date_c) = 2021;
  -- PMTD_Avg_dti_rate --
  SELECT FORMAT(AVG(dti) * 100, 2) AS PMTD_Avg_dti_rate FROM bank_loan
  WHERE MONTH(issue_date_c) = 11 AND YEAR(issue_date_c) = 2021;
  
-- Good loan and bad loan --
 -- Good Loan --
   -- Good Loan Percentage --
   SELECT ROUND((COUNT(CASE WHEN loan_status IN ("Fully Paid","Current") THEN id END) * 100)
   / COUNT(id), 2) AS Good_loan_percentage FROM bank_loan;
   -- Good Loan Application --
   SELECT COUNT(id) AS Good_loan_application FROM bank_loan
   WHERE loan_status IN  ("Fully Paid","Current");
   -- Good Loan Funded Amount --
   SELECT SUM(loan_amount) AS Good_loan_funded_amount FROM bank_loan
   WHERE loan_status IN  ("Fully Paid","Current");
   -- Good Loan Received Amount --
   SELECT SUM(total_payment) AS Good_loan_payment_amount FROM bank_loan
   WHERE loan_status IN  ("Fully Paid","Current");
   
-- Bad Loan --
   -- Bad Loan Percentage --
   SELECT ROUND((COUNT(CASE WHEN loan_status IN ("Charged off") THEN id END) * 100)
   / COUNT(id), 2) AS bad_loan_percentage FROM bank_loan;
   -- Bad Loan Application --
   SELECT COUNT(id) AS bad_loan_application FROM bank_loan
   WHERE loan_status IN  ("Charged off");
   -- Bad Loan Funded Amount --
   SELECT SUM(loan_amount) AS bad_loan_funded_amount FROM bank_loan
   WHERE loan_status IN  ("Charged off");
   -- Bad Loan Received Amount --
   SELECT SUM(total_payment) AS bad_loan_payment_amount FROM bank_loan
   WHERE loan_status IN  ("Charged off");
   
-- Loan Status --
 SELECT 
	loan_status,
    COUNT(id) AS Total_loan_applications,
    SUM(total_payment) AS total_amount_received,
    SUM(loan_amount) AS total_funded_amount,
    AVG(int_rate * 100) AS average_rate,
    AVG(dti * 100) AS dti
FROM bank_loan
GROUP BY loan_status;

SELECT 
	loan_status,
    SUM(loan_amount) AS MTD_total_funded_amount,
    SUM(total_payment) AS MTD_total_received_amount
FROM bank_loan
WHERE MONTH(issue_date_c) = 12
GROUP BY loan_status

-- SECOND DASHBOARD --
-- 1) Monthly Trend by issue date(Line Chart) --
	SELECT 
    MONTH(issue_date_c) as Month_Number,
    DATE_FORMAT(issue_date_c, '%M') as Month_Name,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY Month_Number, Month_Name
    ORDER BY Month_Number
    
   -- 1) Regional Analysis by State (Filled Map) --
	SELECT 
    address_state,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY address_state
    ORDER BY Total_loan_applications DESC
    
-- Loan Term Analysis (Donut Chart) --
	SELECT 
    term,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY term
    ORDER BY Total_loan_applications DESC
    
-- Employee Length Analysis (Bar Chart) --
	SELECT 
    emp_length,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY emp_length
    ORDER BY Total_loan_applications DESC;
    
-- Home Ownership Analysis (Treemap) --
	SELECT 
    home_ownership,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY home_ownership
    ORDER BY Total_loan_applications DESC;

-- Loan Purpose Breakdown (Bar Chart) --
    SELECT 
    purpose,
    COUNT(id) AS Total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
    FROM bank_loan
    GROUP BY purpose
    ORDER BY Total_loan_applications DESC;


    
  

