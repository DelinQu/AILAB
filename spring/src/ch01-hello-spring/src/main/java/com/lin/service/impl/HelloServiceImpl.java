package com.lin.service.impl;

import com.lin.service.HelloService;

public class HelloServiceImpl implements HelloService {

    public HelloServiceImpl() {
        System.out.println("HelloServiceImpl的无参数构造方法");
    }

    @Override
    public void Hello() {
        System.out.println("执行了HelloServiceImpl的doSome()方法");
    }
}
