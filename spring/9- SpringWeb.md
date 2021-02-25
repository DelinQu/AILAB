 

#  Spring 与 Web

## 环境准备

- ArchLinux
- 安装tomcat

```zsh
$ sudo pacman -S tomcat9
```

![image-20210225232350449](https://i.loli.net/2021/02/25/xLn8ErHwip6gDhm.png)

- pom依赖

```xml
  <dependencies>
    <!--单元测试-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
    <!--spring核心ioc-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <!--做spring事务用到的-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-tx</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <!--mybatis依赖-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.5.1</version>
    </dependency>
    <!--mybatis和spring集成的依赖-->
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>1.3.1</version>
    </dependency>
    <!--mysql驱动-->
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.20</version>
    </dependency>
    <!--阿里公司的数据库连接池-->
    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>druid</artifactId>
      <version>1.1.12</version>
    </dependency>
    <!-- servlet依赖 -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>3.1.0</version>
      <scope>provided</scope>
    </dependency>
    <!-- jsp依赖 -->
    <dependency>
      <groupId>javax.servlet.jsp</groupId>
      <artifactId>jsp-api</artifactId>
      <version>2.2.1-b03</version>
      <scope>provided</scope>
    </dependency>

    <!--为了使用监听器对象，加入依赖-->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>5.2.5.RELEASE</version>
    </dependency>
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <version>1.18.16</version>
    </dependency>
  </dependencies>
```



## 项目结构

```zsh
$ tree
src/main/java/com/lin 
.
├── controller
│   └── RegisterServlet.java
├── entity
│   └── Student.java
├── mapper
│   ├── OrderMapper.java
│   ├── OrderMapper.xml
│   ├── StudentMapper.java
│   └── StudentMapper.xml
└── service
    ├── impl
    │   └── StudentServiceImpl.java
    └── StudentService.java
```



## 新建RegisterServlet

- 要继承`doPost` 和`doget` 方法

```java
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, 

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
```

- 创建spring的容器对象并获取studentService方法

```java
String config= "spring.xml";
ApplicationContext ctx = new ClassPathXmlApplicationContext(config);
//获取ServletContext中的容器对象，创建好的容器对象，拿来就用
String key =  WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE;
Object attr  = getServletContext().getAttribute(key);
if( attr != null){
ctx = (WebApplicationContext)attr;
}
//获取service
StudentService service  = (StudentService) ctx.getBean("studentService");
```

- 执行插入操作

```java
Student student  = new Student();
student.setId(Integer.parseInt(strId));
student.setName(strName);
student.setEmail(strEmail);
student.setAge(Integer.valueOf(strAge));
service.addStudent(student);
```

- 插入成功后返回一个页面

```java
//给一个页面
request.getRequestDispatcher("/result.jsp").forward(request,response);
```



## webapp

- 新建webapp目录：

![image-20210225232915620](https://i.loli.net/2021/02/25/r9Sl8JsvLFj7oHh.png)

- 主页

主页主要的功能是表单注册，我们只需要简单的设置一个包含Student信息的表单，并且提交到后台即可

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
     <p>注册学生</p>
     <form action="reg" method="post">
         <table>
             <tr>
                 <td>id</td>
                 <td><input type="text" name="id"></td>
             </tr>
             <tr>
                 <td>姓名：</td>
                 <td><input type="text" name="name"></td>
             </tr>
             <tr>
                 <td>email:</td>
                 <td><input type="text" name="email"></td>
             </tr>
             <tr>
                 <td>年龄：</td>
                 <td><input type="text" name="age"></td>
             </tr>
             <tr>
                 <td></td>
                 <td><input type="submit" value="注册学生"></td>
             </tr>
         </table>
     </form>
</body>
</html>
```

- 注册成功页面

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
result.jsp 注册成功
</body>
</html>
```

- WEB-INF

监听器被创建对象后，会读取/WEB-INF/spring.xml为什么要读取文件：因为在监听器中要创建ApplicationContext对象，需要加载配置文件。/WEB-INF/applicationContext.xml就是监听器默认读取的spring配置文件路径可以修改默认的文件位置，使用context-param重新指定文件的位置.配置监听器：目的是创建容器对象，创建了容器对象， 就能把spring.xml配置文件中的所有对象都创建好。用户发起请求就可以直接使用对象了。

```jsp
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <servlet>
        <servlet-name>RegisterServlet</servlet-name>
        <servlet-class>com.lin.controller.RegisterServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>RegisterServlet</servlet-name>
        <url-pattern>/reg</url-pattern>
    </servlet-mapping>
    <context-param>
        <!-- contextConfigLocation:表示配置文件的路径  -->
        <param-name>contextConfigLocation</param-name>
        <!--自定义配置文件的路径-->
        <param-value>classpath:spring.xml</param-value>
    </context-param>
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
</web-app>
```



## 测试



### 配置tomcat

![image-20210225233312084](https://i.loli.net/2021/02/25/wjev7aLEDiHXb5l.png)

## 启动项目

- 主页插入学生信息

![image-20210225233422626](https://i.loli.net/2021/02/25/hBZuM6ADUXtiRNl.png)

- 注册成功页面

![image-20210225233442965](https://i.loli.net/2021/02/25/nIZKBLSyJqePMdN.png)

- 数据库结果

![image-20210225233607278](https://i.loli.net/2021/02/25/DHhai3Mtzr8mYxn.png)