package com.lin.p5;

import com.lin.p2.Student;

public interface SomeService {
    void doSome(String name, Integer age);
    String doOther(String name, Integer age);

    Student doOther2(String name, Integer age);

    String doFirst(String name, Integer age);

    void doSecond();

    void doThird();
}
