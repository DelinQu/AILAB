package com.lin;

import com.lin.p2.School;
import com.lin.p2.Student;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MyTest02 {



   @Test
    public void test01(){
       String config= "p2/applicationContext.xml";
       ApplicationContext ac = new ClassPathXmlApplicationContext(config);

       //从容器中获取Student对象
       Student myStudent =  (Student) ac.getBean("myStudent");
       System.out.println("student对象="+myStudent);
   }

   @Test
    public void test02(){
       System.out.println("===test02===");

       Student student = new Student();
       student.setName("lisi");
       student.setAge(20);

      School school = new School();
      school.setName("动力节点");
      school.setAddress("北京");

      student.setSchool(school);
      // setSchool(mySchool)

      System.out.println("student==="+student);

   }


}
