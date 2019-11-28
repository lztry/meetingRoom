     package com.mrm.ysu.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.catalina.connector.Request;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.user.UserService;



/**  

* <p>Title: PersonalInfoController.java</p>  

* <p>Description: 用户个人信息维护</p>  
 
* @author Dingxuesong  

* @date 2018年9月7日  

* @version 1.0  

*/
@Controller
@RequestMapping("/user")
public class PersonalInfoController {
    @Resource
    DepartmentService departmentService;
    @Resource
    UserService userService;
    @RequestMapping("/password.do")
    public String password() {       
        return "user/password";
    }
    
    @RequestMapping("updatepwd.do")
    @ResponseBody
    public int updatepwd(HttpServletRequest request, String oldpwd,String newpwd) {
        HttpSession session=request.getSession();
        User user =(User)session.getAttribute("islogin");
   
        if(!user.getPassword().equals(oldpwd)) {
            return 0;
        }
        else {
            user.setPassword(newpwd);
            userService.update(user);
            session.removeAttribute("islogin");
            return 1;
        } 
    }
    //个人信息
    @RequestMapping(value = "/person.do",method=RequestMethod.GET )
    public String person(HttpServletRequest request) {
        HttpSession session= request.getSession();
        User user=(User)session.getAttribute("islogin");
        user.setDepartment(departmentService.look(user.getDepartmentId()).getName());
        session.setAttribute("islogin",user);
        return "user/person";
    }
    @RequestMapping(value = "/person.do",method=RequestMethod.POST )
    public String updateinfo(String realname,String phone,HttpServletRequest request) {
        HttpSession session= request.getSession();
        User user= (User)session.getAttribute("islogin");
        user.setName(realname);
        user.setPhone(phone);
        session.setAttribute("islogin", user);
        userService.update(user);
        return  "redirect:person.do";
    }
}
