# 一. IOC 控制反转

## 思想

控制反转(IoC,Inversion of Control) ,是一个概念,是一种思想。指将传统上由程序代码直接操控的对象调用权交给容器,通过容器来实现对象的装配和管理。**控制反转就是对对象控制权的转移，从程序代码本身反转到了外部容器**。通过容器实现对象的创建,属性赋值,依赖的管理。

- **实现：**

  依赖注入:DI(Dependency Injection),程序代码不做定位查询,这些工作由容器自行完成。依赖注入 DI 是指程序运行过程中,若需要调用另一个对象协助时,无须在代码中创建被调用者,而是依赖于外部容器,由外部容器创建后传递给程序。Spring 的依赖注入对调用者与被调用者几乎没有任何要求,完全支持对象之间依赖关系的管理。

- **Spring 框架使用依赖注入(DI)实现 IoC。**
  Spring 容器是一个超级大工厂,负责创建、管理所有的 Java 对象,这些 Java 对象被称为 Bean。Spring 容器管理着容器中 Bean 之间的依赖关系,Spring 使用“依赖注入”的方式来管理 Bean 之间的依赖关系。使用 IoC 实现对象之间的解耦和。



## 实例 1

- 创建maven项目：注意选择`org.apach.maven.archtypes`
- 加入maven的依赖
  - spring的依赖，版本5.2.5版本
  - junit依赖
- 创建类（接口和他的实现类）
  和没有使用框架一样， 就是普通的类。
- 创建spring需要使用的配置文件：声明类的信息，这些类由spring创建和管理
- 测试spring

<img src="https://i.loli.net/2021/02/20/SlvLFscnNiATj6a.png" alt="image-20210220170741159" style="zoom: 33%;" />



### 对比使用容器和不用容器

#### 不用容器

```java
@Test
public void test01(){
    HelloService service  = new HelloServiceImpl();
    service.Hello();
}
```

#### 使用容器

- **新建spring的配置文件**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="someService" class="com.lin.service.impl.HelloServiceImpl" />
    <bean id="someService1" class="com.lin.service.impl.HelloServiceImpl" scope="prototype"/>
    <bean id="mydate" class="java.util.Date" />

</beans>
```

- **声明bean,告诉spring要创建的对象**

```xml
<bean id="helloService" class="com.lin.service.impl.HelloServiceImpl" />
<bean id="helloService1" class="com.lin.service.impl.HelloServiceImpl" scope="prototype"/>

声明bean ， 就是告诉spring要创建某个类的对象
	id:对象的自定义名称，唯一值。 spring通过这个名称找到对象
	class:类的全限定名称（不能是接口，因为spring是反射机制创建对象，必须使用类）
一个bean标签声明一个对象。
```

- **测试：使用spring容器创建的对象**

```java
@Test
public void test02(){
    //1.指定spring配置文件的名称
    String config="beans.xml";
    //2.创建表示spring容器的对象， ApplicationContext
    // ApplicationContext就是表示Spring容器，通过容器获取对象了
    // ClassPathXmlApplicationContext:表示从类路径中加载spring的配置文件
    ApplicationContext ac = new ClassPathXmlApplicationContext(config);

    //从容器中获取某个对象， 你要调用对象的方法
    //getBean("配置文件中的bean的id值")
    HelloService service = (HelloService) ac.getBean("helloService");

    //使用spring创建好的对象
    service.Hello();
}
```



## ApplicationContext 容器中对象的装配时机

- ApplicationContext 容器,会在容器对象初始化时,将其中的所有对象一次性全部装配好。以后代码中若要使用到这些对象,只需从内存中直接获取即可。执行效率较高。但占用内存。

![image-20210220202909888](https://i.loli.net/2021/02/20/YVzvxClEJsFjb2A.png)



# 一. 注入分类

bean 实例在调用无参构造器创建对象后,就要对 bean 对象的属性进行初始化。初始化是由容器自动完成的,称为注入。
根据注入方式的不同,常用的有两类:

- set 注入
- 构造注入



## 1.set 注入(掌握)

set 注入也叫设值注入是指,通过 setter 方法传入被调用者的实例。这种注入方式简单、直观,因而在 Spring 的依赖注入中大量使用。

### （1）简单类型

- 添加setter方法

```java
public void setName(String name) {
    System.out.println("setName:"+name);
    this.name = name.toUpperCase();
}
public void setAge(int age) {
    System.out.println("setAge:"+age);
    this.age = age;
}
```

- 在配置文件中声明对象注入

```xml
<bean id="myStudent" class="com.lin.p1.Student" >
    <property name="name" value="李四lisi" /><!--setName("李四")-->
    <property name="age" value="22" /><!--setAge(21)-->
    <property name="email" value="lisi@qq.com" /><!--setEmail("lisi@qq.com")-->
</bean>
<bean id="mydate" class="java.util.Date">
    <property name="time" value="8364297429" /><!--setTime(8364297429)-->
