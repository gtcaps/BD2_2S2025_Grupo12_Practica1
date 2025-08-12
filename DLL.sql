USE BD2;
GO

/* ========================== PR4 ==========================  */
/* Creación de roles para estudiantes */
CREATE OR ALTER PROCEDURE practica1.PR4
(
    @RoleName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        IF EXISTS (SELECT 1 FROM practica1.Roles WHERE RoleName = @RoleName)
        BEGIN
            INSERT INTO practica1.HistoryLog([Date],[Description])
            VALUES (SYSDATETIME(), 'PR4: Rol ya existe -> ' + @RoleName);
            COMMIT;
            RETURN;
        END

        INSERT INTO practica1.Roles(Id, RoleName)
        VALUES (NEWID(), @RoleName);

        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR4: Rol creado -> ' + @RoleName);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR4: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END
GO