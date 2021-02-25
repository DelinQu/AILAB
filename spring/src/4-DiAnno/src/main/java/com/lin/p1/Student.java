package com.lin.p1;

import org.springframework.stereotype.Component;


//省略value
@Component(value ="myStudent")
//如果不指定对象名称，由spring提供默认名称: 类名的首字母小写
//@Component
public class Student {

    private String name;
    private Integer age;

    public Student() {
        System.out.println("==student无参数构造方法===");
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(Integer age) {
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
