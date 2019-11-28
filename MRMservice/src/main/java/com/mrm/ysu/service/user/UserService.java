package com.mrm.ysu.service.user;

import java.util.List;

import com.mrm.ysu.pojo.User;
import com.mrm.ysu.pojo.UserExample;

public interface UserService {
	
	int add(User user);
	int delete(int id);
	User queryone(int id);
	int update(User user);
    User getUserByAccount(String username);
    List<User> queryall(UserExample userExample);
    List<User> queryall(User user, UserExample userExample);
    int delete(User user);
    User query(int id);
    List<User> queryCondication(UserExample userExample);
}
