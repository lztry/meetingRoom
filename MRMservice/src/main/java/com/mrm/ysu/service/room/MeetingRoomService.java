package com.mrm.ysu.service.room;

import java.util.List;

import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.QueryRoom;



public interface MeetingRoomService {
	int add(MeetingRoom meetingRoom);
	List<MeetingRoom> query(MeetingRoomExample meetingRoomExample);
	MeetingRoom look(int id);
	int update(MeetingRoom meetingRoom);
    public List<MeetingRoom> find(QueryRoom queryRoom);
    public List<MeetingRoom> findUsable(QueryRoom queryRoom);//查询可用会议室
    
}
