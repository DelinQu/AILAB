package com.lin.p2;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


@Component("myStudent")
public class Student {

    /**
     * @Value: 简单类型的属性赋值
     *   属性： value 是String类型的，表示简单类型的属性值
     *   位置： 1.在属性定义的上面，无需set方法，推荐使用。
     *         2.在set方法的上面
     */
    //@Value("李四" )
    @Value("${myname}") //使用属性配置文件中的数据
    private String name;

    @Value("${myage}")  //使用属性配置文件中的数据
    private Integer age;

    public Student() {
        System.out.println("==student无参数构造方法===");
    }

    public void setName(String name) {
        this.name = name;
    }
    //@Value("30")
    public void setAge(Integer age) {
        System.out.println("setAge:"+age);
        this.age = age;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
