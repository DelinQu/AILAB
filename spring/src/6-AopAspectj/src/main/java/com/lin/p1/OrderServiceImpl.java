package com.lin.p1;

//目标类
public class OrderServiceImpl implements SomeService {
    @Override
    public void doSome(String name,Integer age) {
        //给doSome方法增加一个功能，在doSome()执行之前， 输出方法的执行时间
        System.out.println("====目标方法doSome()====");
    }

    public void doOther(String name,Integer age) {
        //给doSome方法增加一个功能，在doSome()执行之前， 输出方法的执行时间
        System.out.println("====目标方法doSome()====");
    }
}
