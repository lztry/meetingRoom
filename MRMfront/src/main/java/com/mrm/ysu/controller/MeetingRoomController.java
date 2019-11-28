package com.mrm.ysu.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.Department;
import com.mrm.ysu.pojo.IndexPageState;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.PageUtils;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.room.MeetingRoomService;


@Controller
@RequestMapping("/room")
public class MeetingRoomController {
    @Resource
    MeetingRoomService meetingRoomService;
	
    @Resource
    DepartmentService departmentService;
    @Resource
    AppointService appointService;
    @RequestMapping("/timeappoint.do") 
    public String goTimeAppoint() {
        return "appoint/timeappoint";
    }
    @RequestMapping("/roomappoint.do") 
    public String goRoomAppoint() {
        return "appoint/roomappoint";
    }
	//按照条件检索会议室  响应ajax请求
	@RequestMapping("/find.do")	
	@ResponseBody
	public PageUtils<MeetingRoom> find(QueryRoom queryRoom){ // System.out.println(user.getScale());
	    //系别选项
	    //改用map降低复杂度
	    queryRoom.setPageSize(8);
	    List<MeetingRoom> roomList= meetingRoomService.findUsable(queryRoom);
        if(roomList.size()!=0) {
            List<Department> departments = departmentService.query();
            int i=0;
            int[] roomIdarr=new int[roomList.size()];
    	    for(MeetingRoom room : roomList) {
    	        roomIdarr[i++] = room.getId();
    	        for(Department department:departments) {
    	            if(department.getId()==room.getDepartmentId()) {
    	                room.setDepartmentname(department.getName());
    	                break;
    	            }
    	        }
    	       
    	    }
    	   if(StringUtils.isNotBlank(queryRoom.getAppointTime())) {
        	    queryRoom.setRoomList(roomIdarr);
        	    Map<Integer,Object> map= appointService.queryTimeConflict(queryRoom);
        	    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        	    Date appointTime = null;
                try {
                    appointTime = sdf.parse(queryRoom.getAppointTime());
                } catch (ParseException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
        	    for(MeetingRoom room : roomList) {
        	        
        	        if (map.get(room.getId())!=null) {
        	            room.setRoomState(0);
        	            Map<String,String> mymap = (Map<String,String>)map.get(room.getId());
        	            room.setRealName(mymap.get("real_name"));
        	        }
        	        else {
        	           
        	            Calendar latestTime = Calendar.getInstance();
        	            latestTime.setTime(new Date());
        	            latestTime.add(Calendar.DAY_OF_YEAR,room.getAheadTime());
        	            Date lt = latestTime.getTime();    
        	           // System.out.println(lt);
        	           // System.out.println(appointTime);
        	            if(lt.before(appointTime)) {
        	                room.setRoomState(2);
        	            }
        	        }
        	    }
            }
        }
        com.github.pagehelper.Page<MeetingRoom>outRoomList=(com.github.pagehelper.Page<MeetingRoom>)roomList;
        PageUtils<MeetingRoom> result = new PageUtils<>();
        queryRoom.setPages(outRoomList.getPages());
        result.setPage(queryRoom);
        result.setResultList(roomList);
	    return result;
	}
	@RequestMapping("/findusable.do")    
    @ResponseBody
    public PageUtils<MeetingRoom> findusable(QueryRoom queryRoom){
	    queryRoom.setPageSize(8);
	    if(StringUtils.isNotBlank(queryRoom.getLocation())) {
	        queryRoom.setLocation("%"+queryRoom.getLocation()+"%");
	    }
	    List<MeetingRoom> roomList =  meetingRoomService.find(queryRoom);
	    PageUtils<MeetingRoom> result = new PageUtils<>();
	    if(roomList.size()!=0) {
            List<Department> departments = departmentService.query();
    	    for(MeetingRoom room : roomList) {
                for(Department department:departments) {
                    if(department.getId()==room.getDepartmentId()) {
                        room.setDepartmentname(department.getName());
                        break;
                    }
                }
            }
    	   
	    }
	    com.github.pagehelper.Page<MeetingRoom>outRoomList=(com.github.pagehelper.Page<MeetingRoom>)roomList;
        
        queryRoom.setPages(outRoomList.getPages());
        result.setPage(queryRoom);
        result.setResultList(roomList);
        return result;
	}
	 
}
