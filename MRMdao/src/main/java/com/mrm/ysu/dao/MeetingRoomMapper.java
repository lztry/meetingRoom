package com.mrm.ysu.dao;

import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.QueryRoom;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;

public interface MeetingRoomMapper {
    long countByExample(MeetingRoomExample example);

    int deleteByExample(MeetingRoomExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(MeetingRoom record);

    int insertSelective(MeetingRoom record);

    List<MeetingRoom> selectByExample(MeetingRoomExample example);

    MeetingRoom selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") MeetingRoom record, @Param("example") MeetingRoomExample example);

    int updateByExample(@Param("record") MeetingRoom record, @Param("example") MeetingRoomExample example);

    int updateByPrimaryKeySelective(MeetingRoom record);

    int updateByPrimaryKey(MeetingRoom record);
    List<MeetingRoom> query(QueryRoom queryRoom);
    List<MeetingRoom> queryUsable(QueryRoom queryRoom);//查找可用的会议室
  
}