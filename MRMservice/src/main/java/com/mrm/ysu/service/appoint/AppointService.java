package com.mrm.ysu.service.appoint;

import java.util.List;
import java.util.Map;



import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MonthCountStatic;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.QueryContra;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.pojo.RoomCountStatic;


public interface AppointService {
    List<Appoint> query(AppointExample appointExample);//按条件查询
    int add(Appoint appoint);//添加
    int update(Appoint appoint); //修改
    int adminDel(int id);//按照id删除
    Appoint queryone(int id);//查单个
    int del(AppointExample appointExtample); //按条件删除
    long count(AppointExample appointExample);//返回数量
    List<Appoint> queryByUserId(int userId);//通过用户id查询
    List<Appoint> queryContra(QueryContra contra); //查询冲突预约
    int userDel(int id); //用户的删除
    List<Appoint> userQuery(Appoint appoint);//用户的查询
    Map<Integer, Object> queryTimeConflict(QueryRoom queryRoom);
    List<Appoint> query(AppointExample appointExample,Page page); //分页查询
    int dealOutDate();
    List<Appoint> selectRemind(Appoint appoint);
    //通过userId查询用户进12个月的预约次数 userId 为-1查全部
    List<MonthCountStatic> countStatics(int userId);
    //通过userId查询用户进12个月 各个会议室的预约次数 userId 为-1查全部
    List<RoomCountStatic> roomStatics(int userId);
    void meetingRemind();
    void appointSuccess(String[] params, int userId);
    void appointFail(Appoint appoint, String reason); 
}
