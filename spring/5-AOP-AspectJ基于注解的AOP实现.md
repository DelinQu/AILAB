# 1. AspectJ 基于注解的 AOP 实现



## 环境搭建

- 主要是引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
    <!--spring依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <!--aspectj依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.1</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```



## 步骤1：定义业务接口与实现类

```java
// 接口
public interface SomeService {
    void doSome(String name,Integer age);
}

// 实现
public class SomeServiceImpl implements SomeService {
    @Override
    public void doSome(String name,Integer age) {
        //给doSome方法增加一个功能，在doSome()执行之前， 输出方法的执行时间
        System.out.println("执行了业务方法doSome-------");
    }
}
```





## 步骤2：定义切面类

类中定义了若干普通方法, 将作为不同的通知方法, 用来增强功能。

- @AspectJ：注解，表示当前是切面类
- @Before：注解，前置通知
- value：切入点表达式表示切面执行的位置
- myBefore：内部是切面的功能

```java
@Aspect
public class MyAspect {
    @Before(value = "execution(void *..SomeServiceImpl.doSome(String,Integer))")
    public void myBefore(JoinPoint jp){
        //就是你切面要执行的功能代码
   		System.out.println("前置通知 切面功能：在目标方法之前输出执行时间："+ new Date());
    }
}


// 切入点表达式练习

@Before(value = "execution(void *..SomeServiceImpl.doSome(String,Integer))")

@Before(value = "execution(* *..SomeServiceImpl.*(..))")

@Before(value = "execution(* do*(..))")

@Before(value = "execution(* com.bjpowernode.ba01.*ServiceImpl.*(..))")
```





## 步骤3：Step3:声明目标对象切面类对象

- 在配置文件中声明目标对象切面类对象

```xml
<!--声明目标对象-->
<bean id="someService" class="com.lin.p8.SomeServiceImpl" />

<!--声明切面类对象-->
<bean id="myAspect" class="com.lin.p8.MyAspect" />
```





## 步骤4：注册 AspectJ 的自动代理

在定义好切面 Aspect 后,需要通知 Spring 容器,让容器生成“目标类+ 切面”的代理对象。这个代理是由容器自动生成的。只需要在 Spring 配置文件中注册一个基于 aspectj 的自动代理生成器,其就会自动扫描到@Aspect 注解,并按通知类型与切入点,将其织入,并生成代理。

- 其工作原理是`,<aop:aspectj-autoproxy/>`通过扫描找到@Aspect 定义的切面类,再由切面类根据切入点找到目标类的目标方法,再由通知类型找到切入的时间点。

```xml
<!--声明自动代理生成器：使用aspectj框架内部的功能，创建目标对象的代理对象。创建代理对象是在内存中实现的， 修改目标对象的内存中的结构。 创建为代理对象所以目标对象就是被修改后的代理对象.
aspectj-autoproxy:会把spring容器中的所有的目标对象，一次性都生成代理对象。
-->
<aop:aspectj-autoproxy />
```



## 步骤5：测试类中使用目标对象的 id

```java
@Test
public void test01(){
    String config="applicationContext.xml";
    ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
    //从容器中获取目标对象
    SomeService proxy = (SomeService) ctx.getBean("someService");

    System.out.println("proxy:"+proxy.getClass().getName());
    //通过代理的对象执行方法，实现目标方法执行时，增强了功能
    proxy.doSome("lisi",20);
}
```

- 测试结果

![image-20210221155945867](https://i.loli.net/2021/02/21/IUgys2iMrnuEYwe.png)





# 2. 实现几种类型的AOP



## @Before 前置通知

- **方法有 JoinPoint 参数**

在目标方法执行**之前执行**。被注解为前置通知的方法,可以包含一个 JoinPoint 类型参数。该类型的对象本身就是切入点表达式。通过该参数,可获取切入点表达式、方法签名、目标对象等。不光前置通知的方法,可以包含一个 JoinPoint 类型参数,所有的通知方法均可包含该参数。

- **注意 JoinPoint**：

```java
* 指定通知方法中的参数 ： JoinPoint
* JoinPoint:业务方法，要加入切面功能的业务方法
*    作用是：可以在通知方法中获取方法执行时的信息， 例如方法名称，方法的实参。
*    如果你的切面功能中需要用到方法的信息，就加入JoinPoint.
*    这个JoinPoint参数的值是由框架赋予， 必须是第一个位置的参数
```

- **举例：**

```java
@Before(value = "execution(void *..SomeServiceImpl.doSome(String,Integer))")
public void myBefore(JoinPoint jp){
    //获取方法的完整定义
    System.out.println("方法的签名（定义）="+jp.getSignature());
    System.out.println("方法的名称="+jp.getSignature().getName());
    //获取方法的实参
    Object args [] = jp.getArgs();
    for (Object arg:args){
        System.out.println("参数="+arg);
    }
    //就是你切面要执行的功能代码
    System.out.println("前置通知， 切面功能：在目标方法之前输出执行时间："+ new Date());
}
```

- 执行结果

![image-20210221160950766](https://i.loli.net/2021/02/21/ubcEaGvZ4q29Nfl.png)



## @AfterReturning 后置通知

- **注解有 returning 属性**

在目标方法执行**之后**执行。由于是目标方法之后执行,所以可以获取到目标方法的返回值。该注解的 returning 属性就是用于指定接收方法返回值的变量名的。所以,被注解为后置通知的方法,除了可以包含 JoinPoint 参数外,还可以包含用于接收返回值的变量。该变量最好为**Object 类型,因为目标方法的返回值可能是任何类型。**

- 定义业务方法

```java
public interface SomeService {
    void doSome(String name, Integer age);
 	
