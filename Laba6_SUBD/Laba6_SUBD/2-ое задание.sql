USE User_Actions;

--Находим самую раннюю дату логов в таблице User_Logs
SELECT MIN(action_date) FROM User_Logs;
--Находим самую позднюю дату логов в таблице User_Logs
SELECT MAX(action_date) FROM User_Logs;


--Подготовка структуры БД 
ALTER DATABASE User_Actions ADD FILEGROUP User_Actions_frag;
GO

--Привязываем к созданной группе новый файл
ALTER DATABASE User_Actions ADD FILE(
	NAME = 'User_Actions_frag_2025',
	FILENAME = 'D:\SQL_LABA\User_Actions_frag_2025.ndf') TO FILEGROUP User_Actions_frag;
GO


--Создание функции секционирования
CREATE PARTITION FUNCTION pf_User_Actions_year(date)
AS RANGE RIGHT FOR VALUES (
    '2025-02-01', '2025-03-01', '2025-04-01', '2025-05-01', 
    '2025-06-01', '2025-07-01', '2025-08-01', '2025-09-01', 
    '2025-10-01', '2025-11-01', '2025-12-01'
);
GO


--Создание схемы секционирования

CREATE PARTITION SCHEME ps_User_Actions_frag
AS PARTITION pf_User_Actions_year TO (
    User_Actions_frag, 
    User_Actions_frag,
	User_Actions_frag, 
    User_Actions_frag,
	User_Actions_frag, 
    User_Actions_frag,
	User_Actions_frag, 
    User_Actions_frag,
	User_Actions_frag, 
    User_Actions_frag, 
	User_Actions_frag,
    User_Actions_frag
);
GO

--Создание секционированной таблицы
CREATE TABLE User_Logs_frag(
	id uniqueidentifier default newid(),
	username TEXT NOT NULL,       
	user_action TEXT NOT NULL,
	action_date DATE NOT NULL,
	action_time TIME NOT NULL,
	action_result TEXT NOT NULL,

	CONSTRAINT pk_logs PRIMARY KEY CLUSTERED (id, action_date)
) ON ps_User_Actions_frag(action_date);
GO

--Пустая таблица
SELECT COUNT(*) FROM User_Logs_frag;

--Миграция данных
INSERT INTO User_Logs_frag (username, user_action, action_date, action_time, action_result) 
	SELECT username, user_action, action_date, action_time, action_result FROM User_Logs;

--Общее количество успешно перенесенных строк
SELECT COUNT(*) FROM User_Logs_frag;

SELECT * FROM User_Logs;     
SELECT * FROM User_Logs_frag;
