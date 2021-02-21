# 购买商品 trans_sale 项目的事务实例



## 环境搭建

- 跳过：和前面一个项目的环境一模一样



## 1. 创建数据库表

- sale 销售表

```sql
create table sale
(
    id   int auto_increment
        primary key,
    gid  int not null,
    nums int null
);
```

- goods货物表

```sql
create table goods
(
    id     int          not null
        primary key,
    name   varchar(100) null,
    amount int          null,
    price  int          null
);
```





## 2. 创建实体

- Goods

![image-20210221221420885](https://i.loli.net/2021/02/21/cVpxPUCKM3OLTtB.png) 

```java
public class Goods {

    private Integer id;
    private String name;
    private Integer amount;
    private Float price;
}
```

- Sale

```java
public class Sale {
    private Integer id;
    private Integer gid;
    private Integer nums;
}
```





## 3. 创建mapper和实现

- GoodsMapper

```java
public interface GoodsMapper {
    int updateGoods(Goods goods);

    Goods selectGoods(Integer id);
}
```

- SaleMapper

```java
public interface SaleMapper {
    int insertSale(Sale sale);
}
```



## 4. 实现mapper 的 sql 映射文件

这里只实现了update select,以及insert,比较简单：

- GoodsMapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.bjpowernode.mapper.GoodsMapper">
    <select id="selectGoods" resultType="com.bjpowernode.entity.Goods">
        select id,name,amount,price from goods where id=#{gid}
    </select>

    <update id="updateGoods">
        update goods set amount = amount - #{amount} where id=#{id}
    </update>
</mapper>
```

- SaleMapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.bjpowernode.mapper.SaleMapper">
    <insert id="insertSale">
        insert into sale(gid,nums) values(#{gid},#{nums})
    </insert>
</mapper>
```





## 5.定义异常类

**定义 service 层可能会抛出的异常类 NotEnoughException**

```java
public class NotEnoughException extends RuntimeException {
    public NotEnoughException() {
        super();
    }
    public NotEnoughException(String message) {
        super(message);
    }
}
```





## 6. 定义 Service 接口并实现

- 接口

```java
package com.bjpowernode.service;

public interface BuyGoodsService {
    void buy(Integer goodsId,Integer nums);
}
```

- 实现

```java
public class BuyGoodsServiceImpl implements BuyGoodsService {
    private SaleMapper saleDao;
    private GoodsMapper goodsDao;
    @Override
    public void buy(Integer goodsId, Integer nums) {
        System.out.println("buy Start here----------------");
        Sale sale  = new Sale();
        sale.setGid(goodsId);
        sale.setNums(nums);
        
        // 向数据库中插入sale
        saleDao.insertSale(sale);

        //update货物发生异常
        Goods goods  = goodsDao.selectGoods(goodsId);
        if( goods == null){
            //商品不存在
            throw  new  NullPointerException("ID："+goodsId+",商品不存在");
        } else if( goods.getAmount() < nums){
            //商品库存不足
            throw new NotEnoughException("ID："+goodsId+",商品库存不足");
        }
        //update货物
        Goods buyGoods = new Goods();
        buyGoods.setId( goodsId);
        buyGoods.setAmount(nums);
        goodsDao.updateGoods(buyGoods);
        System.out.println("buy finish here---------------");
    }
}
```



## 7. 修改 Spring 配置文件 和mybatis配置文件

- mybatis.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--设置别名-->
    <typeAliases>
        <package name="com.lin.entity"/>
    </typeAliases>
    <!-- sql mapper(sql映射文件)的位置-->
    <mappers>
        <package name="com.lin.mapper"/>
    </mappers>
</configuration>
```

- applications

```xml
管理类以及数据库加载，适配mybatis

<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!--指定SqlSessionFactory对象的id-->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
        <!--指定包名， 包名是dao接口所在的包名。
            MapperScannerConfigurer会扫描这个包中的所有接口，把每个接口都执行
            一次getMapper()方法，得到每个接口的dao对象。
            创建好的dao对象放入到spring的容器中的。 dao对象的默认名称是 接口名首字母小写
        -->
        <property name="basePackage" value="com.lin.mapper"/>
    </bean>

    <!--声明service-->
    <bean id="buyService" class="com.lin.service.impl.BuyGoodsServiceImpl">
        <property name="goodsDao" ref="goodsMapper" />
        <property name="saleDao" ref="saleMapper" />
    </bean>
```



## 8. 测试

```java
public class MyTest {
    @Test
    public void test01(){
        String config="applicationContext.xml";
        ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
        //从容器获取service
        BuyGoodsService service = (BuyGoodsService) ctx.getBean("buyService");

        //调用方法
        service.buy(1001,200);
    }
}
```

- 结果

![image-20210221223406742](https://i.loli.net/2021/02/21/o1smbK8vWkCzRpM.png)

由于数据库中1001货物的数量为10，小于200,所以抛出异常，但是此时sale数据已经改变，显然要新加数据处理。

![image-20210221223448324](https://i.loli.net/2021/02/21/VjTrYJC6iFW3vKM.png)

![image-20210221223639346](https://i.loli.net/2021/02/21/sLtG8hl56dgvOVJ.png)

# 一. 使用 Spring 的事务注解管理事务(掌握)

通过@Transactional 注解方式,可将事务织入到相应 public 方法中,实现事务管理。
**@Transactional 的所有可选属性如下所示:**

**➢ propagation:**

用于设置事务传播属性。该属性类型为 Propagation 枚举,默认值Propagation.REQUIRED。

**➢ isolation :** 

用 于 设 置 事 务 的 隔 离 级 别 。 该 属 性 类 型 为 Isolation 枚 举 , 默 认 值 为Isolation.DEFAULT。

**➢ readOnly:**

用于设置该方法对数据库的操作是否是只读的。该属性为 boolean,默认值为 false。

**➢ timeout:**

用于设置本操作与数据库连接的超时时限。单位为秒,类型为 int,默认值为-1,即没有时限。

**➢ rollbackFor:**

指定需要回滚的异常类。类型为 Class[],默认值为空数组。当然,若只有一个异常类时,可以不使用数组。

**➢ rollbackForClassName:**

指定需要回滚的异常类类名。类型为 String[],默认值为空数组。当然,若只有一个异常类时,可以不使用数组。

**➢ noRollbackFor:**

指定不需要回滚的异常类。类型为 Class[],默认值为空数组。当然,若只有一个异常类时,可以不使用数组。

**➢ noRollbackForClassName:**

指定不需要回滚的异常类类名。类型为 String[],默认值为空数组。当然,若只有一个异常类时,可以不使用数组。



**需要注意的是**

- @Transactional 若用在方法上 ,只能用于 public 方法上。
- 对于其他非 public方法,如果加上了注解@Transactional,虽然 Spring 不会报错,但不会将指定事务织入到该方法中。因为 Spring 会忽略掉所有非 public 方法上的@Transaction 注解。
- 若@Transaction 注解在类上,则表示该类上所有的方法均将在执行时织入事务。

## **下面我们看Spring注解实现事务的实例**

### 1. 声明事务管理器

```xml
<!--使用spring的事务处理-->
<!--1. 声明事务管理器-->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <!--连接的数据库， 指定数据源-->
    <property name="dataSource" ref="myDataSource" />
</bean>
```

### 2. 开启注解驱动

```xml
<!--2. 开启事务注解驱动，告诉spring使用注解管理事务，创建代理对象
transaction-manager:事务管理器对象的id-->
<tx:annotation-driven transaction-manager="transactionManager" />
```

### 3. 在业务方法上添加注解

```java
public class BuyGoodsServiceImpl implements BuyGoodsService {
    private SaleMapper saleDao;
    private GoodsMapper goodsDao;
    
    @Transactional
    @Override
    public void buy(Integer goodsId, Integer nums) {
        System.out.println("buy Start here----------------");
        Sale sale  = new Sale();
        sale.setGid(goodsId);
        sale.setNums(nums);
-------------------------------
```

- 测试结果

<img src="https://i.loli.net/2021/02/21/eJyPAMmnDl7StX1.png" alt="image-20210221231155731" style="zoom:50%;" />



- 数据库表回滚，sale无变化

<img src="/home/qdl/.config/Typora/typora-user-images/image-20210221231316994.png" alt="image-20210221231316994" style="zoom:50%;" />













![image-20210221225355774](/home/qdl/.config/Typora/typora-user-images/image-20210221225355774.png)





# 二. 使用 AspectJ 的 AOP 配置管理事务

- 使用 XML 配置事务代理的方式的不足是,每个目标类都需要配置事务代理。当目标类较多,配置文件会变得非常臃肿。
- 使用 XML 配置顾问方式可以自动为每个符合切入点表达式的类生成事务代理。其用法很简单,只需将前面代码中关于事务代理的配置删除,再替换为如下内容即可。

### 1. 在容器中添加事务管理器

```xml-dtd
<!--1.声明事务管理器对象-->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="myDataSource" />
</bean>
```



### 2. 配置事务通知

```xml
<!--2.声明业务方法它的事务属性（隔离级别，传播行为，超时时间）
	id:自定义名称，表示 <tx:advice> 和 </tx:advice>之间的配置内容的
    transaction-manager:事务管理器对象的id-->
<tx:advice id="myAdvice" transaction-manager="transactionManager">
    <!--tx:attributes：配置事务属性-->
    <tx:attributes>
        <!--tx:method：给具体的方法配置事务属性，method可以有多个，分别给不同的方法设置事务属性
            name:方法名称，1）完整的方法名称，不带有包和类。
                          2）方法可以使用通配符,* 表示任意字符
            propagation：传播行为，枚举值
            isolation：隔离级别
            rollback-for：你指定的异常类名，全限定类名。 发生异常一定回滚
        -->
        <tx:method name="buy" propagation="REQUIRED" isolation="DEFAULT"
                   rollback-for="java.lang.NullPointerException,com.lin.excep.NotEnoughException"/>
        <!--使用通配符，指定很多的方法-->
        <tx:method name="add*" propagation="REQUIRES_NEW" />
        <!--指定修改方法-->
        <tx:method name="modify*" />
        <!--删除方法-->
        <tx:method name="remove*" />
        <!--查询方法，query，search，find-->
        <tx:method name="*" propagation="SUPPORTS" read-only="true" />
    </tx:attributes>
</tx:advice>
```



### 3. 配置AOP增强器

```xml
<aop:config>
    <!--配置切入点表达式：指定哪些包中类，要使用事务
        id:切入点表达式的名称，唯一值
        expression：切入点表达式，指定哪些类要使用事务，aspectj会创建代理对象

        com.bjpowernode.service
        com.crm.service
        com.service
    -->
    <aop:pointcut id="servicePt" expression="execution(* *..service..*.*(..))"/>
    <!--配置增强器：关联adivce和pointcut
       advice-ref:通知，上面tx:advice哪里的配置
       pointcut-ref：切入点表达式的id
    -->
    <aop:advisor advice-ref="myAdvice" pointcut-ref="servicePt" />
</aop:config>
```



### 4. 测试

```java
@Test
public void test(){
    String config="applicationContext.xml";
    ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
    //从容器获取service
    BuyGoodsService service = (BuyGoodsService) ctx.getBean("buyService");

    //com.sun.proxy.$Proxy12
    System.out.println("service是代理："+service.getClass().getName());
    //调用方法
    service.buy(1001,10);
}
```

- 测试结果

![image-20210221233341418](https://i.loli.net/2021/02/21/Ami6d8jZVFyHlgP.png)