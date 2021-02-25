package com.lin;

import com.lin.mapper.StudentMapper;
import com.lin.entity.Student;
import com.lin.service.StudentService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

public class MyTest {

    @Test
    public void testDaoInsert(){
        String config="spring.xml";
        ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
        //获取spring容器中的dao对象
        StudentMapper dao  = (StudentMapper) ctx.getBean("studentMapper");
        Student student  = new Student();
        student.setId(10014);
        student.setName("qdl");
        student.setEmail("qdl.cs@qq.com");
        student.setAge(20);
        int nums = dao.insertStudent(student);
        System.out.println("nums="+nums);
    }
}
