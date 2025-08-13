/* ========================== PR1 ==========================  */
/* Registro de Usuarios   */
CREATE OR ALTER PROCEDURE practica1.PR1
(
    @Firstname    NVARCHAR(100),
    @Lastname     NVARCHAR(100),
    @Email        NVARCHAR(200),
    @DateOfBirth  DATETIME2(7),
    @Password     NVARCHAR(200),
    @Credits      INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        IF EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email)
            THROW 50001, 'PR1: Email ya existe', 1;

        DECLARE @uid UNIQUEIDENTIFIER = NEWID();
        DECLARE @now DATETIME2(7) = SYSDATETIME();

        INSERT INTO practica1.Usuarios (Id, Firstname, Lastname, Email, DateOfBirth, [Password], LastChanges, EmailConfirmed)
        VALUES (@uid, @Firstname, @Lastname, @Email, @DateOfBirth, @Password, @now, 1);

        INSERT INTO practica1.ProfileStudent (UserId, Credits)
        VALUES (@uid, @Credits);

        INSERT INTO practica1.TFA (UserId, [Status], LastUpdate)
        VALUES (@uid, 0, @now);

        DECLARE @roleStudent UNIQUEIDENTIFIER =
            (SELECT TOP 1 Id FROM practica1.Roles WHERE RoleName = 'Student');

        IF @roleStudent IS NULL
            THROW 50002, 'PR1: Rol Student no existe (ejecuta PR4 ''Student'')', 1;

        INSERT INTO practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
        VALUES (@roleStudent, @uid, 1);

        INSERT INTO practica1.Notification (UserId, [Message], [Date])
        VALUES (@uid, N'Bienvenido. Usuario registrado.', @now);

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (@now, 'PR1: OK -> ' + @Email);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR1: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO

/* ========================== PR2 ==========================  */
/* Cambio de Roles    */
CREATE OR ALTER PROCEDURE practica1.PR2
(
    @Email NVARCHAR(200),
    @CodCourse INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @uid UNIQUEIDENTIFIER = (SELECT Id FROM practica1.Usuarios WHERE Email = @Email);
        IF @uid IS NULL THROW 50010, 'PR2: Usuario no existe', 1;

        IF (SELECT EmailConfirmed FROM practica1.Usuarios WHERE Id = @uid) <> 1
            THROW 50011, 'PR2: Email no confirmado', 1;

        DECLARE @roleTutor UNIQUEIDENTIFIER =
            (SELECT TOP 1 Id FROM practica1.Roles WHERE RoleName = 'Tutor');
        IF @roleTutor IS NULL THROW 50012, 'PR2: Rol Tutor no existe (ejecuta PR4 ''Tutor'')', 1;

        IF NOT EXISTS (SELECT 1 FROM practica1.UsuarioRole WHERE UserId = @uid AND RoleId = @roleTutor)
            INSERT INTO practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
            VALUES (@roleTutor, @uid, 1);

        IF NOT EXISTS (SELECT 1 FROM practica1.TutorProfile WHERE UserId = @uid)
            INSERT INTO practica1.TutorProfile (UserId, TutorCode)
            VALUES (@uid, CONCAT('TUT-', RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8)));

        IF NOT EXISTS (SELECT 1 FROM practica1.Course WHERE CodCourse = @CodCourse)
            THROW 50013, 'PR2: Curso no existe', 1;

        IF NOT EXISTS (SELECT 1 FROM practica1.CourseTutor WHERE TutorId = @uid AND CourseCodCourse = @CodCourse)
            INSERT INTO practica1.CourseTutor (TutorId, CourseCodCourse)
            VALUES (@uid, @CodCourse);

        INSERT INTO practica1.Notification (UserId, [Message], [Date])
        VALUES (@uid, N'Promovido a Tutor del curso ' + CONVERT(NVARCHAR(10), @CodCourse), SYSDATETIME());

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR2: OK -> ' + @Email + ' / curso ' + CONVERT(NVARCHAR(10), @CodCourse));

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR2: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO


