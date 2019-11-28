package com.mrm.ysu.service.single;

import java.util.List;

import com.mrm.ysu.pojo.Appoint;
import com.mrm.ysu.pojo.AppointExample;

public interface SingleService {
	List<Appoint> queryall(AppointExample example);
	int add(Appoint appoint);
}
