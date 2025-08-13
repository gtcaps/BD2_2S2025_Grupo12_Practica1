use BD2;
go

Create Procedure PR7_HistoryLog
    @NombreTabla NVARCHAR(50),
    @Operacion NVARCHAR(8),
    @PK_fila NVARCHAR(50)
As
Begin
    Insert Into practica1.HistoryLog ([Date], [Description])
    Values (GetDate(), @Operacion + ' en tabla '+ @NombreTabla + ' con el ID: '+ @PK_fila);
End;
GO

Create Trigger Trigger1_Usuarios
On practica1.Usuarios
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='Usuarios';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go


Create Trigger Trigger2_UsuarioRole
On practica1.UsuarioRole
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='UsuarioRole';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger3_Roles
On practica1.Roles
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='Roles';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger4_Notification
On practica1.Notification
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='Notification';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger5_TFA
On practica1.TFA
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='TFA';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger6_ProfileStudent
On practica1.ProfileStudent
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='ProfileStudent';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger7_TutorProfile
On practica1.TutorProfile
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='TutorProfile';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger8_CourseAssign
On practica1.CourseAssign
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='CourseAssign';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

Create Trigger Trigger9_CourseTutor
On practica1.CourseTutor
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)='CourseTutor';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), Id) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), Id) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

/* Cambia la llave primaria [CodCourse]*/
Create Trigger Trigger10_Course
On practica1.Course
After Insert, Update, Delete
As
Begin

    Declare @Operacion NVARCHAR(8);
    Declare @NombreTabla NVARCHAR(50)= 'Course';

    If Exists (select * from inserted) and Exists (select * from deleted)
        Set @Operacion = 'Update';
    Else If Exists (select * from inserted) 
        Set @Operacion = 'Insert';
    Else If Exists (select * from deleted)     
        Set @Operacion = 'Delete';
    

    If @Operacion = 'Insert' or @Operacion = 'Update'
    Begin
        declare cursorInsert Cursor For Select Convert(NVARCHAR(50), CodCourse) From INSERTED;
        Declare @Pk_id NVARCHAR(50);
        Open cursorInsert;
        Fetch Next From cursorInsert Into @Pk_id;
        While @@FETCH_STATUS =0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorInsert Into @Pk_id;
        End
        Close cursorInsert;
        Deallocate cursorInsert;
    End
    Else If @Operacion = 'Delete'
    Begin 
        Declare cursorDelete Cursor For Select Convert(NVARCHAR(50), CodCourse) From DELETED;
        Open cursorDelete;
        Fetch Next From cursorDelete Into @Pk_id;
        While @@FETCH_STATUS = 0
        Begin
            Exec PR7_HistoryLog @NombreTabla, @Operacion, @Pk_id;
            Fetch Next From cursorDelete Into @Pk_id;
        End
        Close cursorDelete;
        Deallocate cursorDelete;
    End
End;
Go

