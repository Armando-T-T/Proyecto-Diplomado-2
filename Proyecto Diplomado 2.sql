CREATE DATABASE Proyecto

USE Proyecto

-- Creación de la tabla Maestro
CREATE TABLE Maestro (
    MaestroID INT PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL,
    ApellidoPaterno VARCHAR(20) NOT NULL,
    ApellidoMaterno VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- Creación de la tabla Salon
CREATE TABLE Salon (
    SalonID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Edificio VARCHAR(50),
    Capacidad INT CHECK (Capacidad > 0)
);

-- Creación de la tabla Materia
CREATE TABLE Materia (
    MateriaID INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    MaestroID INT,
    SalonID INT,
    FOREIGN KEY (MaestroID) REFERENCES Maestro(MaestroID),
    FOREIGN KEY (SalonID) REFERENCES Salon(SalonID)
);

-- Creación de la tabla Alumnos
CREATE TABLE Alumnos (
    AlumnoID INT PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL,
    ApellidoPaterno VARCHAR(20) NOT NULL,
    ApellidoMaterno VARCHAR(20) NOT NULL,
    Edad INT CHECK (Edad > 0),
    SalonID INT,
    FOREIGN KEY (SalonID) REFERENCES Salon(SalonID)
);

-- Creamos una tabla temporal para Maestro
CREATE TABLE #TempMaestro (
    MaestroID INT PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL,
    ApellidoPaterno VARCHAR(20) NOT NULL,
    ApellidoMaterno VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- Insertamos datos en la tabla temporal para Maestro
INSERT INTO #TempMaestro (MaestroID, Nombre, ApellidoPaterno, ApellidoMaterno, Email) 
VALUES 
(1, 'Juan', 'García', 'López', 'juan.garcia@gmail.com'),
(2, 'María', 'Martínez', 'Hernández', 'maria.martinez@gmail.com'),
(3, 'Pedro', 'Rodríguez', 'González', 'pedro.rodriguez@outlook.com'),
(4, 'Laura', 'Díaz', 'Pérez', 'laura.diaz@outlook.com'),
(5, 'Carlos', 'Sánchez', 'López', 'carlos.sanchez@hotmail.com');

-- Realizamos la inserción en la tabla Maestro desde la tabla temporal
INSERT INTO Maestro (MaestroID, Nombre, ApellidoPaterno, ApellidoMaterno, Email)
SELECT MaestroID, Nombre, ApellidoPaterno, ApellidoMaterno, Email
FROM #TempMaestro;

-- Inserts para Salon
INSERT INTO Salon (SalonID, Nombre, Edificio, Capacidad) 
VALUES 
(1, 'A101', 'Edificio A', 30),
(2, 'B203', 'Edificio B', 25),
(3, 'C305', 'Edificio C', 35),
(4, 'D102', 'Edificio D', 40),
(5, 'E201', 'Edificio E', 20);

-- Inserts para Materia
INSERT INTO Materia (MateriaID, Nombre, MaestroID, SalonID) 
VALUES 
(1, 'Matemáticas', 1, 1),
(2, 'Historia', 2, 2),
(3, 'Ciencias', 3, 3),
(4, 'Literatura', 4, 4),
(5, 'Inglés', 5, 5);

-- Inserts para Alumnos
INSERT INTO Alumnos (AlumnoID, Nombre, ApellidoPaterno, ApellidoMaterno, Edad, SalonID) 
VALUES 
(1, 'Ana', 'Gómez', 'Martínez', 18, 1),
(2, 'David', 'Pérez', 'García', 17, 2),
(3, 'Sofía', 'Hernández', 'López', 16, 3),
(4, 'Javier', 'Díaz', 'Rodríguez', 18, 4),
(5, 'Elena', 'González', 'Sánchez', 17, 5);

--Crear un procedure para hacer un Back UP
CREATE PROCEDURE SP_Back
AS
BEGIN
    DECLARE @fecha CHAR(12)
    DECLARE @path VARCHAR(100)
    DECLARE @name VARCHAR(20)

    SET @fecha = CONVERT(CHAR(8), GETDATE(), 112) + REPLACE(CONVERT(CHAR(5), GETDATE(), 108), ':', '')
    SET @path = 'C:\Archivos SQL\Proyecto' + @fecha + '.bak'
    SET @name = 'Proyecto' + @fecha

    BACKUP DATABASE Proyecto
    TO DISK = @path
    WITH NO_COMPRESSION, NAME = @name
END

EXEC SP_Back;

-- Vista que muestra información sobre las materias, los alumnos y los maestros
CREATE VIEW MostrarMateriasAlumnos AS
SELECT 
    CONCAT(Alumnos.Nombre, ' ', Alumnos.ApellidoPaterno, ' ', Alumnos.ApellidoMaterno) AS NombreCompletoAlumno,
    Alumnos.Edad AS EdadAlumno,
    Materia.Nombre AS Materia,
    Salon.Nombre AS Salon,
    CONCAT(Maestro.Nombre, ' ', Maestro.ApellidoPaterno, ' ', Maestro.ApellidoMaterno) AS NombreCompletoMaestro
FROM 
    Alumnos
    INNER JOIN Materia ON Alumnos.SalonID = Materia.SalonID
    INNER JOIN Salon ON Materia.SalonID = Salon.SalonID
    INNER JOIN Maestro ON Materia.MaestroID = Maestro.MaestroID;

SELECT * FROM MostrarMateriasAlumnos;


--Consulta con LEFT JOIN
SELECT 
    Alumnos.Nombre AS NombreAlumno,
    Alumnos.ApellidoPaterno AS ApellidoPaternoAlumno,
    Alumnos.ApellidoMaterno AS ApellidoMaternoAlumno,
    Materia.Nombre AS Materia,
    Salon.Nombre AS Salon,
    CONCAT(Maestro.Nombre, ' ', Maestro.ApellidoPaterno, ' ', Maestro.ApellidoMaterno) AS NombreCompletoMaestro
FROM 
    Alumnos
LEFT JOIN 
    Materia ON Alumnos.SalonID = Materia.SalonID
LEFT JOIN 
    Salon ON Materia.SalonID = Salon.SalonID
LEFT JOIN 
    Maestro ON Materia.MaestroID = Maestro.MaestroID;


--Consulta con RIGHT JOIN
SELECT 
    Alumnos.Nombre AS NombreAlumno,
    Alumnos.ApellidoPaterno AS ApellidoPaternoAlumno,
    Alumnos.ApellidoMaterno AS ApellidoMaternoAlumno,
    Materia.Nombre AS Materia,
    Salon.Nombre AS Salon,
    CONCAT(Maestro.Nombre, ' ', Maestro.ApellidoPaterno, ' ', Maestro.ApellidoMaterno) AS NombreCompletoMaestro
FROM 
    Materia
RIGHT JOIN 
    Alumnos ON Alumnos.SalonID = Materia.SalonID
RIGHT JOIN 
    Salon ON Materia.SalonID = Salon.SalonID
RIGHT JOIN 
    Maestro ON Materia.MaestroID = Maestro.MaestroID;

--Crear tabla para registrar los triggers 
CREATE TABLE HistorialAlumnos (
    HistorialID INT PRIMARY KEY IDENTITY(1,1),
    AlumnoID INT,
    Nombre VARCHAR(100),
    Accion VARCHAR(10), -- Puede ser 'CREATE', 'UPDATE' o 'DELETE'
    FechaHora DATETIME
);

--Triggers para cuando se actualiza algun alumno
CREATE TRIGGER trg_update_alumnos
ON Alumnos
AFTER UPDATE
AS
BEGIN
    DECLARE @AlumnoID INT, @Nombre VARCHAR(100);

    SELECT @AlumnoID = AlumnoID, @Nombre = CONCAT(Nombre, ' ', ApellidoPaterno, ' ', ApellidoMaterno) FROM INSERTED;

    INSERT INTO HistorialAlumnos (AlumnoID, Nombre, Accion, FechaHora)
    VALUES (@AlumnoID, @Nombre, 'UPDATE', GETDATE());
END;

--Triggers para cuando se elimine algun alumno
CREATE TRIGGER trg_delete_alumnos
ON Alumnos
AFTER DELETE
AS
BEGIN
    DECLARE @AlumnoID INT, @Nombre VARCHAR(100);

    SELECT @AlumnoID = AlumnoID, @Nombre = CONCAT(Nombre, ' ', ApellidoPaterno, ' ', ApellidoMaterno) FROM DELETED;

    INSERT INTO HistorialAlumnos (AlumnoID, Nombre, Accion, FechaHora)
    VALUES (@AlumnoID, @Nombre, 'DELETE', GETDATE());
END;

--Triggers para cuando se inserte algun alumno
CREATE TRIGGER trg_insert_alumnos
ON Alumnos
AFTER INSERT
AS
BEGIN
    DECLARE @AlumnoID INT, @Nombre VARCHAR(100);

    SELECT @AlumnoID = AlumnoID, @Nombre = CONCAT(Nombre, ' ', ApellidoPaterno, ' ', ApellidoMaterno) FROM INSERTED;

    INSERT INTO HistorialAlumnos (AlumnoID, Nombre, Accion, FechaHora)
    VALUES (@AlumnoID, @Nombre, 'INSERT', GETDATE());
END;
