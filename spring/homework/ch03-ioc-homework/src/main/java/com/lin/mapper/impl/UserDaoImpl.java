package com.lin.mapper.impl;

import com.lin.mapper.UserDao;
import com.lin.entity.SysUser;
import org.springframework.stereotype.Repository;

@Repository("mysqlDao")
public class UserDaoImpl implements UserDao {
    @Override
    public void insertUser(SysUser user) {
        System.out.println("user插入到mysql数据库");
    }
}
