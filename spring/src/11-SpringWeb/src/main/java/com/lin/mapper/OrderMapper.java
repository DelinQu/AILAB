package com.lin.mapper;

import com.lin.entity.Student;

import java.util.List;

public interface OrderMapper {

    int insertStudent(Student student);
    List<Student> selectStudents();

}
