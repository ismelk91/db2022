package se.iths;

import java.util.ArrayList;
import java.util.Collection;

public class Student {
    private final long id;
    private String name;
    private final Collection<School> schools = new ArrayList<>();

    public Student(long id, String name) {
        this.id = id;
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void add(School school) {
        schools.add(school);
    }

    public String toString() {
        StringBuilder builder = new StringBuilder(String.valueOf(id));
        builder.append(": ");
        builder.append(name);
        builder.append("\nSchool:");
        for(School school : schools) {
            builder.append(" ");
            builder.append(school);
            builder.append("\n");
        }
        return builder.toString();
    }

}
