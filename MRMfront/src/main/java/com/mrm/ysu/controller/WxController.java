package com.mrm.ysu.controller;

import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.MonthCountStatic;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.pojo.RoomCountStatic;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.room.MeetingRoomService;
import com.mrm.ysu.service.single.SingleService;
import com.mrm.ysu.service.user.UserService;
@RequestMapping("/wx")
@Controller
public class WxController {
    @Resource
    SingleService singleservice;
    @Resource
    UserService userService;
    @Resource
    DepartmentService departmentservice;
    @Resource
    MeetingRoomService meetingRoomService;
    @Resource
    AppointService appointService;
    @RequestMapping(value="/logincheck.do",method=RequestMethod.POST)
    @ResponseBody
    public JSONObject logincheck(String username,String password,HttpServletRequest request) {
        User user=new User();
        JSONObject json=new JSONObject();
        //结果为 0 用户名密码不正确 结果为  1正确登录
        user=userService.getUserByAccount(username);
        if(user==null) {
            json.put("result", 0);
            return json;
        }
        if(user.getPassword().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("islogin", user);
            JSONObject userJson =new JSONObject();
            userJson.put("id", user.getId());
            userJson.put("departmentId", user.getDepartmentId());
            userJson.put("name", user.getName());
            userJson.put("phone", user.getPhone());
            userJson.put("wxOpenId", user.getWxOpenId());
            userJson.put("scale", user.getScale());
            json.put("userEssential", userJson);
            json.put("user", JSONObject.toJSONString(user));
            json.put("result", 1);
        }
        else
            json.put("result", 0);
        return json;
    }
    @RequestMapping(value="/department.do",method=RequestMethod.GET)
    @ResponseBody
    public Department department(int id) {
        return departmentservice.query(id);
    }
    //通过用户名和系别查询会议室
    @RequestMapping(value="/room.do",method=RequestMethod.POST)
    @ResponseBody
    public List<MeetingRoom> room(QueryRoom queryRoom) {
        System.out.println(queryRoom);
        queryRoom.setWithPage(0);//取消分页
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        List<MeetingRoom> roomList= meetingRoomService.find(queryRoom);
        List<Department> departmentList = departmentservice.query();
        for(MeetingRoom room : roomList) {
            //查询某会议室某天的预约个数
            AppointExample appointExample = new AppointExample();
            try {
                appointExample.createCriteria().andStateLessThanOrEqualTo(1).andRoomIdEqualTo(room.getId()).andAppointTimeEqualTo(sdf.parse(queryRoom.getAppointTime()));
            } catch (ParseException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            for(Department department : departmentList) {
                if(room.getDepartmentId()==department.getId()) {
                    room.setDepartmentName(department.getName());
                    break;
                }
            }
            //获取会议室 门牌号 比如 101
            String roomName=room.getName();
            int i=roomName.length()-1;
            for(;i>=0;i--) {
               if(roomName.charAt(i)>'z'||roomName.charAt(i)<'0')
                   break;
            }
            room.setRoomNum(roomName.substring(i+1));
            room.setAppointNum( (int)appointService.count(appointExample));
        }
        return roomList;
    }
    @RequestMapping("/display.do")
    @ResponseBody
    public List<Appoint> single(Integer roomid,String queryDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        List<Appoint> appoints = new ArrayList<>();
        AppointExample aExample = new AppointExample();
        try {
            aExample.createCriteria().andRoomIdEqualTo(roomid).andStateLessThanOrEqualTo(1).andAppointTimeEqualTo(sdf.parse(queryDate));
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        appoints = singleservice.queryall(aExample);
        return appoints;
    }
    @RequestMapping("/appoint.do")
    @ResponseBody
    public  String appoint(Appoint appoint,int isCheck) {
      //  System.out.println(appoint.toString());
        appoint.setSubmitTime(new Date());
        //二次验证
        AppointExample example = new AppointExample();
        example.createCriteria().andAppointTimeEqualTo(appoint.getAppointTime()).andStateEqualTo(1).andRoomIdEqualTo(appoint.getRoomId());
        List<Appoint> appoints = appointService.query(example);
        int start = appoint.getAppointStart();
        int end = appoint.getAppointEnd();
        if(appoints!=null) {
            for(Appoint appoint2:appoints) {
                if(start<appoint2.getAppointEnd()&&start>appoint2.getAppointStart()) {
                    return "0";
                }
                else if(end<appoint2.getAppointEnd()&&end>appoint2.getAppointStart()) {
                    return "0";
                }
                else if(start<=appoint2.getAppointStart()&&end>=appoint2.getAppointEnd()) {
                    return "0";
                }
            }
         }
        if(isCheck == 1) {
            appoint.setState(0);
        }
        else {
            appoint.setState(1);
            appoint.setDealTime(new Date());
        }
       return(String.valueOf(appointService.add(appoint)));
    }
    
    @RequestMapping("/cancelAppoint.do")
    @ResponseBody
    public int cancelAppoint(int appointId) {
        Appoint appoint = new Appoint();
        appoint.setId(appointId);
        appoint.setState(3);
        return appointService.update(appoint);
    }
    @RequestMapping("/queryappoint.do")
    @ResponseBody
    public  MultiValueMap<String, Appoint> queryappoint(Appoint appoint) {
      // AppointExample appointExample = new AppointExample();
      // appointExample.createCriteria().andUserIdEqualTo(appoint.getUserId()).andIsDelEqualTo(0).andStateEqualTo(1).andAppointTimeGreaterThanOrEqualTo(new Date());
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        MultiValueMap<String, Appoint> appointMap =  new LinkedMultiValueMap<>();
        List<MeetingRoom> roomList= meetingRoomService.query(new MeetingRoomExample());
        List<Appoint> appointList =  appointService.selectRemind(appoint);
        for (Appoint appointParam : appointList) {
            appointMap.add(sdf.format(appointParam.getAppointTime()), appointParam);
            for(MeetingRoom room : roomList) {
                if(appointParam.getRoomId() == room.getId()) {
                    appointParam.setRoomName(room.getName());
                    break;
                }
            }
        }
        return appointMap;
    }
    @RequestMapping("/roomStatis.do")
    @ResponseBody
    public List<RoomCountStatic> roomStatis(int userId) {
        return appointService.roomStatics(userId);
    }
    @RequestMapping("/countNum.do")
    @ResponseBody
    public List<MonthCountStatic> countStatics(int userId) {
        return appointService.countStatics(userId);
    } 
    private String getSha1(String str)  {
        if (null == str || str.length() == 0){
            return null;
        }
        char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'a', 'b', 'c', 'd', 'e', 'f'};
        try {
            MessageDigest mdTemp = MessageDigest.getInstance("SHA1");
            mdTemp.update(str.getBytes("UTF-8"));

            byte[] md = mdTemp.digest();
            int j = md.length;
            char[] buf = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                buf[k++] = hexDigits[byte0 >>> 4 & 0xf];
                buf[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(buf);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    private boolean checkSignature(String signature, String timestamp, String nonce) { 
      //TOKEN
        //与token 比较
        String[] arr = new String[] { "ysuisemrm20190601", timestamp, nonce };
       //将token、timestamp、nonce三个参数进行字典排序
        Arrays.sort(arr);
      //将token、timestamp、nonce拼接进行是sha1加密
        StringBuilder content = new StringBuilder();
        for(int i=0 ;i<arr.length;i++)
            content.append(arr[i]);
        String sha1Result = getSha1(content.toString());
        return sha1Result != null ? sha1Result.equals(signature) : false;  
       
        
    }
    @RequestMapping("/getProcessRequest.do")
    @ResponseBody
    public String processRequest(String signature, String timestamp, String nonce,String echostr) {
        if(checkSignature(signature, timestamp, nonce))
            return echostr;
        else 
            return null;            
    }
    @RequestMapping("/updateuser.do")
    @ResponseBody
    public int updateUser(User user) {
        return userService.update(user);        
    }
}
