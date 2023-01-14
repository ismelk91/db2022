USE iths;

/* UNF */

DROP TABLE IF EXISTS UNF;

CREATE TABLE `UNF` (
    `Id` DECIMAL(38, 0) NOT NULL,
    `Name` VARCHAR(26) NOT NULL,
    `Grade` VARCHAR(11) NOT NULL,
    `Hobbies` VARCHAR(25),
    `City` VARCHAR(10) NOT NULL,
    `School` VARCHAR(30) NOT NULL,
    `HomePhone` VARCHAR(15),
    `JobPhone` VARCHAR(15),
    `MobilePhone1` VARCHAR(15),
    `MobilePhone2` VARCHAR(15)
)  ENGINE=INNODB;

LOAD DATA INFILE '/var/lib/mysql-files/denormalized-data.csv'
INTO TABLE UNF
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


/* Student */

DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
	StudentId INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(255) NOT NULL,
	CONSTRAINT PRIMARY KEY (StudentId)
	) ENGINE=INNODB;

INSERT INTO Student(StudentId, Name) SELECT DISTINCT Id, Name FROM UNF;

/* School */

DROP TABLE IF EXISTS School;

CREATE TABLE School (
	SchoolId INT NOT NULL AUTO_INCREMENT,
	School VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	CONSTRAINT PRIMARY KEY(SchoolId)
)ENGINE=INNODB;

INSERT INTO School(School, City) SELECT DISTINCT School, City FROM UNF;


/* StudentSchool */

DROP TABLE IF EXISTS StudentSchool;

CREATE TABLE StudentSchool AS SELECT DISTINCT UNF.Id AS StudentId, School.SchoolId FROM UNF
JOIN School USING(School);

ALTER TABLE StudentSchool MODIFY COLUMN StudentId INT;
ALTER TABLE StudentSchool MODIFY COLUMN SchoolId INT;
ALTER TABLE StudentSchool ADD PRIMARY KEY(StudentId, SchoolId);


/* Phone */

DROP TABLE IF EXISTS Phone;

CREATE TABLE Phone (
	PhoneId INT NOT NULL AUTO_INCREMENT,
	StudentId INT NOT NULL,
	Type VARCHAR(32) NOT NULL,
	Number VARCHAR(32) NOT NULL,
	CONSTRAINT PRIMARY KEY (PhoneId)
	);

INSERT INTO Phone (StudentId, Type, Number)
SELECT Id AS StudentId, "Home" AS Type, HomePhone AS Number FROM UNF
WHERE HomePhone IS NOT NULL AND HomePhone != ''
UNION SELECT Id AS StudentId, "Job" AS Type, JobPhone AS Number FROM UNF
WHERE JobPhone IS NOT NULL AND JobPhone != ''
UNION SELECT Id AS StudentId, "Mobile" AS Type, MobilePhone1 AS Number FROM UNF
WHERE MobilePhone1 IS NOT NULL AND MobilePhone1 != ''
UNION SELECT Id AS StudentId, "Mobile" AS Type, MobilePhone2 AS Number FROM UNF
WHERE MobilePhone2 IS NOT NULL AND MobilePhone2 != '';


/* PhoneList */

DROP VIEW IF EXISTS PhoneList;

CREATE VIEW PhoneList AS SELECT StudentId, group_concat(Number) AS Numbers FROM Phone GROUP BY StudentId;


/* HobbiesTemp */

DROP VIEW IF EXISTS HobbiesTemp;

CREATE VIEW HobbiesTemp AS SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(Hobbies, ',', 1)) AS Hobby FROM UNF
WHERE Hobbies IS NOT NULL AND Hobbies != '' AND HOBBIES != 'Nothing'
UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Hobbies, ',', -2), ',', 1)) AS Hobby FROM UNF
WHERE Hobbies IS NOT NULL AND Hobbies != '' AND Hobbies != 'Nothing'
UNION SELECT Id AS StudentId, TRIM(SUBSTRING_INDEX(Hobbies, ',', -1)) AS Hobby FROM UNF
WHERE Hobbies IS NOT NULL AND Hobbies != '' AND Hobbies != 'Nothing';


/* Hobby */

DROP TABLE IF EXISTS Hobby;

CREATE TABLE Hobby(
	HobbyId INT NOT NULL AUTO_INCREMENT,
	Hobby VARCHAR(150) NOT NULL,
	CONSTRAINT PRIMARY KEY(HobbyId)
	)ENGINE=INNODB;

INSERT INTO Hobby(Hobby) SELECT DISTINCT Hobby FROM HobbiesTemp;


/* StudentHobby */

DROP TABLE IF EXISTS StudentHobby;

CREATE TABLE StudentHobby AS SELECT StudentId, HobbyId FROM HobbiesTemp
JOIN Hobby USING(Hobby);

ALTER TABLE StudentHobby ADD PRIMARY KEY (StudentId, HobbyId);


/* HobbiesList */

DROP VIEW IF EXISTS HobbiesList;

CREATE VIEW HobbiesList AS SELECT StudentId, Name, GROUP_CONCAT(Hobby) AS Hobbies FROM Student
JOIN StudentHobby USING(StudentId)
JOIN Hobby USING(HobbyId) GROUP BY StudentId;


/* Grade */

DROP TABLE IF EXISTS Grade;

CREATE TABLE Grade (
    GradeId INT NOT NULL AUTO_INCREMENT,
    Grade VARCHAR(150) NOT NULL,
    CONSTRAINT PRIMARY KEY (GradeId)
)  ENGINE=INNODB;

INSERT INTO Grade(Grade) SELECT DISTINCT Grade FROM UNF;

ALTER TABLE Student ADD COLUMN GradeId INT NOT NULL;

UPDATE Student JOIN UNF ON (StudentId = Id) JOIN Grade ON Grade.Grade = UNF.Grade
SET  Student.GradeId =  Grade.GradeId;


/* UNF UPDATED */

DROP VIEW IF EXISTS AVSLUT;

CREATE VIEW AVSLUT AS
SELECT StudentId as ID, Student.Name, Grade, Hobbies, School, City, Numbers FROM StudentSchool
LEFT JOIN Student USING (StudentId)
LEFT JOIN Grade USING (GradeId)
LEFT JOIN HobbiesList USING (StudentId)
LEFT JOIN School USING (SchoolId)
LEFT JOIN PhoneList USING (StudentId);
