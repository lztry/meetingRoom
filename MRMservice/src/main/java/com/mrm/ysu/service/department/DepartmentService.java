package com.mrm.ysu.service.department;

import java.util.List;

import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.DepartmentExample;



public interface DepartmentService {
	List<Department> query(DepartmentExample departmentExample);
	Department query(int id);
	int add(Department department);
	int update(Department department);
	int del(int id);
	long count(DepartmentExample departmentExample);
	List<Department> query(); //查全部的系别
    public List<Department> queryid(String department);
    Department look(Integer departmentId);
   
}