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

        IF EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email=@Email)
            THROW 50001, 'PR1: Email ya existe', 1;

        DECLARE @uid UNIQUEIDENTIFIER = NEWID();
        DECLARE @now DATETIME2(7) = SYSDATETIME();

        INSERT INTO practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, [Password], LastChanges, EmailConfirmed)
        VALUES (@uid, @Firstname, @Lastname, @Email, @DateOfBirth, @Password, @now, 1);

        INSERT INTO practica1.ProfileStudent(UserId, Credits)
        VALUES (@uid, @Credits);

        INSERT INTO practica1.TFA(UserId, [Status], LastUpdate)
        VALUES (@uid, 0, @now);

        DECLARE @roleStudent UNIQUEIDENTIFIER =
            (SELECT TOP 1 Id FROM practica1.Roles WHERE RoleName='Student');

        IF @roleStudent IS NULL
            THROW 50002, 'PR1: Rol Student no existe (ejecuta PR4 ''Student'')', 1;

        INSERT INTO practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
        VALUES (@roleStudent, @uid, 1);

        INSERT INTO practica1.Notification(UserId,[Message],[Date])
        VALUES (@uid, N'Bienvenido. Usuario registrado.', @now);

        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (@now, 'PR1: Usuario Registrado -> ' + @Email);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR1: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END
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

        DECLARE @uid UNIQUEIDENTIFIER = (SELECT Id FROM practica1.Usuarios WHERE Email=@Email);
        IF @uid IS NULL THROW 50010, 'PR2: Usuario no existe', 1;

        IF (SELECT EmailConfirmed FROM practica1.Usuarios WHERE Id=@uid) <> 1
            THROW 50011, 'PR2: Email no confirmado', 1;

        DECLARE @roleTutor UNIQUEIDENTIFIER =
            (SELECT TOP 1 Id FROM practica1.Roles WHERE RoleName='Tutor');
        IF @roleTutor IS NULL THROW 50012, 'PR2: Rol Tutor no existe', 1;

        IF NOT EXISTS (SELECT 1 FROM practica1.UsuarioRole WHERE UserId=@uid AND RoleId=@roleTutor)
            INSERT INTO practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
            VALUES (@roleTutor, @uid, 1);

        IF NOT EXISTS (SELECT 1 FROM practica1.TutorProfile WHERE UserId=@uid)
            INSERT INTO practica1.TutorProfile(UserId, TutorCode)
            VALUES (@uid, CONCAT('TUT-', RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8)));

        IF NOT EXISTS (SELECT 1 FROM practica1.Course WHERE CodCourse=@CodCourse)
            THROW 50013, 'PR2: Curso no existe', 1;

        IF NOT EXISTS (SELECT 1 FROM practica1.CourseTutor WHERE TutorId=@uid AND CourseCodCourse=@CodCourse)
            INSERT INTO practica1.CourseTutor(TutorId, CourseCodCourse)
            VALUES (@uid, @CodCourse);

        INSERT INTO practica1.Notification(UserId,[Message],[Date])
        VALUES (@uid, N'Promovido a Tutor del curso ' + CONVERT(NVARCHAR(10),@CodCourse), SYSDATETIME());

        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR2: OK -> ' + @Email + ' / curso ' + CONVERT(NVARCHAR(10),@CodCourse));

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO practica1.HistoryLog([Date],[Description])
        VALUES (SYSDATETIME(), 'PR2: Error -> ' + ERROR_MESSAGE());
        THROW;
    END CATCH
END
GO