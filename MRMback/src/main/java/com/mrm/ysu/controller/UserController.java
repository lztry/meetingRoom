package com.mrm.ysu.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.pojo.UserExample;
import com.mrm.ysu.pojo.UserExample.Criteria;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.user.UserService;
import com.mrm.ysu.util.URLCode;
import org.apache.commons.codec.digest.DigestUtils;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

@Controller
@RequestMapping("/user")
public class UserController {
	@Resource
	UserService userService;
	@Resource
	DepartmentService departmentservice;
	@RequestMapping(value="/list.do",method=RequestMethod.GET)
	public String list(User user ,ModelMap map) {
	  //查询所有的用户列表
        UserExample example = new UserExample();
        example.setOrderByClause("id desc");
        Criteria createCriteria = example.createCriteria();
        StringBuilder params=new StringBuilder();
        if(StringUtils.isNotBlank(user.getName()) ){
           
            createCriteria.andNameLike("%"+user.getName().trim()+"%").andIsDelEqualTo(1);
            params.append("&name="+URLCode.getURLEncoderString(user.getName().trim()));
           
        }
        else {
            createCriteria.andIsDelEqualTo(1);
        }
        Page<User> users = (Page<User>)userService.queryall(user,example);
        user.setUrl("list.do");
        user.setPages(users.getPages());
        user.setParams(params.toString());
        for(User userr:users) {
            Department department=departmentservice.query(userr.getDepartmentId());
            userr.setDepartment(department.getName());
            userr.setLevel(level(userr.getScale()));
        }
        //系别选项
        List<Department> departments = new ArrayList<>();
        departments = departmentservice.query();
        //级别选项
        map.addAttribute("departments", departments);
        String userli = JSONObject.toJSONString(users);
        map.addAttribute("userli", userli);
        map.addAttribute("userlist", users);
        map.addAttribute("auser",user);
        map.addAttribute("fanhui", fanhui);
        map.addAttribute("isupload",isupload);
        fanhui=0;
        isupload=0;
        return "user/list";
	}
    int fanhui=0;
	@RequestMapping(value="/list.do",method=RequestMethod.POST)
	public String adduser(User user,String name) {
		User olduser = userService.getUserByAccount(user.getAccount().trim());
		if(olduser != null) {
		    fanhui=2;
            return "redirect:list.do";
		}
        user.setPassword(DigestUtils.md5Hex(user.getAccount().trim()));
        userService.add(user);
        fanhui = 1;
		return "redirect:list.do";
	}
	@RequestMapping(value="/delete.do")
	public String deleteuser(int id) {
	    User user= new User();
        user.setId(id);
        user.setIsDel(0);
        userService.delete(user);
        fanhui = 1;
	
		return "redirect:list.do";
	}
	@RequestMapping(value="/update.do")
	public String update(User user) {
		userService.update(user);
		fanhui = 1;
		return "redirect:list.do";
	}
	@RequestMapping("/mima.do")
	public String mima(int id) {
		User user = userService.queryone(id);
		user.setPassword(DigestUtils.md5Hex(user.getAccount().trim()));
		userService.update(user);
		fanhui = 1;
		return "redirect:list.do";
	}
	int isupload=0;
	@RequestMapping("/upload.do")
	public String upload(HttpServletRequest request,MultipartFile excel,ModelMap map) {
	    List<User> errorUsers =new  ArrayList<>();
	    System.out.println(errorUsers);
		String contexPath= request.getSession().getServletContext().getRealPath("/file/");
    	//System.out.println(contexPath);
    	File file = new File(contexPath+"user.xls");
    	try {
			excel.transferTo(file);
		} catch (IllegalStateException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	try {
			Workbook workbook = Workbook.getWorkbook(file);
			Sheet sheet = workbook.getSheet(0);
			if(sheet.getRows()<3) {
			    isupload=2;
			    return "redirect:list.do";
			}
		    //System.out.println("列："+sheet.getColumns());
		    for(int i=1;i<sheet.getRows()-1;i++){
		    	User user = new User();
		    	boolean isuser=true;
		    	boolean isname=true;
		    	boolean isphone=true;
		    	boolean isdeparent=true;
	            for(int j=0;j<sheet.getColumns();j++){
	                Cell cell=sheet.getCell(j,i);
                    if(j==0) {
                        user.setAccount(cell.getContents().trim());
                        if(StringUtils.isNotBlank(cell.getContents().trim())) {
                            if(userService.getUserByAccount(cell.getContents().trim()) != null)
                                isuser=false;
                            else {
                            user.setPassword(DigestUtils.md5Hex(user.getAccount().trim()));
                            isuser=true;
                            }
                        }
                        else
                            isuser=false;
                    }
                    else if(j==1){
                        user.setName(cell.getContents().trim());
                        if(!StringUtils.isNotBlank(cell.getContents().trim()))
                            isname=false;
                    }
                    else if(j==2) {
                        user.setPhone(cell.getContents().trim());
                        if(!StringUtils.isNotBlank(cell.getContents().trim()))
                            isphone=false;
                    }
                    else if(j==3) {
                        String department = cell.getContents().trim();
                        user.setDepartment(department);
                        List<Department> departments = new ArrayList<>();
                        departments = departmentservice.queryid(department);
                        if(departments.isEmpty())
                            isdeparent=false;
                        else
                            user.setDepartmentId(departments.get(0).getId());
                    }
	            }
	            if(isuser&&isname&&isdeparent&&isphone) {
	               int ii= userService.add(user);
	               if( ii != 1) {
	                   errorUsers.add(user);
	               }
                }
	            else {
	                errorUsers.add(user);
	            }
	        }
		    workbook.close();
		} catch (BiffException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	HttpSession httpSession = request.getSession();
    	if(errorUsers.size()==0) {
    	    isupload=1;
    	    httpSession.removeAttribute("errorUsers");
    	}
    	else {
    	    httpSession.setAttribute("errorUsers", JSONObject.toJSON(errorUsers));
    	    isupload=2;
    	}
		return "redirect:list.do";
	}
	public String level(int id) {
		String level="";
		if(id==1)
		{
			level = "初级";
		}
		else if(id==2){
			level = "中级";
		}
		else if(id==3) {
			level = "高级";
		}
		else {	
		    level="管理员";
		}
		return level;
	}
	@RequestMapping("/login.do")
    public String login() {
        return "user/login";
    }
    @RequestMapping("/forgetPwd.do")
    public String forgetPwd() {
        return "user/forgetPwd";
    }
    @RequestMapping(value="/logincheck.do",method=RequestMethod.GET)
    public String goindex(String username,String password,HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserExample userExample = new UserExample();
        userExample.createCriteria().andAccountEqualTo(username).andPasswordEqualTo(password);
        List<User> userList = userService.queryCondication(userExample);
        if(userList.size() != 0)
            session.setAttribute("islogin", userList.get(0)); 
        return "redirect:/index.do";
    }
    @RequestMapping(value="/logincheck.do",method=RequestMethod.POST)
    @ResponseBody
    public JSONObject logincheck(String username,String password,HttpServletRequest request) {
        User user=new User();
        JSONObject json=new JSONObject();
        user=userService.getUserByAccount(username);
       // System.out.println("---------------------");
        if(user==null) {
            json.put("result", 0);
            return json;
        }
        if(user.getPassword().equals(password)) {
            System.out.println(user.getPassword());
          
            if(user.getScale()==4) {
                json.put("result", 1);
                json.put("pwd", user.getPassword());
                HttpSession session = request.getSession();
                //session.setMaxInactiveInterval(30 * 60);
                session.setAttribute("islogin", user);
            }
            else
                json.put("result", 0);
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
    
    @RequestMapping("/logoff.do")
    public String logoff(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.removeAttribute("islogin");
        String requestUrl =request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/MRMfront/user/login.do";//获取WEB服务器的主机名.toString();//得到请求的URL地址
        return "redirect:"+requestUrl;
        
    }
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
    
    @RequestMapping("/prelogin.do")
    public String prelogin() {
        return "user/prelogin";
    }
}
