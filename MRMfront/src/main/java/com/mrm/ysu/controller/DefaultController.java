package com.mrm.ysu.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class DefaultController {
        @RequestMapping("/index.do")
        public String index() {
            return "index";
        }
        @RequestMapping("/preindex.do")
        public String preindex() {
            return "preindex";
        }
        
        
}
