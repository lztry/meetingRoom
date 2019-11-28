package com.mrm.ysu.controller;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.mrm.ysu.pojo.MrmArea;
import com.mrm.ysu.pojo.MrmAreaExample;
import com.mrm.ysu.service.area.IareaService;

/**  

* <p>Title: MrmAreaController.java</p>  

* <p>Description: 会议室地点级联菜单controller层</p>  
 
* @author Dingxuesong  

* @date 2018年8月28日  

* @version 1.0  

*/
@Controller
@RequestMapping("/area")
public class MrmAreaController {
    @Resource
    IareaService areaService;
    @RequestMapping("/list.do")
    @ResponseBody
    public List<MrmArea> getMrmArea(){
        return areaService.getMrmArea();
    }
    @RequestMapping("addarea.do")   
    public String addarea(MrmArea area) {
        MrmAreaExample areaExample = new MrmAreaExample();
        areaExample.createCriteria().andParentidEqualTo(area.getParentid());
        int count =areaService.count(areaExample);
        String strcodeid=String.format("%02d",(count+1));
        int codeid=Integer.parseInt((String.valueOf(area.getParentid())+strcodeid));
        area.setCodeid(codeid);
        areaService.add(area);
        return "redirect:/room/meetingRoom.do";
    }
}
