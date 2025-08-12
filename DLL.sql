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

/* ========================== PR5 ==========================  */
/* Creación de Cursos  */
CREATE OR ALTER PROCEDURE practica1.PR5
(
    @Name NVARCHAR(200),
    @CreditsRequired INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @CodCourse INT = (SELECT ISNULL(MAX(CodCourse),0)+1 FROM practica1.Course);

        INSERT INTO practica1.Course(CodCourse,[Name],CreditsRequired)
        VALUES (@CodCourse,@Name,@CreditsRequired);

        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR5: Curso creado -> ' + @Name);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR5: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END
GO