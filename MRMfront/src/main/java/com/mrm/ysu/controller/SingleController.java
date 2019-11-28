package com.mrm.ysu.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.service.room.MeetingRoomService;
import com.mrm.ysu.service.single.SingleService;

@Controller
@RequestMapping("/single")
public class SingleController {
	@Resource
	SingleService singleservice;
	@Resource
	MeetingRoomService meetingroomservice;
	@RequestMapping("/calendar.do")
	public String calendar(Integer roomid,ModelMap map) {
		MeetingRoom meetingRoom = meetingroomservice.look(roomid);
		map.addAttribute("room",meetingRoom);
		return "/single/calendar";
	}
	
	@RequestMapping("/display.do")
	@ResponseBody
	public List<Appoint> single(Integer roomid,String queryStart,String queryEnd) {
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    List<Appoint> appoints = new ArrayList<>();
		AppointExample aExample = new AppointExample();
		try {
            aExample.createCriteria().andRoomIdEqualTo(roomid).andStateLessThanOrEqualTo(1).andAppointTimeBetween(sdf.parse(queryStart), sdf.parse(queryEnd));
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
		appoints = singleservice.queryall(aExample);
		return appoints;
	}
	@RequestMapping("/check.do")
    @ResponseBody
    public String check(String riqi,Integer kaishi,Integer jieshu,Integer roomid) {
        List<Appoint> appoints = new ArrayList<>();
        AppointExample aExample = new AppointExample();
        aExample.createCriteria().andRoomIdEqualTo(roomid).andStateEqualTo(0);
        appoints = singleservice.queryall(aExample);
        for(Appoint appoint :appoints) {
            String Time = new SimpleDateFormat("YYYY-MM-dd").format(appoint.getAppointTime());
            if(riqi.equals(Time)) {
                int start = appoint.getAppointStart();
                int end = appoint.getAppointEnd();
                if(kaishi<end&&kaishi>start) {
                    return "2";
                }
                else if(jieshu<end&&jieshu>start) {
                    
                    return "2";
                }
                else if(kaishi<=start&&jieshu>=end) {
                    
                    return "2";//冲突
                }
                else {
                    
                }
            }
        }
        return "1";
    }
}
