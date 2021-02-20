package com.lin.p5;

public class Student {

    private String name;
    private int age;

    //声明一个引用类型
    private School school;
    private School school2;


    public Student() {
        //System.out.println("spring会调用类的无参数构造方法创建对象");
    }

    public void setName(String name) {
        //System.out.println("setName:"+name);
        this.name = name;
    }

    public void setAge(int age) {
        //System.out.println("setAge:"+age);
        this.age = age;
    }

    public void setSchool(School school) {
        System.out.println("setSchool:"+school);
        this.school = school;
    }

    public void setSchool2(School school2) {
        System.out.println("setSchool2222222:"+school);
        this.school2 = school2;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", school=" + school +
                ", school2=" + school2 +
                '}';
    }
}
