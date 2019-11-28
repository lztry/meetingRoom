package com.mrm.ysu.dao;

import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
import com.mrm.ysu.pojo.MonthCountStatic;
import com.mrm.ysu.pojo.QueryContra;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.pojo.RoomCountStatic;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;

public interface AppointMapper {
    long countByExample(AppointExample example);

    int deleteByExample(AppointExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Appoint record);

    int insertSelective(Appoint record);

    List<Appoint> selectByExample(AppointExample example);

    Appoint selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Appoint record, @Param("example") AppointExample example);

    int updateByExample(@Param("record") Appoint record, @Param("example") AppointExample example);

    int updateByPrimaryKeySelective(Appoint record);

    int updateByPrimaryKey(Appoint record);
    List<Appoint> contradiction(QueryContra  queryContra);
    @MapKey("room_id")
    Map<Integer, Object> queryTimeConflict(QueryRoom queryRoom);
    List<Appoint> query(Appoint appoint);
    List<Appoint> selectRemind(Appoint appoint);
    List<MonthCountStatic> monthCountStatic(@Param(value="userId") int userId);
    List<RoomCountStatic> roomCountStatic(@Param(value="userId") int userId);
}