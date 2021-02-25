package com.lin.service.impl;

import com.lin.mapper.StudentMapper;
import com.lin.entity.Student;
import com.lin.service.StudentService;

import java.util.List;

public class StudentServiceImpl implements StudentService {

    //引用类型
    private StudentMapper studentDao;

    //使用set注入，赋值
    public void setStudentDao(StudentMapper studentDao) {
        this.studentDao = studentDao;
    }

    @Override
    public int addStudent(Student student) {
        int nums = studentDao.insertStudent(student);
        return nums;
    }

    @Override
    public List<Student> queryStudents() {
        List<Student> students = studentDao.selectStudents();
        return students;
    }
}
