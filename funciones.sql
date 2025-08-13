/* Func_course_usuarios */

Create or Alter Function [practica1].[F1](@CodCourse int)
Returns Table
As
Return(
    Select u.Id, u.Firstname, u.Lastname, u.Email
    From practica1.CourseAssignment ca 
    Join practica1.Usuarios u On ca.StudentId = u.Id
    Join practica1.ProfileStudent ps On u.Id = ps.UserId
    Where ca.CourseCodCourse = @CodCourse
);
Go

Create or Alter Function [practica1].[F2](@Id_TutorProfile uniqueidentifier)
Returns Table
As
Return(
    Select c.CodCourse, c.Name
    From practica1.CourseTutor ct
    Join practica1.Course c On ct.CourseCodCourse = c.CodCourse
    Where ct.TutorId = @Id_TutorProfile 

);
Go

Create or Alter Function [practica1].[F3](@UserId uniqueidentifier)
Returns Table
As
Return(
    Select n.Message, n.Date
    From practica1.Notification n
    Join practica1.Usuarios u On n.UserId = u.Id
    Where n.UserId = @UserId
);
Go

Create or Alter Function [practica1].[F4]()
Returns Table
As
Return(
    Select hl.Id, hl.Date, hl.Description
    From practica1.HistoryLog hl
);
Go

Create or Alter Function [practica1].[F5](@UsuarioId uniqueidentifier)
Returns Table
As
Return(
    Select u.Firstname, u.Lastname, u.Email, u.DateOfBirth, ps.Credits, r.RoleName
    From practica1.Usuarios u
    Join practica1.ProfileStudent ps On u.Id = ps.UserId
    Join practica1.UsuarioRole ur On u.Id = ur.UserId
    Join practica1.Roles r On ur.RoleId = r.Id
    Where u.Id = @UsuarioId
);
Go