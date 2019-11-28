package com.mrm.ysu.dao;

import com.mrm.ysu.pojo.MrmArea;
import com.mrm.ysu.pojo.MrmAreaExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface MrmAreaMapper {
    long countByExample(MrmAreaExample example);

    int deleteByExample(MrmAreaExample example);

    int insert(MrmArea record);

    int insertSelective(MrmArea record);

    List<MrmArea> selectByExample(MrmAreaExample example);

    int updateByExampleSelective(@Param("record") MrmArea record, @Param("example") MrmAreaExample example);

    int updateByExample(@Param("record") MrmArea record, @Param("example") MrmAreaExample example);
}