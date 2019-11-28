package com.mrm.ysu.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.service.department.DepartmentService;


/**  

* <p>Title: DepartmentController.java</p>  

* <p>Description: 系别Controller层</p>  
 
* @author Dingxuesong  

* @date 2018年8月29日  

* @version 1.0  

*/
@Controller
@RequestMapping("/department")
public class DepartmentController {

    @Resource
    DepartmentService departmentService;
    
    @RequestMapping("/department.do")
    public String department() {
        return "department/department";
    }
    @RequestMapping("/list.do")
    @ResponseBody
    public List<Department> list(){
    return departmentService.query();
    }
    
    @RequestMapping("/add.do")
    @ResponseBody
    public int add(Department department) {
        return departmentService.add(department);
    }
    
    @RequestMapping("/update.do")
    @ResponseBody
    public int update(Department department) {
        return departmentService.update(department);
    }
    
    @RequestMapping("/del.do")
    @ResponseBody
    public int del(int id) {
        return departmentService.del(id);
    }
}
