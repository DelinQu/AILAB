package com.lin.p2;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;

/**
 *  @Aspect : 是aspectj框架中的注解。
 *     作用：表示当前类是切面类。
 *     切面类：是用来给业务方法增加功能的类，在这个类中有切面的功能代码
 *     位置：在类定义的上面
 */
@Aspect
public class MyAspect {
    @AfterReturning(value = "execution(* *..SomeServiceImpl.doOther(..))", returning = "res")
    public void myAfterReturing(  JoinPoint jp  ,Object res ){
        // Object res:是目标方法执行后的返回值，根据返回值做你的切面的功能处理
        System.out.println("后置通知：方法的定义"+ jp.getSignature());
        System.out.println("后置通知：在目标方法之后执行的，获取的返回值是："+res);
        if(res.equals("abcd")){
            //做一些功能
        } else{
            //做其它功能
        }
        //修改目标方法的返回值， 看一下是否会影响 最后的方法调用结果
        if( res != null){
            res = "Hello Aspectj";
        }

    }

    @AfterReturning(value = "execution(* *..SomeServiceImpl.doOther2(..))", returning = "res")
    public void myAfterReturing2(Object res){
        // Object res:是目标方法执行后的返回值，根据返回值做你的切面的功能处理
        System.out.println("后置通知：在目标方法之后执行的，获取的返回值是："+res);
    }

}
