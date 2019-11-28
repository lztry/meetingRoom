package com.mrm.ysu.service.single;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mrm.ysu.dao.AppointMapper;
import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;
@Service
public class SingleServiceImpl implements SingleService{
	@Resource
	AppointMapper appointmapper;
	@Override
	public List<Appoint> queryall(AppointExample example) {
		// TODO Auto-generated method stub

		return appointmapper.selectByExample(example);
	}
	@Override
	public int add(Appoint appoint) {
		// TODO Auto-generated method stub
		return appointmapper.insertSelective(appoint);
	}

}
