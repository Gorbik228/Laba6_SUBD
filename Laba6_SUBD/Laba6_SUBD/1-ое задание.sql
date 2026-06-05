create database User_Actions
use User_Actions;
GO

CREATE TABLE User_Logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) NOT NULL,
    user_action NVARCHAR(200) NOT NULL,
    action_date NVARCHAR(20) NOT NULL,
    action_time NVARCHAR(20) NOT NULL,
    action_result NVARCHAR(50) NOT NULL
);
SET NOCOUNT ON;

;WITH L1 AS (SELECT 1 AS c FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) AS t(c)),
      L2 AS (SELECT 1 AS c FROM L1 AS a CROSS JOIN L1 AS b), -- 100
      L3 AS (SELECT 1 AS c FROM L2 AS a CROSS JOIN L2 AS b), -- 10,000
      L4 AS (SELECT 1 AS c FROM L3 AS a CROSS JOIN L2 AS b), -- 1,000,000
      Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNum FROM L4)

INSERT INTO User_Logs (username, user_action, action_date, action_time, action_result)
SELECT 
    'User_' + CAST(ABS(CHECKSUM(NEWID()) % 50000) + 1 AS NVARCHAR(10)) AS username, 
    
    -- Случайный выбор действия
    CASE ABS(CHECKSUM(NEWID()) % 4) 
        WHEN 0 THEN 'login'
        WHEN 1 THEN 'logout'
        WHEN 2 THEN 'view_page'
        ELSE 'click_button'
    END AS user_action,
    
    -- Случайная дата пределах 2025 года
    DATEADD(day, ABS(CHECKSUM(NEWID()) % 365), '2025-01-01') AS action_date,
    
    -- Случайное время
    CAST(DATEADD(second, ABS(CHECKSUM(NEWID()) % 86400), '00:00:00') AS TIME) AS action_time,
    
    -- Случайный результат действия
    CASE ABS(CHECKSUM(NEWID()) % 3) 
        WHEN 0 THEN 'success'
        WHEN 1 THEN 'failed'
        ELSE 'error'
    END AS action_result
FROM Nums;


select * from User_Logs