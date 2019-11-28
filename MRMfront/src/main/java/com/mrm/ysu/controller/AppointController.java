package com.mrm.ysu.controller;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.appoint.AppointService;
import com.mrm.ysu.service.room.MeetingRoomService;

@Controller
@RequestMapping("/appoint")
public class AppointController {

	@Resource
	AppointService appointService;
	@Resource
	MeetingRoomService meetingRoomService;
	//处理日期格式
	/*@InitBinder    
	public void initBinder(WebDataBinder binder) {    
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");    
        dateFormat.setLenient(false);    
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));    

	}*/
	
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
	public int cancelAppoint(int aid) {
	    Appoint appoint = new Appoint();
	    appoint.setId(aid);
	    appoint.setState(3);
	    appointService.update(appoint);
	    return aid;
	}
	//我的会议室
	@RequestMapping("/meeting.do")
	
    public  String meeting(ModelMap modelMap,HttpServletRequest request) {
	    Appoint appoint =new Appoint();
	    HttpSession session = request.getSession();
        User user = (User) session.getAttribute("islogin");
        appoint.setUserId(user.getId());
        appoint.setState(1);
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        appoint.setStart(sdf.format(date));
        Calendar calendar = Calendar.getInstance();  
        calendar.setTime(date);  
        appoint.setAppointStart(calendar.get(Calendar.HOUR_OF_DAY));
        MultiValueMap<Date, Appoint> appointMap =  new LinkedMultiValueMap<>();
        List<MeetingRoom> roomList= meetingRoomService.query(new MeetingRoomExample());
        List<Appoint> appointList =  appointService.selectRemind(appoint);
        for (Appoint appointParam : appointList) {
            appointMap.add(appointParam.getAppointTime(), appointParam);
            for(MeetingRoom room : roomList) {
                if(appointParam.getRoomId() == room.getId()) {
                    appointParam.setRoomName(room.getName());
                    break;
                }
            }
        }
        modelMap.addAttribute("appointMap", appointMap);
        return "appoint/meeting";
    }
	
}
