package com.mrm.ysu.controller;


import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.PageUtils;
import com.mrm.ysu.pojo.QueryContra;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.pojo.UserExample;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.message.MessageService;
import com.mrm.ysu.service.room.MeetingRoomService;
import com.mrm.ysu.service.user.UserService;

@Controller
@RequestMapping("/appoint")
public class AppointController {
    @Resource
    MeetingRoomService roomService;
	@Resource
	AppointService appointService; 
	@Resource
    MessageService messageService;
    @Resource
    UserService userService;
	@RequestMapping("/list.do")
	@ResponseBody
	public List<Appoint> list(){
	    AppointExample appointExample = new AppointExample();
        appointExample.createCriteria().andStateEqualTo(0).andAppointTimeGreaterThanOrEqualTo(new Date());
        appointExample.setOrderByClause("submit_time");
        return  appointService.query(appointExample);
	}
	@RequestMapping("/count.do")
    @ResponseBody
    public long count(){
	    AppointExample appointExample = new AppointExample();
        appointExample.createCriteria().andStateEqualTo(0);
	    return appointService.count(appointExample);
    }
	//进入审核界面
	@RequestMapping("/check.do")
	public String enterCheck() {
	    return "appoint/check";
	}
	//查询冲突
	
	@RequestMapping("/queryContra.do")
	@ResponseBody
	public List<Appoint> queryContra(@RequestBody Appoint appoint,HttpServletRequest request){
	    Appoint appoint1 = appointService.queryone(appoint.getId());
	    if(appoint1.getState() != 0) {
            return new ArrayList<Appoint>();
        }
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        //为查询冲突赋值
        QueryContra contra = new QueryContra(formatter.format(appoint.getAppointTime()),appoint.getAppointStart(),appoint.getAppointEnd(),appoint.getRoomId());
        HttpSession session = request.getSession();
        List<Appoint> contraList= appointService.queryContra(contra);
        session.setAttribute("contra", contraList);
        return contraList;
	}
	//冲突通过
	@RequestMapping("/contrapass.do")
	public String contraPass(int id,int userid, HttpServletRequest request) throws IOException {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    HttpSession session = request.getSession();
	    List<Appoint> contraList =(List<Appoint>) session.getAttribute("contra");
	    session.removeAttribute("contra");
	    String passAccount=userService.queryone(userid).getAccount();
	    for(Appoint appoint: contraList) {
	        Message message = new Message();
	        if(appoint.getId().intValue() == id ) {
	            if(appoint.getState() ==0) {
    	            MeetingRoom meetingRoom= roomService.look(appoint.getRoomId());
    	            appoint.setState(1);
    	            appoint.setDealTime(new Date());
    	            appointService.update(appoint);
    	            message.setContent("审核通过");
    	            message.setState(1);
    	            message.setAppointId(appoint.getId());
    	            message.setCreateTime(new Date());
    	            message.setSituation(meetingRoom.getName());
    	            message.setUserId(appoint.getUserId());
    	            WebSocketController.pass(passAccount,JSONObject.toJSONString(message));
    	            String []params = new String[] {meetingRoom.getName(),
                            dateFormat.format(appoint.getAppointTime()),
                            appoint.getAppointStart()+":00~"+appoint.getAppointEnd()+":00"};
    	            appointService.appointSuccess(params,appoint.getUserId());
	            }
	        }else {
	            if(appoint.getState().intValue() == 0) {
    	            MeetingRoom meetingRoom= roomService.look(appoint.getRoomId());
    	            appoint.setState(2);
    	            appoint.setDealTime(new Date());
    	            appointService.update(appoint);
    	            message.setContent("时间冲突");
    	            message.setCreateTime(new Date());
                    message.setState(2);
                    message.setAppointId(appoint.getId());
                    message.setUserId(appoint.getUserId());
                    message.setSituation(meetingRoom.getName());
                    String account=userService.queryone( appoint.getUserId()).getAccount();
                    WebSocketController.reject(account,JSONObject.toJSONString(message));
                    appoint.setRoomName(meetingRoom.getName());
                    appointService.appointFail(appoint, "时间冲突");
	            }
	        }
	        messageService.add(message); 
	    }
	    return "redirect:goIndex.do";
	}
	@RequestMapping("/goIndex.do")
	public String goindex() {
	    return "appoint/preindex";
	}
	//审核通过
    @RequestMapping("/pass.do")
    public String pass (int id,int userId,String name) throws IOException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String account=userService.queryone(userId).getAccount();
        Appoint appoint1 = appointService.queryone(id);
        if(appoint1.getState().intValue() ==0) {
          //添加message
            Message message = new Message();
            message.setUserId(userId);
            message.setSituation(name);
            message.setContent("审核通过");
            message.setState(1);
            message.setCreateTime(new Date());
            message.setAppointId(id);
            messageService.add(message);
            Appoint appoint = new Appoint();
            appoint.setId(id);
            appoint.setState(1);
            appoint.setDealTime(new Date());
            WebSocketController.pass(account,JSONObject.toJSONString(message));
            String []params = new String[] {name,dateFormat.format(appoint1.getAppointTime()),
                    appoint1.getAppointStart()+":00~"+appoint1.getAppointEnd()+":00"};
            appointService.appointSuccess(params,userId);
            appointService.update(appoint);
        }
       