</bean>
```

- 在测试类中从容器中加载对象

```java
@Test
public void test01(){
    String config= "p1/applicationContext.xml";
    ApplicationContext ac = new ClassPathXmlApplicationContext(config);

    //从容器中获取Student对象
    Student myStudent =  (Student) ac.getBean("myStudent");
    System.out.println("student对象="+myStudent);

    Date myDate = (Date) ac.getBean("mydate");
    System.out.println("myDate="+myDate);
}
```



### （2） 引用类型

当指定 bean 的某属性值为另一 bean 的实例时,通过 ref 指定它们间的引用关系。ref的值必须为某 bean 的 id 值。

```java
public class Student {
    private String name;
    private int age;
    //声明一个引用类型
    private School school;
}
```

- 配置文件中注入
  - 首先声明school对象，然后在其他bean中使用ref引入

```xml
<bean id="myStudent" class="com.lin.p2.Student" >
    <property name="name" value="李四" />
    <property name="age" value="26" />
    <!--引用类型-->
    <property name="school" ref="mySchool" /><!--setSchool(mySchool)-->
</bean>
<!--声明School对象-->
<bean id="mySchool" class="com.lin.p2.School">
    <property name="name" value="北京大学"/>
    <property name="address" value="北京的海淀区" />
</bean>
```



## 2.构造注入(理解)

**构造注入是指在构造调用者实例的同时,完成被调用者的实例化。即使用构造器设置依赖关系。**

- 创建有参构造方法

```java
public Student(String myname,int myage, School mySchool){
    //属性赋值
    this.name  = myname;
    this.age  = myage;
    this.school = mySchool;
}
```

- 使用`<constructor-arg />`标签中用于指定参数的属性

```xml
<!--使用name属性实现构造注入-->
<bean id="myStudent" class="com.lin.p3.Student" >
    <constructor-arg name="myage" value="20" />
    <constructor-arg name="mySchool" ref="myXueXiao" />
    <constructor-arg name="myname" value="周良"/>
</bean>
```



# 二. 引用类型属性自动注入

对于引用类型属性的注入,也可不在配置文件中显示的注入。可以通过为`<bean/>`标签设置 autowire 属性值,为引用类型属性进行隐式自动注入(默认是不自动注入引用类型属性) 。根据自动注入判断标准的不同,可以分为两种:

- byName:根据名称自动注入
- byType: 根据类型自动注入



## 1. byName 方式自动注入

当配置文件中被调用者 bean 的 id 值与代码中调用者 bean 类的属性名相同时,可使用byName 方式,让容器自动将被调用者 bean 注入给调用者 bean。容器是通过调用者的 bean类的属性名与配置文件的被调用者 bean 的 id 进行比较而实现自动注入的。

- 使用autowire根据byName自动注入

```xml
<!--byName-->
<bean id="myStudent" class="com.lin.p4.Student" autowire="byName">
    <property name="name" value="李四" />
    <property name="age" value="26" />
    <!--使用autowire自动注入，而不是使用ref引用类型-->
    <!--<property name="school" ref="mySchool" />-->
</bean>

<!--声明School对象-->
<bean id="school" class="com.lin.p4.School">
    <property name="name" value="清华大学"/>
    <property name="address" value="北京的海淀区" />
</bean>
```

- 测试

```java
@Test
public void test01(){
    String config= "p4/applicationContext.xml";
    ApplicationContext ac = new ClassPathXmlApplicationContext(config);

    //从容器中获取Student对象
    Student myStudent =  (Student) ac.getBean("myStudent");
    System.out.println("student对象="+myStudent);
}
```

- 测试结果

![image-20210220224756824](https://i.loli.net/2021/02/20/KdzySHoZnTcakqE.png)



##  2. byType 方式自动注入

使用 byType 方式自动注入,要求:配置文件中被调用者 bean 的 class 属性指定的类,要与代码中调用者 bean 类的某引用类型属性类型同源。即要么相同,要么有 is-a 关系(子类,或是实现类) 。但这样的同源的被调用 bean 只能有一个。多于一个,容器就不知该匹配哪一个了。

- 使用autowire根据byType自动注入

```xml
<bean id="myStudent" class="com.lin.p5.Student" autowire="byType">
    <property name="name" value="张飒" />
    <property name="age" value="26" />
    <!--引用类型-->
    <!--<property name="school" ref="mySchool" />-->
</bean>

<!--声明School对象-->
<bean id="mySchool" class="com.lin.p5.School">
    <property name="name" value="人民大学"/>
    <property name="address" value="北京的海淀区" />
</bean>
```

- 测试

```java
@Test
public void test01(){
    String config= "p4/applicationContext.xml";
    ApplicationContext ac = new ClassPathXmlApplicationContext(config);

    //从容器中获取Student对象
    Student myStudent =  (Student) ac.getBean("myStudent");
    System.out.println("student对象="+myStudent);
}
```



# 三. 为应用指定多个 Spring 配置文件

在实际应用里,随着应用规模的增加,系统中 Bean 数量也大量增加,导致配置文件得非常庞大、臃肿。为了避免这种情况的产生,提高配置文件的可读性与可维护性,可以将Spring 配置文件分解成多个配置文件。

- 包含关系的配置文件:

  多个配置文件中有一个总文件,总配置文件将各其它子文件通过`<import/>`引入。在 Java代码中只需要使用总配置文件对容器进行初始化即可。举例:

![image-20210220225929566](https://i.loli.net/2021/02/20/sWahAJQGC731MtZ.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <import resource="classpath:p6/spring-*.xml" />
</beans>
```

