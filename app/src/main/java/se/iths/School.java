package se.iths;

public class School {
    private long schoolId;
    private String school;

    public School(long schoolId, String school) {
        this.schoolId = schoolId;
        this.school = school;
    }

    public long getSchoolId() {
        return schoolId;
    }

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public String toString() {
        return String.format("%d %s", schoolId, school);
    }

}
