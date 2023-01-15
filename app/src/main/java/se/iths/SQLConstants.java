package se.iths;

public class SQLConstants {
    public static final String JDBC_CONNECTION = "jdbc:mysql://localhost/iths";
    public static final String JDBC_USER = "iths";
    public static final String JDBC_PASSWORD = "iths";
    public static final String SQL_STUDENTS_BY_SCHOOL = "SELECT StudentId, Name, School FROM Student JOIN StudentSchool USING(StudentId) JOIN School USING(SchoolId)";
    public static final String SQL_STUDENT_ID = "StudentId";
    public static final String SQL_STUDENT_NAME = "Name";
    public static final String SQL_SELECT_STUDENT_SCHOOL = "SELECT StudentId, Name, SchoolId, School FROM Student JOIN StudentSchool USING (StudentId) JOIN School USING (SchoolId) WHERE StudentId = ?;";
    public static final String SQL_SCHOOL_ID = "SchoolId";
    public static final String SQL_SCHOOL_NAME = "School";
}