        return "redirect:/appoint/check.do";
    }
    
    //审核驳回
    @RequestMapping("/reject.do")
    @ResponseBody
    public String reject(int id,int userId,String reason,String name){
        String account=userService.queryone(userId).getAccount();
        Appoint appoint1 = appointService.queryone(id);
        if(appoint1.getState() ==0) {
            //添加message
            System.out.println("appoint id"+id);
            Message message = new Message();
            message.setUserId(userId);
            message.setContent(reason);
            message.setState(2);
            message.setCreateTime(new Date());
            message.setSituation(name);
            message.setAppointId(id);
            messageService.add(message);
            appoint1.setRoomName(name);
            //更新预约记录
            Appoint appoint = new Appoint();
            appoint.setId(id);
            appoint.setState(2);
            appoint.setDealTime(new Date());
            appoint1.setDealTime(new Date());
            appointService.update(appoint);
          
            //通过websocket向前台传输信息
            try {
                WebSocketController.reject(account,JSONObject.toJSONString(message));
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            appointService.appointFail(appoint1, reason);
    
        }
        return "redirect:/index.do";
    }
    
	@RequestMapping("/record.do")
	public String record() {
	    return "appoint/appoint";
	}
	@RequestMapping("/queryRecord.do")
    @ResponseBody
    public PageUtils<Appoint> queryRecord(Page page){
	    page.setPageSize(8);
	    AppointExample appointExample = new AppointExample();
	    UserExample userExample = new UserExample();
	    MeetingRoomExample roomExample = new MeetingRoomExample();
	    appointExample.setOrderByClause("submit_time desc");
	    List<User> users = null;
	    List<MeetingRoom> rooms =null;
	    if(StringUtils.isNotBlank(page.getParams())) {
	        if(page.getSearchWay().equals("1")) {
	            userExample.createCriteria().andNameLike("%"+page.getParams()+"%");
	            users= userService.queryall(userExample);
	            if(users.isEmpty()) {
	                return new PageUtils<Appoint>();
	            }
	            List<Integer> userIdList = new ArrayList<>();
	            for(User user : users ) {
	                userIdList.add(user.getId());
	            }
	            appointExample.createCriteria().andStateNotEqualTo(0).andUserIdIn(userIdList);
	        }
	        else {
	            roomExample.createCriteria().andNameLike("%"+page.getParams()+"%");
	            rooms = roomService.query(roomExample);
	            if(rooms.isEmpty()) {
	                return new PageUtils<Appoint>();
	            }
	            List<Integer> roomIdList = new ArrayList<>();
	            for(MeetingRoom room : rooms) {
	                roomIdList.add(room.getId());
	            }
	            appointExample.createCriteria().andStateNotEqualTo(0).andRoomIdIn(roomIdList);
	        }
	          
	    }
	    else
	        appointExample.createCriteria().andStateNotEqualTo(0);
        com.github.pagehelper.Page<Appoint> appointList=(com.github.pagehelper.Page) appointService.query(appointExample,page);
        page.setPages(appointList.getPages());
	    if(appointList.getPages() !=0 ) {
    	    if(users == null)
    	        users= userService.queryall(new UserExample());
    	    if(rooms == null)
    	        rooms = roomService.query(new MeetingRoomExample());
    	    for(Appoint appoint : appointList) {
                for(User user : users) {
                    if(user.getId().intValue() == appoint.getUserId().intValue()) {
                        appoint.setUser(user);
                        break;
                    }
                }
                for(MeetingRoom room : rooms ) {
                    if(room.getId().intValue() == appoint.getRoomId().intValue()) {
                        appoint.setMeetingRoom(room);;
                        break;
                    }
                }
            }
	    }
	    
	    PageUtils<Appoint> result= new PageUtils<>();
	    result.setPage(page);
	    result.setResultList(appointList);
	    return result;
	}
	//删除预约记录
	@RequestMapping("/delRecord.do")
	public String delRecord (int id) {
	    appointService.adminDel(id);
	    return "redirect:record.do";
	}
	//进入个人预约界面
	@RequestMapping(value = "/selfappoint.do",method=RequestMethod.GET)
	public String selfApppoint() {
	    return "user/selfappoint";
	}
	@ResponseBody
	@RequestMapping(value = "/selfappoint.do",method=RequestMethod.POST)
    public List<Appoint> selfApppoint(int id) {
	    AppointExample appointExample = new AppointExample();
        appointExample.setOrderByClause("submit_time desc");
        List<MeetingRoom> rooms =null;
        //获取当前日期
        Date current = new Date();
        //转化为当前年月日
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      
        try {
            appointExample.createCriteria().andStateEqualTo(1).andUserIdEqualTo(id).andAppointTimeGreaterThanOrEqualTo( sdf.parse(sdf.format(current)));
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        rooms = roomService.query(new MeetingRoomExample());
        List<Appoint> appointList = appointService.query(appointExample,null);
        for(Appoint appoint : appointList) {
            for(MeetingRoom room : rooms ) {
                if(room.getId().intValue() == appoint.getRoomId().intValue()) {
                    appoint.setMeetingRoom(room);
                    break;
                }
            }
        }
        return appointList;
    }
	//取消预约
	@RequestMapping("/cancelAppoint.do")
    @ResponseBody
    public int cancelAppoint(int aid) {
        Appoint appoint = new Appoint();
        appoint.setId(aid);
        appoint.setState(3);
        appointService.update(appoint);
        return aid;
    }
    @RequestMapping("appoint.do")
    @ResponseBody
    public  String appoint(Appoint appoint,int isCheck) {
        appoint.setSubmitTime(new Date());
        //二次验证
        //管理员无需审核 
       appoint.setState(1);
       return(String.valueOf(appointService.add(appoint)));
    }
    //每隔一个小时 检查预约处理过期请求
   // @Scheduled(cron="0 0 5-22 * * ?")
    @Scheduled(cron="1 * 5-22 * * ?")
    public void dealOutDate() {
       appointService.dealOutDate();
       appointService.meetingRemind();
    }
}

