package com.mrm.ysu.service.area;

import java.util.List;

import com.mrm.ysu.pojo.MrmArea;
import com.mrm.ysu.pojo.MrmAreaExample;

public interface IareaService {

    List<MrmArea> getMrmArea();
    int add(MrmArea mrmArea);
 
    int update(MrmArea mrmArea, MrmAreaExample example);
    int count(MrmAreaExample areaExample);
}
