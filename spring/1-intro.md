# Spring 概述

<img src="https://i.loli.net/2021/02/20/9ve6K8p5IZXEn2g.png" alt="image-20210220160252871" style="zoom:80%;" />

## 概念

Spring 是于 2003 年兴起的一个轻量级的 Java 开发框架,它是为了解决企业应用开发的复杂性而创建的。Spring 的核心是控制反转(IoC)和面向切面编程(AOP) 。Spring 是可以在 Java SE/EE 中使用的轻量级开源框架。 

- Spring 的主要作用就是为代码“解耦” ,降低代码间的耦合度。就是让对象和对象(模块和模块)之间关系不是使用代码关联,而是通过配置来说明。即在 Spring 中说明对象(模块)的关系。
- Spring 根据代码的功能特点,使用 Ioc 降低业务对象之间耦合度。 IoC 使得主业务在相互调用过程中,不用再自己维护关系了,即不用再自己创建要使用的对象了。而是由 Spring容器统一管理,自动“注入”,注入即赋值。 而 AOP 使得系统级服务得到了最大复用,且不用再由程序员手工将系统级服务“混杂”到主业务逻辑中了,而是由 Spring 容器统一完成“织入”。

（AOP + ICO）



## 官网

- 官网：https://spring.io/projects/spring-framework#learn
- 学习教程：https://www.bilibili.com/video/BV1nz4y1d7uy?p=4&spm_id_from=pageDriver

<img src="https://i.loli.net/2021/02/20/BgOkANaF6hvGbeQ.png" alt="image-20210220155718317" style="zoom:80%;" />





## 优点

Spring 是一个框架,是一个半成品的软件。有 20 个模块组成。它是一个容器管理对象,容器是装东西的,Spring 容器不装文本,数字。装的是对象。Spring 是存储对象的容器。

- 轻量

- 针对接口编程,解耦合

- IOC：

  pring 提供了 Ioc 控制反转,由容器管理对象,对象的依赖关系。原来在程序代码中的对象创建方式,现在由容器完成。对象之间的依赖解耦合。

- AOP ：
  通过 Spring 提供的 AOP 功能,方便进行面向切面的编程,许多不容易用传统 OOP 实现的功能可以通过 AOP 轻松应付在 Spring 中,开发人员可以从繁杂的事务管理代码中解脱出来,通过声明式方式灵活地进行事务的管理,提高开发效率和质量。





## 体系结构

- 由 20 多个模块组成
- 数据访问/集成(Data Access/Integration)
- Web
- 面向切面编程 (AOP, Aspects)
-  提供 JVM 的代理(Instrumentation)
-  消息发送 (Messaging)
- 核心容器(Core Container)
- 测试(Test)

<img src="https://i.loli.net/2021/02/20/Dn32B69kEhUzQja.png" alt="image-20210220160003515" style="zoom: 50%;" /> 