    // 这里是新增的一个方法
    String doOther(String name,Integer age);
}
public class SomeServiceImpl implements SomeService {
    @Override
    public void doSome(String name,Integer age) {
        //给doSome方法增加一个功能，在doSome()执行之前， 输出方法的执行时间
        System.out.println("====目标方法doSome()====");
    }
    @Override
    public String doOther(String name, Integer age) {
        System.out.println("====目标方法doOther()====");
        return "abcd";
    }
}
```

- 定义切面:

```java
@AfterReturning(value = "execution(* *..SomeServiceImpl.doOther2(..))", returning = "res")
public void myAfterReturing2(Object res){
    // Object res:是目标方法执行后的返回值，根据返回值做你的切面的功能处理
    System.out.println("后置通知：在目标方法之后执行的，获取的返回值是："+res);
}
```

- 测试结果

![image-20210221162134016](https://i.loli.net/2021/02/21/DmzHnT1SIA5ZWCr.png)



## @Around 环绕通知

- 增强方法有 ProceedingJoinPoint

在目标方法执行**之前之后**执行。被注解为环绕增强的方法要有返回值,Object 类型。并且方法可以包含一个 ProceedingJoinPoint 类型的参数。接口 ProceedingJoinPoint 其有一个proceed()方法,用于执行目标方法。若目标方法有返回值,则该方法的返回值就是目标方法的返回值。最后,环绕增强方法将其返回值返回。该增强方法实际是拦截了目标方法的执行。

- 经常做事物：在方法之前开启方法，在完成之后提交事务

接口增加方法:

- **定义业务**

```java
public interface SomeService {
    void doSome(String name, Integer age);
    String doOther(String name, Integer age);
    String doFirst(String name,Integer age);
}
```

- **定义切面**

```java
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
```

- 执行结果

![image-20210221163610845](https://i.loli.net/2021/02/21/PNTCnBbMp2zkIqa.png)





## @AfterThrowing 异常通知

- 只用了解

- 注解中有 throwing 属性

在目标方法**抛出异常后执行**。该注解的 throwing 属性用于指定所发生的异常类对象。当然,被注解为异常通知的方法可以包含一个参数 Throwable,参数名称为 throwing 指定的名称,表示发生的异常对象。

```java
@AfterThrowing(value = "execution(* *..SomeServiceImpl.doSecond(..))", throwing = "ex")
public void myAfterThrowing(Exception ex) {
    System.out.println("异常通知：方法发生异常时，执行："+ex.getMessage());
    //发送邮件，短信，通知开发人员
}
```



## @After 最终通知

- 只用了解

- 无论目标方法是否抛出异常,该增强均会被执行。

- 常用于资源清除

```java
@After(value = "execution(* *..SomeServiceImpl.doThird(..))")
public  void  myAfter(){
    System.out.println("执行最终通知，总是会被执行的代码");
    //一般做资源清除工作的。
}
```



## @Pointcut 定义切入点

- 当较多的通知增强方法使用相同的 execution 切入点表达式时,编写、维护均较为麻烦。AspectJ 提供了@Pointcut 注解,**用于定义 execution 切入点表达式。**

- 其用法是,**将@Pointcut 注解在一个方法之上,以后所有的 execution 的 value 属性值均可使用该方法名作为切入点**。代表的就是@Pointcut 定义的切入点。这个使用@Pointcut 注解的方法一般使用 private 的标识方法,即没有实际作用的方法。

```java
@After(value = "mypt()")
public  void  myAfter(){
    System.out.println("执行最终通知，总是会被执行的代码");
    //一般做资源清除工作的。
 }

@Before(value = "mypt()")
public  void  myBefore(){
    System.out.println("前置通知，在目标方法之前先执行的");
}

/**
 * @Pointcut: 定义和管理切入点， 如果你的项目中有多个切入点表达式是重复的，可以复用的。
 *            可以使用@Pointcut
 *    属性：value 切入点表达式
 *    位置：在自定义的方法上面
 * 特点：
 *   当使用@Pointcut定义在一个方法的上面 ，此时这个方法的名称就是切入点表达式的别名。
 *   其它的通知中，value属性就可以使用这个方法名称，代替切入点表达式了
 */
@Pointcut(value = "execution(* *..SomeServiceImpl.doThird(..))" )
private void mypt(){
    //无需代码，
}
```







