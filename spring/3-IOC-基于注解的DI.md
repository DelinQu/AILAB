# 基于注解的 DI 

对于 DI 使用注解,将不再需要在 Spring 配置文件中声明 bean 实例。 Spring 中使用注解,需要在原有 Spring 运行环境基础上再做一些改变。

- 需要在 Spring 配置文件中配置组件扫描器,用于在指定的基本包中扫描注解。



## 步骤一：扫描包的三种方式

- 使用多个 context:component-scan 指定不同的包路径

```xml
<context:component-scan base-package="com.lin.p1"/>
<context:component-scan base-package="com.lin.p2"/>
```

- 指定 base-package 的值使用分隔符（分隔符可以使用逗号,分号;还可以使用空格,不建议使用空格）

```xml
<context:component-scan base-package="com.lin.p1;com.lin.p2" />
```

- base-package 指定到父包名

```xml
<context:component-scan base-package="com.lin" />
```



## 步骤二：定义 Bean 的注解@Component(掌握)

- 需要在类上使用注解@Component,该注解的 value 属性用于指定该 bean 的 id 值。

```java
//省略value= “myStudent”
@Component("myStudent")
//如果不指定对象名称，由spring提供默认名称: 类名的首字母小写
//@Component
public class Student {
    private String name;
    private Integer age;
    public void setName(String name) {
        this.name = name;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
}
```

**另外,Spring 还提供了 3 个创建对象的注解:**

- @Repository
   用于对 DAO 实现类进行注解
- @Service
   用于对 Service 实现类进行注解
- @Controller
  用于对 Controller 实现类进行注解

这三个注解与@Component 都可以创建对象,但这三个注解还有其他的含义：

- @Service：创建业务层对象,业务层对象可以加入事务功能
- @Controller：注解创建的对象可以作为处理器接收用户的请求。
- @Repository,@Service,@Controller 是对@Component 注解的细化,标注不同层的对象。即持久层对象,业务层对象,控制层对象。
- @Component 不指定 value 属性,bean 的 id 是类名的首字母小写。



## 步骤三：注入属性

### （0）配置文件注入

- 加载属性配置文件

```xml
<!--加载属性配置文件-->
<context:property-placeholder location="classpath:test.properties" />
```

- 属性文件：

```properties
# test.properties
myname=LinXiaoDe
myage=20
```

- 使用

```java
@Value("${myname}") //使用属性配置文件中的数据
private String name;

@Value("${myage}")  //使用属性配置文件中的数据
private Integer age;
```



### （1）简单类型属性注入@Value(掌握)

需要在属性上使用注解@Value,该注解的 value 属性用于指定要注入的值。使用该注解完成属性注入时,类中无需 setter。当然,若属性有 setter,则也可将其加到 setter 上。

```java
@Component("myStudent")
public class Student {
    /**
     * @Value: 简单类型的属性赋值
     *   属性： value 是String类型的，表示简单类型的属性值
     *   位置： 1.在属性定义的上面，无需set方法，推荐使用。
     *         2.在set方法的上面
     */
    //@Value("李四" )
    @Value("${myname}") //使用属性配置文件中的数据
    private String name;

    @Value("${myage}")  //使用属性配置文件中的数据
    private Integer age;
}
```



### （2） byType 自动注入@Autowired(掌握)

需要在引用属性上使用注解@Autowired,该注解默认使用按类型自动装配 Bean 的方式。使用该注解完成属性注入时,类中无需 setter。当然,若属性有 setter,则也可将其加到 setter 上。

- School类

```java
@Component("mySchool")
public class School {
    @Value("北京大学")
    private String name;
    @Value("北京的海淀区")
    private String address;
}
```

- Student类：value + Autowired

```java
@Component("myStudent")
public class Student {
    @Value("LinXiaoDe" )
    private String name;
    private Integer age;
    /**
     * 引用类型
     * @Autowired: spring框架提供的注解，实现引用类型的赋值。
     * spring中通过注解给引用类型赋值，使用的是自动注入原理 ，支持byName, byType
     * @Autowired:默认使用的是byType自动注入。
     *
     *  位置：1）在属性定义的上面，无需set方法， 推荐使用
     *       2）在set方法的上面
     */
    @Autowired
    private School school;
}
```



### （3）byName 自动注入@Autowired 与@Qualifier(掌握)

需要在引用属性上联合使用注解@Autowired 与@Qualifier。@Qualifier 的 value 属性用于指定要匹配的 Bean 的 id 值。类中无需 set 方法,也可加到 set 方法上。

- school

```java
@Component("mySchool")
public class School {
    @Value("北京大学")
    private String name;
    @Value("北京的海淀区")
    private String address;
}
```

- Student

```java
@Component("myStudent")
public class Student {
    @Value("李四" )
    private String name;
    private Integer age;
    /**
     * 引用类型
     * @Autowired: spring框架提供的注解，实现引用类型的赋值。
     * spring中通过注解给引用类型赋值，使用的是自动注入原理 ，支持byName, byType
     * @Autowired:默认使用的是byType自动注入。
     *  位置：1）在属性定义的上面，无需set方法， 推荐使用
     *       2）在set方法的上面
     *  如果要使用byName方式，需要做的是：
     *  1.在属性上面加入@Autowired
     *  2.在属性上面加入@Qualifier(value="bean的id") ：表示使用指定名称的bean完成赋值。
     */
    //byName自动注入
    @Autowired
    @Qualifier("mySchool")
    private School school;
}
```



### （4）JDK 注解@Resource 自动注入(掌握)

Spring 提供了对 jdk 中@Resource 注解的支持。@Resource 注解既可以按名称匹配 Bean,也可以按类型匹配 Bean。默认是按名称注入。使用该注解,要求 JDK 必须是 6 及以上版本。@Resource 可在属性上,也可在 set 方法上。

#### a. byType 注入引用类型属性 (默认)

```java
@Component("myStudent")
public class Student {
    @Value("李四" )
    private String name;
    private Integer age;
    /**
     * 引用类型
     * @Resource: 来自jdk中的注解，spring框架提供了对这个注解的功能支持，可以使用它给引用类型赋值
     *            使用的也是自动注入原理，支持byName， byType .默认是byName
     *  位置： 1.在属性定义的上面，无需set方法，推荐使用。
     *        2.在set方法的上面
     */
    //默认是byName： 先使用byName自动注入，如果byName赋值失败，再使用byType
    @Resource
    private School school;
    public Student() {
        System.out.println("==student无参数构造方法===");
    }
    @Value("30")
    public void setAge(Integer age) {
        System.out.println("setAge:"+age);
        this.age = age;
    }
}
```



#### b.  byName 注入引用类型属性

```java
@Component("myStudent")
public class Student {
    @Value("李四" )
    private String name;
    private Integer age;
    //只使用byName
    @Resource(name = "mySchool")
    private School school;
    @Value("30")
    public void setAge(Integer age) {
        System.out.println("setAge:"+age);
        this.age = age;
    }
}
```





##  注解与 XML 的对比

>  注解优点是:

⚫ 方便
⚫ 直观
⚫ 高效(代码少,没有配置文件的书写那么复杂)。



> 其弊端也显而易见:以硬编码的方式写入到 Java 代码中,修改是需要重新编译代码的。

XML 方式优点是:
⚫ 配置和代码是分离的
⚫ 在 xml 中做修改,无需编译代码,只需重启服务器即可将新的配置加载。
xml 的缺点是:编写麻烦,效率低,大型项目过于复杂。