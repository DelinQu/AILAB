#  Spring 集成 MyBatis

- 将 MyBatis 与 Spring 进行整合,主要解决的问题就是将 SqlSessionFactory 对象交由 Spring来管理。所以,该整合,只需要将SqlSessionFactory 的对象生成器 SqlSessionFactoryBean 注册在 Spring 容器中,再将其注入给 Dao 的实现类即可完成整合。
- 实现 Spring 与 MyBatis 的整合常用的方式:扫描的 Mapper 动态代理Spring 像插线板一样,mybatis 框架是插头,可以容易的组合到一起。插线板 spring 插上 mybatis,两个框架就是一个整体。 



## 1. 创建数据库

```sql
create table student
(
    id    int auto_increment
        primary key,
    name  varchar(50) not null,
    email varchar(50) not null,
    age   int         not null
);
```



## 2. 导入maven依赖

- spring-context：spring核心ioc
- spring-tx：做spring事务用到的
- spring-jdbc：数据库连接
- mybatis：框架
- mybatis-spring：mybatis和spring集成的依赖
- mysql-connector-java：mysql驱动
- druid：连接池
- 配置扫描路径

```xml
<build>
  <!--目的是把src/main/java目录中的xml文件包含到输出结果中。输出到classes目录中-->
  <resources>
    <resource>
      <directory>src/main/java</directory><!--所在的目录-->
      <includes><!--包括目录下的.properties,.xml 文件都会扫描到-->
        <include>**/*.properties</include>
        <include>**/*.xml</include>
      </includes>
      <filtering>false</filtering>
    </resource>
  </resources>
</build>
```





## 3. 实体类和接口类

- 实体类

```java
public class Student {
    //属性名和列名一样。
    private Integer id;
    private String name;
    private String email;
    private Integer age;
}
```

- 接口类

```java
public interface StudentMapper {

    int insertStudent(Student student);

    int updateStudent(Student student);

    int deleteStudent(Student student);

    Student selectById(int id);
    
    List<Student> selectStudents();
}
```



## 4. 定义映射文件 mapper实现接口

- 注意：`namespace="com.lin.mapper.StudentMapper"`

```xml
<mapper namespace="com.lin.mapper.StudentMapper">
    <insert id="insertStudent">
        insert into student values(#{id},#{name},#{email},#{age})
    </insert>
    <select id="selectStudents" resultType="Student">
        select id,name,email,age from student order by id desc
    </select>
    <update id="updateStudent">
        update student set name=#{name },email=#{email},age=#{age} where id = #{id}
    </update>
    <delete id="deleteStudent">
        delete from student where id = #{studentId}
    </delete>
    <select id="selectById" resultType="Student">
        select id,name,email,age from student where id=#{id}
    </select>
</mapper>
```



## 5. 定义 Service 接口和实现类

- 接口类

```java
public interface StudentService {
    int insertStudent(Student student);

    int updateStudent(Student student);

    int deleteStudent(Student student);

    Student selectById(int id);

    List<Student> selectStudents();
}
```

- **接口实现类**

```java
public class StudentServiceImpl implements StudentService{
    private StudentMapper studentMapper;
    public void setStudentMapper(StudentMapper studentMapper) {
        this.studentMapper = studentMapper;
    }
    @Override
    public int insertStudent(Student student) {
        return studentMapper.insertStudent(student);
    }
    @Override
    public int updateStudent(Student student) {
        return studentMapper.updateStudent(student);
    }
    @Override
    public int deleteStudent(Student student) {
        return studentMapper.deleteStudent(student);
    }
    @Override
    public Student selectById(int id) {
        return studentMapper.selectById(id);
    }
    @Override
    public List<Student> selectStudents() {
        return studentMapper.selectStudents();
    }
}
```



## 6. 定义 MyBatis 主配置文件

在 src 下定义 MyBatis 的主配置文件,命名为 mybatis.xml这里有两点需要注意:

- 主配置文件中不再需要数据源的配置了。因为数据源要交给 Spring 容器来管理了。
- 这里对 mapper 映射文件的注册,使用`<package/>标签`,即只需给出 mapper 映射文件所在的包即可。因为 mapper 的名称与 Dao 接口名相同,可以使用这种简单注册方式。这种方式的好处是,若有多个映射文件,这里的配置也是不用改变的。当然,也可使用原来的`<resource/>标签`方式。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--settings：控制mybatis全局行为-->
    <settings>
        <!--设置mybatis输出日志-->
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>
    <!--设置别名-->
    <typeAliases>
        <!--name:实体类所在的包名
            表示com.lin.entity包中的列名就是别名
            你可以使用Student表示com.lin.entity.Student
        -->
        <package name="com.lin.entity"/>
    </typeAliases>
    <!-- sql mapper(sql映射文件)的位置-->
    <mappers>
        <!--name：是包名， 这个包中的所有mapper.xml一次都能加载-->
        <package name="com.lin.mapper"/>
    </mappers>