/* ========================== PR3 ==========================  */
/* Asignación de Curso   */
CREATE OR ALTER PROCEDURE practica1.PR3
(
    @Email NVARCHAR(200),
    @CodCourse INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @uid UNIQUEIDENTIFIER = (SELECT Id FROM practica1.Usuarios WHERE Email = @Email);
        IF @uid IS NULL THROW 50020, 'PR3: Usuario no existe', 1;

        DECLARE @credits INT = (SELECT Credits FROM practica1.ProfileStudent WHERE UserId = @uid);
        IF @credits IS NULL THROW 50021, 'PR3: Perfil estudiante no existe', 1;

        DECLARE @req INT = (SELECT CreditsRequired FROM practica1.Course WHERE CodCourse = @CodCourse);
        IF @req IS NULL THROW 50022, 'PR3: Curso no existe', 1;

        IF @credits < @req THROW 50023, 'PR3: Créditos insuficientes', 1;

        IF NOT EXISTS (SELECT 1 FROM practica1.CourseAssignment WHERE StudentId = @uid AND CourseCodCourse = @CodCourse)
            INSERT INTO practica1.CourseAssignment (StudentId, CourseCodCourse)
            VALUES (@uid, @CodCourse);

        INSERT INTO practica1.Notification (UserId, [Message], [Date])
        VALUES (@uid, N'Asignado al curso ' + CONVERT(NVARCHAR(10), @CodCourse), SYSDATETIME());

        INSERT INTO practica1.Notification (UserId, [Message], [Date])
        SELECT ct.TutorId,
               N'Estudiante ' + @Email + N' asignado al curso ' + CONVERT(NVARCHAR(10), @CodCourse),
               SYSDATETIME()
        FROM practica1.CourseTutor ct
        WHERE ct.CourseCodCourse = @CodCourse;

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR3: OK -> ' + @Email + ' / curso ' + CONVERT(NVARCHAR(10), @CodCourse));

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR3: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
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
            INSERT INTO practica1.HistoryLog ([Date], [Description])
            VALUES (SYSDATETIME(), 'PR4: Rol ya existe -> ' + @RoleName);
            COMMIT;
            RETURN;
        END

        INSERT INTO practica1.Roles (Id, RoleName)
        VALUES (NEWID(), @RoleName);

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR4: Rol creado -> ' + @RoleName);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR4: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
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

        DECLARE @CodCourse INT = (SELECT ISNULL(MAX(CodCourse), 0) + 1 FROM practica1.Course);

        INSERT INTO practica1.Course (CodCourse, [Name], CreditsRequired)
        VALUES (@CodCourse, @Name, @CreditsRequired);

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR5: Curso creado -> ' + @Name);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR5: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO

/* ========================== PR6 ==========================  */
/*  Validación de Datos  */
CREATE OR ALTER PROCEDURE practica1.PR6
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        /* Constraints legibles SIN helpers */
        IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Usuarios_Firstname_LettersOnly')
            ALTER TABLE practica1.Usuarios
            ADD CONSTRAINT CK_Usuarios_Firstname_LettersOnly
            CHECK (Firstname NOT LIKE '%[^A-Za-zÁÉÍÓÚáéíóúÑñ ]%');

        IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Usuarios_Lastname_LettersOnly')
            ALTER TABLE practica1.Usuarios
            ADD CONSTRAINT CK_Usuarios_Lastname_LettersOnly
            CHECK (Lastname NOT LIKE '%[^A-Za-zÁÉÍÓÚáéíóúÑñ ]%');

        IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Course_CreditsRequired_NonNegative')
            ALTER TABLE practica1.Course
            ADD CONSTRAINT CK_Course_CreditsRequired_NonNegative
            CHECK (CreditsRequired >= 0);

        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR6: OK constraints');

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog ([Date], [Description])
        VALUES (SYSDATETIME(), 'PR6: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END;
GO