package se.iths;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;

import static se.iths.SQLConstants.*;


public class App {

    public static void main(String[] args) {
        App app = new App();

        try{
            app.load();
        } catch (SQLException e) {
            System.err.println(String.format("Något gick fel vid inläsning av databasen! (%s)", e.toString()));
        }

    }

    private void load() throws SQLException {
        Collection<Student> students = loadStudents();
        for (Student student : students) {
            System.out.println(student);
        }
    }

    private Collection<Student> loadStudents() throws SQLException {
        Collection<Student> students = new ArrayList<>();
        Connection con = DriverManager.getConnection(JDBC_CONNECTION, JDBC_USER, JDBC_PASSWORD);
        ResultSet rs = con.createStatement().executeQuery(SQL_STUDENTS_BY_SCHOOL);

        while (rs.next()) {
            long id = rs.getLong(SQL_STUDENT_ID);
            String name = rs.getString(SQL_STUDENT_NAME);
            Student student = new Student(id, name);
            students.add(student);
            Collection<School> schools = loadSchool(student.getId());
            for(School school : schools) {
               student.add(school);
            }

        }
        rs.close();
        con.close();
        return students;
    }

    private Collection<School> loadSchool(long studentId) throws SQLException {
        Collection<School> schools = new ArrayList<>();
        Connection con = DriverManager.getConnection(JDBC_CONNECTION,JDBC_USER,JDBC_PASSWORD);

        PreparedStatement stmt = con.prepareStatement(SQL_SELECT_STUDENT_SCHOOL);
        stmt.setLong(1,studentId);

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            long schoolId = rs.getLong(SQL_SCHOOL_ID);
            String schoolName = rs.getString(SQL_SCHOOL_NAME);
            School school = new School(schoolId,schoolName);
            schools.add(school);
        }
        stmt.close();
        rs.close();
        return schools;
    }


}
