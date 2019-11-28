package com.mrm.ysu.controller;


import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import com.mrm.ysu.pojo.MonthCountStatic;
import com.mrm.ysu.pojo.RoomCountStatic;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.appoint.AppointService;


/*
 * 统计 信息 完善模块
 * */
@Controller
@RequestMapping("/statistic")
public class StatisticsController {
    @Resource
    AppointService appointService;
    @RequestMapping("/gostatistic.do")
    public String goStatistic() {
        return "statistic/chart";
    }
    @RequestMapping("/countNum.do")
    @ResponseBody
    public List<MonthCountStatic> countStatics(int userId) {
        return appointService.countStatics(userId);
    }
    @RequestMapping("/roomStatis.do")
    @ResponseBody
    public List<RoomCountStatic> roomStatis(int userId) {
        return appointService.roomStatics(userId);
    }
}
