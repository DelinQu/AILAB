package com.lin.p3;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;

import java.util.Date;

@Aspect
public class MyAspect {
    @Around(value = "execution(* *..SomeServiceImpl.doFirst(..))")
    public Object myAround(ProceedingJoinPoint pjp) throws Throwable {

        String name = "";
        //获取第一个参数值
        Object args [] = pjp.getArgs();
        if( args!= null && args.length > 1){
              Object arg=  args[0];
              name =(String)arg;
        }

        //实现环绕通知
        Object result = null;
        System.out.println("环绕通知：在目标方法之前，输出时间："+ new Date());
        //1.目标方法调用
        if( "zhangsan".equals(name)){
            //符合条件，调用目标方法
            result = pjp.proceed(); //method.invoke(); Object result = doFirst();
        }

        System.out.println("环绕通知：在目标方法之后，提交事务");
        //2.在目标方法的前或者后加入功能

        //修改目标方法的执行结果， 影响方法最后的调用结果
        if( result != null){
              result = "Hello AspectJ AOP";
        }

        //返回目标方法的执行结果
        return result;
    }
}
