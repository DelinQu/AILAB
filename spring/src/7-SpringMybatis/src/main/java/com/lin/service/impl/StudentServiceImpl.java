package com.lin.service.impl;

import com.lin.mapper.StudentMapper;
import com.lin.entity.Student;
import com.lin.service.StudentService;

import java.util.List;

public class StudentServiceImpl implements StudentService{

    private StudentMapper studentMapper;

    public void setStudentMapper(StudentMapper studentMapper) {
        this.studentMapper = studentMapper;
    }

    @Override
    public int insertStudent(Student student) {
        return studentMapper.insertStudent(student);
    }

    @Override
    public int updateStudent(Student student) {
        return studentMapper.updateStudent(student);
    }

    @Override
    public int deleteStudent(Student student) {
        return studentMapper.deleteStudent(student);
    }

    @Override
    public Student selectById(int id) {
        return studentMapper.selectById(id);
    }

    @Override
    public List<Student> selectStudents() {
        return studentMapper.selectStudents();
    }
}
