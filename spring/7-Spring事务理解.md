# 第5章 Spring 事务

## 1. Spring 的事务管理

事务原本是数据库中的概念,在 Dao 层。但一般情况下,需要将事务提升到业务层,即 Service 层。这样做是为了能够使用事务的特性来管理具体的业务。在 Spring 中通常可以通过以下两种方式来实现对事务的管理:

- 使用 Spring 的事务注解管理事务
- 使用 AspectJ 的 AOP 配置管理事务



## 2. Spring 事务管理 API

Spring 的事务管理,主要用到两个事务相关的接口。

### (1) 事务管理器接口(重点)

事务管理器是 PlatformTransactionManager 接口对象。其主要用于完成事务的提交、回滚,及获取事务的状态信息。

![image-20210221205651374](https://i.loli.net/2021/02/21/lFdeqYpgMBsAuh9.png)



**A、 常用的两个实现类**

`PlatformTransactionManager` 接口有两个常用的实现类:
➢ `DataSourceTransactionManager`:使用 JDBC 或 MyBatis 进行数据库操作时使用。
➢ `HibernateTransactionManager`:使用 Hibernate 进行持久化数据时使用。



**B、 Spring 的回滚方式(理解)**

Spring 事务的默认回滚方式是:发生运行时异常和 error 时回滚,发生受查(编译)异常时提交。不过,对于受查异常,程序员也可以手工设置其回滚方式。



**C、 回顾错误与异常(理解)**

![image-20210221205954235](https://i.loli.net/2021/02/21/387ptYXW5HVJI6j.png)

- Throwable 类是 Java 语言中所有错误或异常的超类。只有当对象是此类(或其子类之一)的实例时,才能通过 Java 虚拟机或者 Java 的 throw 语句抛出。
- Error 是 程 序 在 运 行 过 程 中 出 现 的 无 法 处 理 的 错 误 , 比 如 OutOfMemoryError 、ThreadDeath、NoSuchMethodError 等。当这些错误发生时,程序是无法处理(捕获或抛出)的,JVM 一般会终止线程。
- 程序在编译和运行时出现的另一类错误称之为异常,它是 JVM 通知程序员的一种方式。通过这种方式,让程序员知道已经或可能出现错误,要求程序员对其进行处理。
- 异常分为运行时异常与受查异常。运行时异常,是 RuntimeException 类或其子类,即只有在运行时才出现的异常。如,
  NullPointerException、ArrayIndexOutOfBoundsException、IllegalArgumentException 等均属于运行时异常。这些异常由 JVM 抛出,在编译时不要求必须处理(捕获或抛出)。但,只要代码编写足够仔细,程序足够健壮,运行时异常是可以避免的。
- 受查异常,也叫编译时异常,即在代码编写时要求必须捕获或抛出的异常,若不处理,则无法通过编译。如 SQLException, ClassNotFoundException, IOException 等都属于受查异常。
- RuntimeException 及其子类以外的异常,均属于受查异常。当然,用户自定义的 Exception的子类,即用户自定义的异常也属受查异常。程序员在定义异常时,只要未明确声明定义的为 RuntimeException 的子类,那么定义的就是受查异常。



### (2) 事务定义接口

事务定义接口 TransactionDefinition 中定义了事务描述相关的三类常量:事务隔离级别、事务传播行为、事务默认超时时限,及对它们的操作。

![image-20210221210246218](https://i.loli.net/2021/02/21/nQtV9F28IlqihrM.png)

#### **A、 定义了五个事务隔离级别常量(掌握)**

这些常量均是以 ISOLATION_开头。即形如 ISOLATION_XXX。
➢ DEFAULT:采用 DB 默认的事务隔离级别。MySql 的默认为 REPEATABLE_READ; Oracle
默认为 READ_COMMITTED。
➢ READ_UNCOMMITTED:读未提交。未解决任何并发问题。
➢ READ_COMMITTED:读已提交。解决脏读,存在不可重复读与幻读。
➢ REPEATABLE_READ:可重复读。解决脏读、不可重复读,存在幻读
➢ SERIALIZABLE:串行化。不存在并发问题。



#### **B、 定义了七个事务传播行为常量(掌握)**
所谓事务传播行为是指,处于不同事务中的方法在相互调用时,执行期间事务的维护情况。如,A 事务中的方法 doSome()调用 B 事务中的方法 doOther(),在调用执行期间事务的维护情况,就称为事务传播行为。事务传播行为是加在方法上的。

- 事务传播行为常量都是以 PROPAGATION_ 开头,形如 PROPAGATION_XXX。事务传播行为常量都是以 PROPAGATION_ 开头,形如 PROPAGATION_XXX。

```
PROPAGATION_REQUIRED
PROPAGATION_REQUIRES_NEW
PROPAGATION_SUPPORTS
PROPAGATION_MANDATORY
PROPAGATION_NESTED
PROPAGATION_NEVER
PROPAGATION_NOT_SUPPORTED
```



- **a、 PROPAGATION_REQUIRED:**

指定的方法必须在事务内执行。若当前存在事务,就加入到当前事务中;若当前没有事务,则创建一个新事务。这种传播行为是最常见的选择,也是 Spring 默认的事务传播行为。

如该传播行为加在 doOther()方法上。若 doSome()方法在调用 doOther()方法时就是在事务内运行的,则 doOther()方法的执行也加入到该事务内执行。若 doSome()方法在调用doOther()方法时没有在事务内执行,则 doOther()方法会创建一个事务,并在其中执行。

![image-20210221211033009](https://i.loli.net/2021/02/21/T8sFnqx4NGLhMSJ.png)



- **b、PROPAGATION_SUPPORTS**

**指定的方法支持当前事务,但若当前没有事务,也可以以非事务方式执行。**

![image-20210221211112559](https://i.loli.net/2021/02/21/rk8N9MoHGjqCelf.png)





- **c、PROPAGATION_REQUIRES_NEW**

总是新建一个事务,若当前存在事务,就将当前事务挂起,直到新事务执行完毕。

![image-20210221211406939](https://i.loli.net/2021/02/21/ueMcX9a1ikYLszB.png)



#### **C、 定义了默认事务超时时限**