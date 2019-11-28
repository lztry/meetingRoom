package com.mrm.ysu.service.area;

import java.awt.geom.Area;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mrm.ysu.dao.MrmAreaMapper;
import com.mrm.ysu.pojo.MrmArea;
import com.mrm.ysu.pojo.MrmAreaExample;
/**  

* <p>Title: AreaServiceImpl.java</p>  

* <p>Description: </p>  
 
* @author Dingxuesong  

* @date 2018年8月28日  

* @version 1.0  

*/
@Service
public class AreaServiceImpl implements IareaService{

    /* (non-Javadoc)
     * @see com.mrm.ysu.service.area.IareaService#getMrmArea()
     */
    
    @Resource
    MrmAreaMapper mrmAreaMapper;
    @Override
    public List<MrmArea> getMrmArea() {
        // TODO Auto-generated method stub
        MrmAreaExample areaExample=new MrmAreaExample();
        areaExample.createCriteria().andParentidEqualTo(0);
        List<MrmArea> list=mrmAreaMapper.selectByExample(areaExample);
        for (MrmArea mrmArea : list) {
            MrmAreaExample childExample=new MrmAreaExample();
            childExample.createCriteria().andParentidEqualTo(mrmArea.getCodeid());
            List<MrmArea> children=mrmAreaMapper.selectByExample(childExample);
            mrmArea.setChildren(children);
        }
        return list;
       
    }
    @Override
    public int add(MrmArea mrmArea) {
        // TODO Auto-generated method stub
        return mrmAreaMapper.insertSelective(mrmArea);
    }
    @Override
    public int update(MrmArea mrmArea,MrmAreaExample example) {
        // TODO Auto-generated method stub
        return mrmAreaMapper.updateByExampleSelective(mrmArea, example);
        
    }
    @Override
    public int count(MrmAreaExample areaExample) {
     
        return  (int)mrmAreaMapper.countByExample(areaExample) ;
    }
   

}
