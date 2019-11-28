package com.mrm.ysu.controller;



import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mrm.ysu.service.appoint.AppointService;





@Controller
public class DefaultController {
     @Resource
     AppointService appointService;
        @RequestMapping("/index.do")
        public String index() {
            appointService.meetingRemind();
            return "index";
        }
}
