package com.lin;

import com.lin.p1.Student;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.Date;

public class MyTest {



   @Test
    public void test01(){
       String config= "p1/applicationContext.xml";
       ApplicationContext ac = new ClassPathXmlApplicationContext(config);

       //从容器中获取Student对象
       Student myStudent =  (Student) ac.getBean("myStudent");
       System.out.println("student对象="+myStudent);

       Date myDate = (Date) ac.getBean("mydate");
       System.out.println("myDate="+myDate);

   }

   @Test
    public void test02(){
       System.out.println("===test02===");
   }


}
