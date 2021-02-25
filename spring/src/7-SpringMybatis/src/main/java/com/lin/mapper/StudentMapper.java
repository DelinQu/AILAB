package com.lin.mapper;

import com.lin.entity.Student;

import java.util.List;

public interface StudentMapper {

    int insertStudent(Student student);

    int updateStudent(Student student);

    int deleteStudent(Student student);

    Student selectById(int id);

    List<Student> selectStudents();
}
