package com.lin;

import com.lin.entity.SysUser;
import com.lin.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MyApp {
    public static void main(String[] args) {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserService service = (UserService) ctx.getBean("userService");

        SysUser user  = new SysUser();
        user.setName("LinXiaoDe");
        user.setAge(20);
        service.addUser(user);
    }
}
