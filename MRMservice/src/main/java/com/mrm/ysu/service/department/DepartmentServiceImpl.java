package com.mrm.ysu.service.department;

import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.mrm.ysu.dao.DepartmentMapper;
import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.DepartmentExample;

@Service
public class DepartmentServiceImpl implements DepartmentService {
    @Resource
    DepartmentMapper departmentMapper;
    @Override
    public List<Department> query(DepartmentExample departmentExample) {
        // TODO Auto-generated method stub
        return departmentMapper.selectByExample(departmentExample);
    }

    @Override
    public Department query(int id) {
        // TODO Auto-generated method stub
        return departmentMapper.selectByPrimaryKey(id);
    }

    @Override
    public int add(Department department) {
        // TODO Auto-generated method stub
        return departmentMapper.insertSelective(department);
    }

    @Override
    public int update(Department department) {
        // TODO Auto-generated method stub
        return departmentMapper.updateByPrimaryKeySelective(department);
    }

    @Override
    public int del(int id) {
        // TODO Auto-generated method stub
        return departmentMapper.deleteByPrimaryKey(id);
    }

    @Override
    public long count(DepartmentExample departmentExample) {
        // TODO Auto-generated method stub
        return departmentMapper.countByExample(departmentExample);
    }

    @Override
    public List<Department> query() {
        DepartmentExample example = new DepartmentExample();
        return departmentMapper.selectByExample(example);
    }

    @Override
    public List<Department> queryid(String department) {
        DepartmentExample example = new DepartmentExample();
        example.createCriteria().andNameEqualTo(department);
        return departmentMapper.selectByExample(example);
    }

    @Override
    public Department look(Integer departmentId) {
        // TODO Auto-generated method stub
        return departmentMapper.selectByPrimaryKey(departmentId);
    }
	
}