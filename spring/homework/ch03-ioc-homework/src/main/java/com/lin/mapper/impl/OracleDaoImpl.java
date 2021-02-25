package com.lin.mapper.impl;

import com.lin.mapper.UserDao;
import com.lin.entity.SysUser;
import org.springframework.stereotype.Repository;

@Repository("oracleDao")
public class OracleDaoImpl implements UserDao {
    @Override
    public void insertUser(SysUser user) {
        System.out.println("oracle 的insertUser");
    }
}
