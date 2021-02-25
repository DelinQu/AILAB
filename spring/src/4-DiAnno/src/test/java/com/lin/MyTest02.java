package com.lin;

import com.lin.p2.Student;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MyTest02 {

    @Test
    public void test01(){
        String config="applicationContext.xml";
        ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
        //从容器中获取对象
        Student student = (Student) ctx.getBean("myStudent");

        System.out.println("student="+student);
    }
}
