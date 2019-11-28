package com.mrm.ysu.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DealError {
    @RequestMapping("/404.do")
    public String nofind() {
        return "errorpages/HTTP-404";
    }
    @RequestMapping("/500.do")
    public String error() {
        return "errorpages/HTTP-500";
    }

}
