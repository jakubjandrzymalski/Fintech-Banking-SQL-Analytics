/*******************************************************************************
  BANKING DATASET STRUCTURE & ANALYTICAL QUERIES
  Author: Jakub D
  Description: This script creates a banking database schema and performs 
               advanced data analysis including window functions and CTEs.
*******************************************************************************/

-- ==========================================
-- 1. SCHEMA DEFINITION
-- ==========================================

-- Bank Customers Table
CREATE TABLE users (
    user_id       INT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    email         VARCHAR(100),
    country       VARCHAR(50),
    signup_date   DATE,
    account_level VARCHAR(20) -- Values: 'Basic', 'Silver', 'Gold'
);

-- Transaction Ledger Table
CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY,
    user_id          INT,
    amount           DECIMAL(12, 2),
    currency         VARCHAR(3),
    transaction_date TIMESTAMP,
    category         VARCHAR(50), -- Values: 'Shopping', 'Entertainment', 'Transfer', 'Cash'
    status           VARCHAR(20), -- Values: 'Completed', 'Pending', 'Declined'
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Behavioral Logs Table
CREATE TABLE user_activity (
    log_id             INT PRIMARY KEY,
    user_id            INT,
    activity_type      VARCHAR(50), -- Values: 'Login', 'App_Open', 'Support_Ticket'
    activity_timestamp TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==========================================
-- 2. DATA INGESTION
-- ==========================================

-- Seeding Users Data
INSERT ALL
  INTO users VALUES (1, 'Jan', 'Kowalski', 'jan.k@email.com', 'Poland', DATE '2023-01-15', 'Gold')
  INTO users VALUES (2, 'Anna', 'Nowak', 'a.nowak@email.com', 'Poland', DATE '2023-02-10', 'Basic')
  INTO users VALUES (3, 'John', 'Doe', 'j.doe@email.com', 'USA', DATE '2023-01-20', 'Silver')
  INTO users VALUES (4, 'Marie', 'Curie', 'm.curie@email.com', 'France', DATE '2023-03-05', 'Gold')
  INTO users VALUES (5, 'Hans', 'Schmidt', 'h.schmidt@email.com', 'Germany', DATE '2023-03-12', 'Basic')
  INTO users VALUES (6, 'Elena', 'Rossi', 'e.rossi@email.com', 'Italy', DATE '2023-04-01', 'Silver')
  INTO users VALUES (7, 'Piotr', 'Zieliński', 'p.zielinski@email.com', 'Poland', DATE '2023-04-15', 'Basic')
  INTO users VALUES (8, 'Sofia', 'Garcia', 's.garcia@email.com', 'Spain', DATE '2023-05-20', 'Gold')
  INTO users VALUES (9, 'Lukas', 'Müller', 'l.muller@email.com', 'Germany', DATE '2023-05-25', 'Silver')
  INTO users VALUES (10, 'Emma', 'Brown', 'e.brown@email.com', 'UK', DATE '2023-06-01', 'Basic')
  INTO users VALUES (11, 'Adam', 'Wiśniewski', 'a.wisnia@email.com', 'Poland', DATE '2023-06-10', 'Gold')
  INTO users VALUES (12, 'Olivia', 'Smith', 'o.smith@email.com', 'USA', DATE '2023-06-15', 'Silver')
  INTO users VALUES (13, 'Liam', 'Wilson', 'l.wilson@email.com', 'UK', DATE '2023-07-01', 'Basic')
  INTO users VALUES (14, 'Mia', 'Martinez', 'm.martinez@email.com', 'Spain', DATE '2023-07-05', 'Gold')
  INTO users VALUES (15, 'Noah', 'Anderson', 'n.anderson@email.com', 'USA', DATE '2023-07-10', 'Silver')
  INTO users VALUES (16, 'Chloe', 'Taylor', 'c.taylor@email.com', 'UK', DATE '2023-08-01', 'Basic')
  INTO users VALUES (17, 'Stanisław', 'Wójcik', 's.wojcik@email.com', 'Poland', DATE '2023-08-15', 'Gold')
  INTO users VALUES (18, 'Zoe', 'Thomas', 'z.thomas@email.com', 'USA', DATE '2023-08-20', 'Silver')
  INTO users VALUES (19, 'Leo', 'Hernandez', 'l.hernandez@email.com', 'Spain', DATE '2023-09-01', 'Basic')
  INTO users VALUES (20, 'Maja', 'Szymańska', 'm.szym@email.com', 'Poland', DATE '2023-09-10', 'Gold')
SELECT * FROM dual;

-- Seeding Transactional Data
INSERT ALL
  INTO transactions VALUES (101, 1, 150.00, 'PLN', TIMESTAMP '2023-10-01 10:00:00', 'Shopping', 'Completed')
  INTO transactions VALUES (102, 1, 2000.00, 'PLN', TIMESTAMP '2023-10-02 12:30:00', 'Transfer', 'Completed')
  INTO transactions VALUES (103, 2, 45.50, 'PLN', TIMESTAMP '2023-10-02 15:00:00', 'Entertainment', 'Completed')
  INTO transactions VALUES (104, 3, 120.00, 'USD', TIMESTAMP '2023-10-03 09:15:00', 'Shopping', 'Completed')
  INTO transactions VALUES (105, 4, 300.00, 'EUR', TIMESTAMP '2023-10-04 18:45:00', 'Transfer', 'Completed')
  INTO transactions VALUES (106, 5, 15.00, 'EUR', TIMESTAMP '2023-10-05 08:00:00', 'Cash', 'Declined')
  INTO transactions VALUES (107, 6, 85.00, 'EUR', TIMESTAMP '2023-10-05 20:30:00', 'Shopping', 'Completed')
  INTO transactions VALUES (108, 7, 200.00, 'PLN', TIMESTAMP '2023-10-06 11:00:00', 'Transfer', 'Pending')
  INTO transactions VALUES (109, 8, 500.00, 'EUR', TIMESTAMP '2023-10-07 14:00:00', 'Shopping', 'Completed')
  INTO transactions VALUES (110, 9, 10.00, 'EUR', TIMESTAMP '2023-10-07 16:20:00', 'Entertainment', 'Completed')
  INTO transactions VALUES (111, 10, 150.00, 'GBP', TIMESTAMP '2023-10-08 19:00:00', 'Shopping', 'Completed')
  INTO transactions VALUES (112, 1, 50.00, 'PLN', TIMESTAMP '2023-10-09 10:00:00', 'Entertainment', 'Completed')
  INTO transactions VALUES (113, 3, 1000.00, 'USD', TIMESTAMP '2023-10-10 12:00:00', 'Transfer', 'Completed')
  INTO transactions VALUES (114, 12, 55.00, 'USD', TIMESTAMP '2023-10-11 15:45:00', 'Shopping', 'Completed')
  INTO transactions VALUES (115, 14, 25.00, 'EUR', TIMESTAMP '2023-10-12 09:00:00', 'Cash', 'Completed')
  INTO transactions VALUES (116, 17, 4500.00, 'PLN', TIMESTAMP '2023-10-13 21:00:00', 'Transfer', 'Completed')
  INTO transactions VALUES (117, 1, 12.00, 'PLN', TIMESTAMP '2023-10-14 08:30:00', 'Shopping', 'Completed')
  INTO transactions VALUES (118, 8, 90.00, 'EUR', TIMESTAMP '2023-10-15 13:10:00', 'Entertainment', 'Completed')
  INTO transactions VALUES (119, 20, 300.00, 'PLN', TIMESTAMP '2023-10-16 17:00:00', 'Shopping', 'Completed')
  INTO transactions VALUES (120, 15, 200.00, 'USD', TIMESTAMP '2023-10-17 11:20:00', 'Transfer', 'Declined')
  INTO transactions VALUES (121, 1, 100.00, 'PLN', TIMESTAMP '2023-10-18 14:00:00', 'Shopping', 'Completed')
SELECT * FROM dual;

-- Seeding Activity Logs
INSERT ALL
  INTO user_activity VALUES (501, 1, 'Login', TIMESTAMP '2023-10-01 09:55:00')
  INTO user_activity VALUES (502, 2, 'App_Open', TIMESTAMP '2023-10-02 14:50:00')
  INTO user_activity VALUES (503, 3, 'Login', TIMESTAMP '2023-10-03 09:00:00')
  INTO user_activity VALUES (504, 4, 'Login', TIMESTAMP '2023-10-04 18:30:00')
  INTO user_activity VALUES (505, 5, 'App_Open', TIMESTAMP '2023-10-05 07:50:00')
  INTO user_activity VALUES (506, 6, 'Login', TIMESTAMP '2023-10-05 20:15:00')
  INTO user_activity VALUES (507, 7, 'App_Open', TIMESTAMP '2023-10-06 10:45:00')
  INTO user_activity VALUES (508, 8, 'Login', TIMESTAMP '2023-10-07 13:50:00')
  INTO user_activity VALUES (509, 9, 'Login', TIMESTAMP '2023-10-07 16:10:00')
  INTO user_activity VALUES (510, 10, 'App_Open', TIMESTAMP '2023-10-08 18:45:00')
  INTO user_activity VALUES (511, 1, 'Login', TIMESTAMP '2023-10-09 09:45:00')
  INTO user_activity VALUES (512, 3, 'App_Open', TIMESTAMP '2023-10-10 11:45:00')
  INTO user_activity VALUES (513, 12, 'Login', TIMESTAMP '2023-10-11 15:30:00')
  INTO user_activity VALUES (514, 14, 'Support_Ticket', TIMESTAMP '2023-10-12 10:00:00')
  INTO user_activity VALUES (515, 17, 'Login', TIMESTAMP '2023-10-13 20:50:00')
  INTO user_activity VALUES (516, 1, 'App_Open', TIMESTAMP '2023-10-14 08:15:00')
  INTO user_activity VALUES (517, 8, 'Login', TIMESTAMP '2023-10-15 13:00:00')
  INTO user_activity VALUES (518, 20, 'Login', TIMESTAMP '2023-10-16 16:45:00')
  INTO user_activity VALUES (519, 15, 'App_Open', TIMESTAMP '2023-10-17 11:10:00')
  INTO user_activity VALUES (520, 1, 'Login', TIMESTAMP '2023-10-18 13:45:00')
SELECT * FROM dual;

COMMIT;

-- ==========================================
-- 3. ANALYTICAL QUERIES
-- ==========================================

-- TASK 1: MARKETING SEGMENTATION
-- Business Goal: Identify premium users (Silver/Gold) who joined in H1 2023 for a loyalty campaign.
SELECT email, country, signup_date, account_level
FROM users
WHERE account_level IN ('Silver', 'Gold')
      AND signup_date BETWEEN DATE '2023-01-01' AND DATE '2023-07-01'
ORDER BY signup_date DESC;


-- TASK 2: RISK & FRAUD ANALYSIS (DECLINED TRANSACTIONS)
-- Business Goal: Analyze payment failure rates by country to identify potential payment gateway issues.
SELECT u.country, 
       COUNT(*) AS total_declined,
       ROUND(AVG(amount), 2) AS avg_declined_amount
FROM transactions t 
JOIN users u ON t.user_id = u.user_id
WHERE status = 'Declined'
GROUP BY u.country
ORDER BY total_declined DESC;


-- TASK 3: DATA QUALITY CHECK (INACTIVE ACCOUNTS)
-- Business Goal: Find "Ghost Accounts" (users who registered but never made a transaction).
SELECT u.first_name, u.last_name, u.email
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id
WHERE t.transaction_id IS NULL;


-- TASK 4: FINANCIAL TREND ANALYSIS (ROLLING BALANCE)
-- Business Goal: Calculate a cumulative sum of transactions for a specific user to track wallet flow.
SELECT user_id, 
       transaction_date, 
       amount, 
       SUM(amount) OVER (PARTITION BY user_id ORDER BY transaction_date) AS rolling_balance
FROM transactions
WHERE user_id = 1
ORDER BY transaction_date;


-- TASK 5: SECURITY - FRAUD DETECTION
-- Business Goal: Identify rapid-fire transactions by calculating the time gap between consecutive events.
SELECT d.*, 
       (transaction_date - previous_transaction_date) AS time_gap_days
FROM (
    SELECT user_id, 
           transaction_id, 
           transaction_date, 
           LAG(transaction_date, 1) OVER (PARTITION BY user_id ORDER BY transaction_date) AS previous_transaction_date
    FROM transactions
) d;


-- TASK 6: CUSTOMER RANKING BY SPENDING (CTE + DENSE_RANK)
-- Business Goal: Rank customers within their respective countries based on their total transaction volume.
WITH User_Spending AS (
    SELECT u.user_id, 
           u.first_name, 
           u.last_name, 
           u.country,
           SUM(t.amount) AS total_spent
    FROM users u
    JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.user_id, u.first_name, u.last_name, u.country
)
SELECT country, 
       first_name, 
       last_name, 
       total_spent,
       DENSE_RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS country_rank
FROM User_Spending;