</configuration>
```





## 7. Spring 配置文件

### (1) 数据源的配置
使用 JDBC 模板,首先需要配置好数据源,数据源直接以 Bean 的形式配置在 Spring 配置文件中。根据数据源的不同,其配置方式不同:

-  Druid 数据源 DruidDataSource
  Druid 是阿里的开源数据库连接池。是 Java 语言中最好的数据库连接池。Druid 能够提供强大的监控和扩展功能。Druid 与其他数据库连接池的最大区别是提供数据库的
- 官网:https://github.com/alibaba/druid
- 使用地址:https://github.com/alibaba/druid/wiki/常见问题
- 配置连接池 a

<img src="https://i.loli.net/2021/02/21/o1dfvkp7gFymG4n.png" alt="image-20210221200457085" style="zoom:80%;" />

- **从属性文件读取数据库连接信息**

为了便于维护,可以将数据库连接信息写入到属性文件中,使 Spring 配置文件从中读取数据。属性文件名称自定义,但一般都是放在 src 下。为了便于维护,可以将数据库连接信息写入到属性文件中,使 Spring 配置文件从中读取数据：

```xml
<!--声明数据源DataSource, 作用是连接数据库的-->
<bean id="myDataSource" class="com.alibaba.druid.pool.DruidDataSource"
      init-method="init" destroy-method="close">
    <!--set注入给DruidDataSource提供连接数据库信息 -->
    <!--    使用属性配置文件中的数据，语法 ${key} -->
    <property name="url" value="${jdbc.url}" /><!--setUrl()-->
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.passwd}" />
    <property name="maxActive" value="${jdbc.max}" />
</bean>
```

- 配置文件

```properties
jdbc.url=jdbc:mysql://IP:3306/spring?useSSL=true&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
jdbc.username=LinXiaoDe
jdbc.passwd=xxxx
jdbc.max=30
```



### (2) 注册 SqlSessionFactoryBean



```xml
<!--声明的是mybatis中提供的SqlSessionFactoryBean类，这个类内部创建SqlSessionFactory的
    SqlSessionFactory  sqlSessionFactory = new ..
-->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <!--set注入，把数据库连接池付给了dataSource属性-->
    <property name="dataSource" ref="myDataSource" />
    <!--mybatis主配置文件的位置
       configLocation属性是Resource类型，读取配置文件
       它的赋值，使用value，指定文件的路径，使用classpath:表示文件的位置
    -->
    <property name="configLocation" value="classpath:mybatis.xml" />
</bean>
```



### (3) 定义 Mapper 扫描配置器 MapperScannerConfigurer

Mapper 扫描配置器 MapperScannerConfigurer 会自动生成指定的基本包中 mapper 的代理对象。该 Bean 无需设置 id 属性。basePackage 使用分号或逗号设置多个包。

```xml
<!--创建mapper对象，使用SqlSession的getMapper（StudentDao.class）
    MapperScannerConfigurer:在内部调用getMapper()生成每个mapper接口的代理对象。-->
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
```





### (4) 向 Service 注入接口名

向 Service 注 入 Mapper 代 理 对 象 时 需 要 注 意 , 由 于 通 过 Mapper 扫 描 配 置 器MapperScannerConfigurer 生成的 Mapper 代理对象没有名称,所以在向 Service 注入 Mapper代理时,无法通过名称注入。但可通过接口的简单类名注入,因为生成的是这个 Dao 接口
的对象。

```xml
<!--声明service-->
<bean id="studentService" class="com.lin.service.impl.StudentServiceImpl">
    <property name="studentMapper" ref="studentMapper" />
</bean>
```





### (5) 测试

```java
@Test
public void testServiceSelect(){

    String config="applicationContext.xml";
    ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
    //获取spring容器中的dao对象
    StudentService service = (StudentService) ctx.getBean("studentService");

    List<Student> students = service.selectStudents();
    for (Student stu:students){
    	System.out.println(stu);
    }
}
```

- 测试结果

<img src="https://i.loli.net/2021/02/21/lPRvd5nfzXj8yFC.png" alt="image-20210221203430183" style="zoom:80%;" />

