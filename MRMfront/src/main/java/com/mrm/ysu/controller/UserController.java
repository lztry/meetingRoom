package com.mrm.ysu.controller;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.PageUtils;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.message.MessageService;
import com.mrm.ysu.service.user.UserService;

@Controller
@RequestMapping("/user")
public class UserController {
	@Resource
	UserService userService;
	@Resource
	DepartmentService departmentservice;
	@Resource
    AppointService appointService;
	@Resource
	MessageService messageService;
	@RequestMapping("/login.do")
    public String login() {
        return "login/login";
    }
	@RequestMapping("/prelogin.do")
    public String prelogin() {
        return "login/prelogin";
    }

    @RequestMapping("/forgetPwd.do")
    public String forgetPwd() {
        return "user/forgetPwd";
    }
    @RequestMapping(value="/logincheck.do",method=RequestMethod.POST)
    @ResponseBody
    public JSONObject logincheck(String username,String password,HttpServletRequest request) {
        User user=new User();
        JSONObject json=new JSONObject();
        //结果为 0 用户名密码不正确 结果为  -1 普通用户 结果为 其他管理员用户
        user=userService.getUserByAccount(username);
        if(user==null) {
            json.put("result", 0);
            return json;
        }
        if(user.getPassword().equals(password)) {
            if(user.getScale()<4) {
              //  System.out.println(user.getPassword());
                HttpSession session = request.getSession();
                session.setAttribute("islogin", user);
                json.put("result", -1);
                json.put("pwd", user.getPassword());
            }
            else {
                json.put("result", user.getId());
            }
        }
        else
            json.put("result", 0);
        return json;
    }
    
    @RequestMapping(value="/forgetEdit.do",method=RequestMethod.POST)
    @ResponseBody
    public int forgetEdit(User user) {
        System.out.println(user.toString());
        User olduser=new User();
        olduser=userService.getUserByAccount(user.getAccount());
        if(olduser.getName().equals(user.getName())&&olduser.getPhone().equals(user.getPhone())) {
          
          return userService.update(user);
        }
        else return -1;
    }
    
    
  
    @RequestMapping("/appoint.do")
    public String goAppoint() {
        return "user/appoint";
    }
    @RequestMapping("/suappoint.do")
    public String suAppoint() {
        return "user/suappoint";
    }
    @RequestMapping("/reappoint.do")
    public String reAppoint() {
        return "user/reappoint";
    }
    @RequestMapping("/check.do")
    public String checkAppoint() {
        return "user/check";
    }
    @RequestMapping("/cancel.do")
    public String cancelAppoint() {
        return "user/cancel";
    }
  
    @RequestMapping("/queryappoint.do")
    @ResponseBody
    public PageUtils<Appoint> queryappoint(Appoint appoint,HttpServletRequest request) {
       appoint.setPageSize(8);
       if(StringUtils.isNotBlank(appoint.getRoomName())) {
           appoint.setRoomName("%"+appoint.getRoomName()+"%");
       }
       PageUtils<Appoint> result = new PageUtils<>();
       com.github.pagehelper.Page<Appoint>appointList= (com.github.pagehelper.Page<Appoint>)appointService.userQuery(appoint);
       if(appoint.getState() != null && appoint.getState() ==2 ) {
           HttpSession session =  request.getSession();
           User user=(User)session.getAttribute("islogin");
           List<Message> msgs = messageService.queryMessageByUserId(user.getId());
         
           for(Appoint app : appointList) {
               for(Message msg :msgs) {
                   if(msg.getAppointId().intValue()==app.getId().intValue()) {
                       app.setMessage(msg.getContent());
                       break;
                   }
               }
           }
       }
       appoint.setPages(appointList.getPages());
       result.setPage(appoint);
       result.setResultList(appointList);
       return result;
    }
    @RequestMapping("/delappoints.do")
    @ResponseBody
    public String delAppoints(@RequestParam(value = "checkArr[]")  Integer[]  ids) {
        if(ids.length!=0) {
            for(int id : ids)
             appointService.userDel(id);
            return "1";
        }
        else
            return "0";
    }
    @RequestMapping("/delappoint.do")
    @ResponseBody
    public String delAppoint(int id) {
        
        if(appointService.userDel(id)==1) {
            return "1";
        }
       return "0";
    }
    @RequestMapping("/loginoff.do")
    public String logoff(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.removeAttribute("islogin");
        return "redirect:prelogin.do";
    }
}
