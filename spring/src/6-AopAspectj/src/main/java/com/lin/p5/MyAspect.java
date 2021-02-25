package com.lin.p5;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;

/**
 *  @Aspect : 是aspectj框架中的注解。
 *     作用：表示当前类是切面类。
 *     切面类：是用来给业务方法增加功能的类，在这个类中有切面的功能代码
 *     位置：在类定义的上面
 */
@Aspect
public class MyAspect {
    /**
     * 最终通知方法的定义格式
     *  1.public
     *  2.没有返回值
     *  3.方法名称自定义
     *  4.方法没有参数，  如果还有是JoinPoint,
     */

    /**
     * @After :最终通知
     *    属性： value 切入点表达式
     *    位置： 在方法的上面
     * 特点：
     *  1.总是会执行
     *  2.在目标方法之后执行的
     *
     *  try{
     *      SomeServiceImpl.doThird(..)
     *  }catch(Exception e){
     *
     *  }finally{
     *      myAfter()
     *  }
     *
     */
    @After(value = "execution(* *..SomeServiceImpl.doThird(..))")
    public  void  myAfter(){
        System.out.println("执行最终通知，总是会被执行的代码");
        //一般做资源清除工作的。
     }

}
