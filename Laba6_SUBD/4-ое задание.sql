USE master
GO

CREATE OR ALTER PROCEDURE dbo.sp_RestoreSector
    @BackupPath NVARCHAR(500)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = N'
    RESTORE DATABASE BackupDataBase FROM DISK = ''' + @BackupPath + '''
    WITH 
        MOVE ''User_Actions'' TO ''D:\SQL_Backups\User_Actions.mdf'',
        MOVE ''User_Actions_log'' TO ''D:\SQL_Backups\User_Actions_log.ldf'',
        REPLACE'
    EXEC (@SQL)
END
GO

EXEC dbo.sp_RestoreSector @BackupPath = N'D:\DOWNLOADS\rexs88\Volod.bak'
