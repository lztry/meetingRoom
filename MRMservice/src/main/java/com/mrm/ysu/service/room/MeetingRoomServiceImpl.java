package com.mrm.ysu.service.room;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.mrm.ysu.dao.MeetingRoomMapper;
import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.MeetingRoomExample;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.QueryRoom;
import com.mrm.ysu.service.department.DepartmentService;
@Service
public class MeetingRoomServiceImpl implements MeetingRoomService{
	@Resource
	MeetingRoomMapper meetingRoomMapper;
	@Resource
	DepartmentService departmentService;

	@Override
	public int add(MeetingRoom meetingRoom) {
		// TODO Auto-generated method stub
		return meetingRoomMapper.insertSelective(meetingRoom);
	}

	@Override
	public List<MeetingRoom> query(MeetingRoomExample meetingRoomExample) {
		// TODO Auto-generated method stub
		return meetingRoomMapper.selectByExample(meetingRoomExample);
	}

	@Override
	public MeetingRoom look(int id) {
		// TODO Auto-generated method stub
	    MeetingRoom meetingRoom=meetingRoomMapper.selectByPrimaryKey(id);
	    meetingRoom.setDepartmentname(departmentService.query(meetingRoom.getDepartmentId()).getName());
		return meetingRoom;
	}

	@Override
	public int update(MeetingRoom meetingRoom) {
		// TODO Auto-generated method stub
		return meetingRoomMapper.updateByPrimaryKeySelective(meetingRoom);
	}
	public List<MeetingRoom> find(QueryRoom queryRoom){
	    if(queryRoom.getWithPage()==1) {
            PageHelper.startPage(queryRoom.getPageNo(), queryRoom.getPageSize());
        }
	    return meetingRoomMapper.query(queryRoom);
	    
	}
	public List<MeetingRoom> findUsable(QueryRoom queryRoom){
	    if(queryRoom.getWithPage()==1) {
            PageHelper.startPage(queryRoom.getPageNo(), queryRoom.getPageSize());
        }
	    return meetingRoomMapper.queryUsable(queryRoom);
	}

  
}