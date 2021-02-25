package com.lin;

import com.lin.p6.Student;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;


public class MyTest06 {



   @Test
    public void test01(){
      //加载的是总的文件
       String config= "p6/total.xml";
       ApplicationContext ac = new ClassPathXmlApplicationContext(config);

       //从容器中获取Student对象
       Student myStudent =  (Student) ac.getBean("myStudent");
       System.out.println("student对象="+myStudent);


   }


}
