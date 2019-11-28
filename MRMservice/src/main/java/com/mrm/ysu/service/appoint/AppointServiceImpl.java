package com.mrm.ysu.service.appoint;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.mrm.ysu.dao.AppointMapper;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.MonthCountStatic;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.QueryContra;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.pojo.RoomCountStatic;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.pojo.UserExample;
import com.mrm.ysu.service.department.DepartmentService;
import com.mrm.ysu.service.message.MessageService;
import com.mrm.ysu.service.room.MeetingRoomService;
import com.mrm.ysu.service.user.UserService;

import com.mrm.ysu.util.WxPush;
@Service
public class AppointServiceImpl implements AppointService{
    @Resource
    AppointMapper appointMapper;
    @Resource
    DepartmentService departmentService;
    @Resource
    MeetingRoomService roomService;
    @Resource
    UserService userService;
    @Resource
    MessageService messageService;
    
    @Override
    public List<Appoint> selectRemind(Appoint appoint) {
        return appointMapper.selectRemind(appoint);
    }

    @Override
    public List<Appoint> query(AppointExample appointExample) {
        // TODO Auto-generated method stub
       List<Appoint> appointList = appointMapper.selectByExample(appointExample);
       /*
        * 为appoint里的user 和meeting room赋值
        */
       List<User> users= userService.queryall(new UserExample());
       List<MeetingRoom> rooms = roomService.query(new MeetingRoomExample());
       for(Appoint appoint : appointList) {
           for(User user : users) {
               if(user.getId().intValue()==appoint.getUserId().intValue()) {
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
       return appointList;
    }

    @Override
    public int add(Appoint appoint) {
        // TODO Auto-generated method stub
        return appointMapper.insertSelective(appoint);
    }

   

    @Override
    public Appoint queryone(int id) {
        // TODO Auto-generated method stub
        return appointMapper.selectByPrimaryKey(id);
    }

    @Override
    public int update(Appoint appoint) {
        // TODO Auto-generated method stub
        return appointMapper.updateByPrimaryKeySelective(appoint);
    }

    @Override
    public int del(AppointExample appointExample) {
        // TODO Auto-generated method stub
        return appointMapper.deleteByExample(appointExample);
    }

    @Override
    public long count(AppointExample appointExample) {
        // TODO Auto-generated method stub
        return appointMapper.countByExample(appointExample);
    }

    @Override
    public int userDel(int id) {
        // TODO Auto-generated method stub
        Appoint appoint = new Appoint();
        appoint.setId(id);
        appoint.setIsDel(1);
        return appointMapper.updateByPrimaryKeySelective(appoint);
    }

    @Override
    public List<Appoint> queryByUserId(int userId) {
        AppointExample appointExample = new AppointExample();
        appointExample.createCriteria().andUserIdEqualTo(userId).andIsDelNotEqualTo(1);
        List<Appoint> appointList = appointMapper.selectByExample(appointExample);
        for(Appoint appoint : appointList) {
            appoint.setMeetingRoom(roomService.look(appoint.getRoomId()));
        }
        return appointList;
    }

    @Override
    public List<Appoint> queryContra(QueryContra contra) {
        return appointMapper.contradiction(contra);
    }

    @Override
    public int adminDel(int id) {
        Appoint appoint = new Appoint();
        appoint.setId(id);
        appoint.setIsDel(2);
        return appointMapper.updateByPrimaryKeySelective(appoint);
    }

    @Override
    public Map<Integer, Object> queryTimeConflict(QueryRoom queryRoom) {
        return  appointMapper.queryTimeConflict(queryRoom);
       
    }

    @Override
    public List<Appoint> userQuery(Appoint appoint) {
        if(appoint.getWithPage()==1) {
            PageHelper.startPage(appoint.getPageNo(), appoint.getPageSize());
        }
        return appointMapper.query(appoint);
    }

    @Override
    public List<Appoint> query(AppointExample appointExample, Page page) {
        if(page!=null&&page.getWithPage()==1) {
            PageHelper.startPage(page.getPageNo(), page.getPageSize());
        }
        return appointMapper.selectByExample(appointExample);
     
    }

    @Override
    @Transactional
    public int dealOutDate() {
        AppointExample appointExample = new AppointExample();
        Date date = new Date();
        Calendar rightNow = Calendar.getInstance();
        rightNow.setTime(date);
        int hour = rightNow.get(Calendar.HOUR_OF_DAY);
        appointExample.createCriteria().andAppointTimeEqualTo(date).andAppointStartLessThanOrEqualTo(hour).andStateEqualTo(0);
        appointExample.or().andAppointTimeLessThan(date).andStateEqualTo(0);
        List<Appoint> appointList= appointMapper.selectByExample(appointExample);
        if(appointList.isEmpty()) {
            return 0;
        }
        List<MeetingRoom> roomlist= roomService.query(new MeetingRoomExample());
        List<Integer> idList = new ArrayList<>();
        for(Appoint appoint : appointList) {
            idList.add(appoint.getId());
            Message message = new Message();
            for(MeetingRoom room : roomlist) {
                if(room.getId()==appoint.getRoomId()) {
                    message.setSituation(room.getName());
                    appoint.setRoomName(room.getName());
                    break;
                }
            }
            
            message.setAppointId(appoint.getId());
            message.setState(2);
            message.setCreateTime(new Date());
            message.setUserId(appoint.getUserId());
            message.setContent("管理员未处理");
            appoint.setDealTime(date);
            messageService.add(message);
            
            appointFail(appoint,"管理员未处理");
        }
       // System.out.println(idList);
        AppointExample example = new AppointExample();
        example.createCriteria().andIdIn(idList);
        Appoint record = new Appoint();
        record.setState(2);
        record.setDealTime(date);
        appointMapper.updateByExampleSelective(record, example);
        return 0;
    }

    @Override
    public List<MonthCountStatic> countStatics(int userId) {
        List<MonthCountStatic> resultList = appointMapper.monthCountStatic(userId);
        /*
         * 只查询出有预约的月份，无预约月份设为 0
         * */
        //获得前12个月份的时间
        Calendar calendar = Calendar.getInstance();//使用默认时区和语言环境获得一个日历。    
        calendar.add(Calendar.MONTH, -11);   
        int last12Month = calendar.get(Calendar.MONTH);
        int last12MonthYear = calendar.get(Calendar.YEAR);
        if(resultList.size() == 0) {
            for(int i=0;i<12;i++) {
                int paramsMonth = (last12Month+i) % 12+1;
                int paramsYear = (last12Month+i) / 12 + last12MonthYear;
                MonthCountStatic monthCountStatic = new MonthCountStatic();
                monthCountStatic.setMonthValue(paramsMonth);
                monthCountStatic.setMonthDate(paramsYear+"-"+String.format("%02d", paramsMonth));
                resultList.add(i, monthCountStatic);
            }
            return resultList;
        }
        for(int i=0;i<12;i++) {
            int paramsMonth = (last12Month+i) % 12+1;
            int paramsYear = (last12Month+i) / 12 + last12MonthYear;
            if(resultList.get(i) == null || resultList.get(i).getMonthValue() != paramsMonth) {
                MonthCountStatic monthCountStatic = new MonthCountStatic();
                monthCountStatic.setMonthValue(paramsMonth);
                monthCountStatic.setMonthDate(paramsYear+"-"+String.format("%02d", paramsMonth));
                resultList.add(i, monthCountStatic);
            }
        }
        
        return resultList;
    }
    @Override
    public List<RoomCountStatic> roomStatics(int userId) {
        return appointMapper.roomCountStatic(userId);
    }
    @Override
    public void meetingRemind() {
        System.out.println("-------");
        AppointExample appointExample = new AppointExample();
        Date date = new Date();
       
        Calendar rightNow = Calendar.getInstance();
        rightNow.setTime(date);
        int hour = rightNow.get(Calendar.HOUR_OF_DAY);
        appointExample.createCriteria().andAppointTimeEqualTo(date).andAppointStartEqualTo(hour+2).andStateEqualTo(1);
        List<Appoint> appointList= appointMapper.selectByExample(appointExample);
        if(appointList.isEmpty()) {
            return ;
        }
        List<MeetingRoom> roomlist= roomService.query(new MeetingRoomExample());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        for(Appoint appoint : appointList) {
            User user = userService.query(appoint.getUserId());
            if(user.getWxOpenId()==null||user.getWxOpenId()=="")
                break;
            String roomName = "";
            for(MeetingRoom room : roomlist) {
                if(room.getId()==appoint.getRoomId()) {
                    roomName = room.getName();
                    break;
                }
            }
            String appointTime = dateFormat.format(appoint.getAppointTime())+" "+appoint.getAppointStart()+":00~"+appoint.getAppointEnd()+":00";
            String [] strData = new String[3];
            strData[0] = appointTime;
            strData[1] = roomName;
            strData[2] = appoint.getReason();
            JSONObject json = new JSONObject();
            json.put("secret", "61de3-6786d-c3581-f8c62");
            json.put("path","pages/index/index");
            json.put("data",strData);
            json.put("openId", user.getWxOpenId());
            System.out.println(json.toJSONString());
            System.out.println(WxPush.sendPost("https://wx0e562f74708ac18e.mssnn.cn/v2/api/vpush?id=9", json.toJSONString()));
        }
        return ;
    }
    //审核成功推送
    @Override
    public void appointSuccess(String [] params,int userId) {
        User user = userService.query(userId);
        if(user.getWxOpenId()==null||user.getWxOpenId()=="")
            return;
        JSONObject json = new JSONObject();
        json.put("secret", "78957-4ab94-9fd34-882bd");
        json.put("path","pages/index/index");
        json.put("data",params);
        json.put("openId", user.getWxOpenId());
        System.out.println(WxPush.sendPost("https://wx0e562f74708ac18e.mssnn.cn/v2/api/vpush?id=8", json.toJSONString()));
    }
    @Override
    public void appointFail(Appoint appoint,String reason) {
        User user = userService.query(appoint.getUserId());
        if(user.getWxOpenId()==null||user.getWxOpenId()=="")
            return;
        SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String [] params = new String[6];
        params[0] = appoint.getRoomName();
        params[1] = dateFormat1.format(appoint.getAppointTime())+" "+appoint.getAppointStart()+":00~"+appoint.getAppointEnd()+":00";
        params[2] = appoint.getReason();
        params[3] = "没有通过审核";
        params[4] = reason;
        params[5] = dateFormat2.format(appoint.getDealTime());
        JSONObject json = new JSONObject();
        json.put("secret", "3f52b-15979-34430-07a45");
        json.put("path","");
        json.put("data",params);
        json.put("openId", user.getWxOpenId());
        System.out.println(WxPush.sendPost("https://wx0e562f74708ac18e.mssnn.cn/v2/api/vpush?id=6", json.toJSONString()));
    }
}
