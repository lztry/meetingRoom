package com.mrm.ysu.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.DepartmentExample;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.MrmArea;
import com.mrm.ysu.pojo.MrmAreaExample;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.area.IareaService;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.room.MeetingRoomService;
import com.mrm.ysu.util.URLCode;


@Controller
@RequestMapping("/room")
public class MeetingRoomController {
    @Resource
    MeetingRoomService meetingRoomService;
	@Resource
	IareaService areaService;
    @Resource
    DepartmentService departmentService;
    @Resource
    AppointService appointService;
   
    @RequestMapping("/meetingRoom.do")
    public String golist(ModelMap map,QueryRoom queryRoom) {
        if(StringUtils.isNotBlank(queryRoom.getLocation())) {
            queryRoom.setParams("&location="+URLCode.getURLEncoderString(queryRoom.getLocation().trim()));
            queryRoom.setSearchWay(queryRoom.getLocation());
            queryRoom.setLocation("%"+queryRoom.getLocation().trim()+"%");
        }
        Page<MeetingRoom> meetingRoomList=(Page<MeetingRoom>) meetingRoomService.findUsable(queryRoom);
        DepartmentExample example =new DepartmentExample();
        List<Department> departmentList =departmentService.query(example);
        if(meetingRoomList.size()!=0) {
            for(MeetingRoom meetingRoom : meetingRoomList) {
                for(Department department : departmentList) {
                    if(meetingRoom.getDepartmentId() == department.getId()) {
                        meetingRoom.setDepartmentname(department.getName());
                        break;
                    }
                }
                
            }
        }
        queryRoom.setPages(meetingRoomList.getPages());
        queryRoom.setUrl("meetingRoom.do");
        map.addAttribute("meetingRoomList",JSONObject.toJSON(meetingRoomList));
        map.addAttribute("page", queryRoom);
        map.addAttribute("departmentList",JSONObject.toJSON(departmentList));
        //System.out.println(meetingRoomList.toString());
        return "room/meetingRoom";
    }
    
    @RequestMapping("/edit.do")
    public String edit(MeetingRoom meetingRoom) {
        meetingRoomService.update(meetingRoom);
        return "redirect:meetingRoom.do";
    }
    //是否重名 0没有重名 1重名
    @RequestMapping("/existRoom.do")
    @ResponseBody
    public int existRoom(String name) {
        MeetingRoomExample meetingRoomExample = new MeetingRoomExample();
        meetingRoomExample.createCriteria().andNameEqualTo(name);
        List<MeetingRoom>roomList  = meetingRoomService.query(meetingRoomExample);
        System.out.println(roomList);
        if(roomList == null||roomList.size()==0)
           return 0;
        else
           return 1;
    }
    
    @RequestMapping("/add.do")
    public String add(MeetingRoom meetingRoom,String selectedtb,String name1) {
        meetingRoomService.add(meetingRoom);
        return "redirect:meetingRoom.do";
    }
    //删除会议室之前检测是否有预约  0代表有预约或者存在未审核消息， 1代表可以删除
    @RequestMapping("preDel.do")
    @ResponseBody
    public int preDel(int id) {
        AppointExample appointExample = new AppointExample();
        appointExample.createCriteria().andRoomIdEqualTo(id);
        List<Appoint> appointList = appointService.query(appointExample, null);
        Date currentTime = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        Calendar rightNow = Calendar.getInstance();
        for(Appoint appoint : appointList) {
            rightNow.setTime(appoint.getAppointTime());
            rightNow.add(Calendar.HOUR,appoint.getAppointEnd());
           // System.out.println(sdf.format(rightNow.getTime()));
            if(appoint.getState()<2 && (rightNow.getTime().getTime()>currentTime.getTime() )) {
                return 0;
            }
        }
        return 1;
    }
    
    @RequestMapping("/del.do")
    public String del(int id) {
        MeetingRoom meetingRoom =meetingRoomService.look(id);
        meetingRoom.setIsDel(0);
        meetingRoomService.update(meetingRoom);
        return "redirect:meetingRoom.do";
    }
    @RequestMapping("/queryroom.do")
    public String queryroom() {
        return "room/queryroom";
    }
	//按照条件检索会议室  响应ajax请求
	@RequestMapping("/find.do")	
	@ResponseBody
	public List<MeetingRoom> find(QueryRoom queryRoom){
	    List<Department> departments = departmentService.query();
        List<MeetingRoom> roomList= meetingRoomService.find(queryRoom);
        for(MeetingRoom room : roomList) {
            for(Department department:departments) {
                if(department.getId()==room.getDepartmentId()) {
                    room.setDepartmentname(department.getName());
                    break;
                }
            }
        }
        return roomList;
	}
}
