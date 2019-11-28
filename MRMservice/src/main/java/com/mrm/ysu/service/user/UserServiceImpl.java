package com.mrm.ysu.service.user;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.jws.soap.SOAPBinding.Use;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.mrm.ysu.dao.UserMapper;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.pojo.UserExample;
import com.mrm.ysu.service.department.DepartmentService;

@Service
public class UserServiceImpl implements UserService{
	@Resource
	UserMapper usermapper;
	@Resource
    DepartmentService departmentService;
	@Override
	public List<User> queryall(User user ,UserExample userExample) {
	    if(user.getWithPage()==1) {
            PageHelper.startPage(user.getPageNo(), user.getPageSize());
        }
		return  usermapper.selectByExample(userExample);
	}

	@Override
	public int add(User user) {
		// TODO Auto-generated method stub
		return usermapper.insertSelective(user);
	}

	@Override
	public int delete(User user) {
		// TODO Auto-generated method stub
		return usermapper.updateByPrimaryKeySelective(user);
	}

	@Override
	public User queryone(int id) {
		// TODO Auto-generated method stub
	    User user=  usermapper.selectByPrimaryKey(id);
	    System.out.println(user.toString());
	    user.setDepartment(departmentService.query(user.getDepartmentId()).getName());
		return user;
	}
	@Override
	public int update(User user) {
        // TODO Auto-generated method stub
        return usermapper.updateByPrimaryKeySelective(user);
    }
	@Override
	 public User getUserByAccount(String username) {
	        // TODO Auto-generated method stub
	        
	        List<User> user=new ArrayList<>();
	        UserExample example = new UserExample();
	        example.createCriteria().andAccountEqualTo(username).andIsDelEqualTo(1);
	        user=usermapper.selectByExample(example);
	        if(user.size()==0)
	            return null;
	        return user.get(0);
	    }

    @Override
    public int delete(int id) {
        // TODO Auto-generated method stub
        return 0;
    }
    @Override
    public List<User> queryCondication(UserExample userExample){
        return  usermapper.selectByExample(userExample);
    }

    @Override
    public List<User> queryall(UserExample userExample) {
        // TODO Auto-generated method stub
        return  usermapper.selectByExample(userExample);
    }

    @Override
    public User query(int id) {
       // System.out.println(user.toString());
        //user.setDepartment(departmentService.query(user.getDepartmentId()).getName());
        return usermapper.selectByPrimaryKey(id);
    }
	
}
