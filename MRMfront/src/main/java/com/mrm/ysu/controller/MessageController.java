package com.mrm.ysu.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mrm.ysu.pojo.MeetingRoom;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.Page;
import com.mrm.ysu.pojo.User;
import com.mrm.ysu.service.message.MessageService;
@RequestMapping("/message")
@Controller
public class MessageController {
   @Resource
   MessageService messageService;
   //未读的消息
   @RequestMapping("/queryNotRead.do")
   @ResponseBody
   public List<Message> queryNotRead(int uid){
       List<Message> mes=messageService.queryUnreadMsgByUId(uid);
       return mes;
   }
   //未读消息
   @RequestMapping("/noread.do")
   public String goNoread(HttpServletRequest request,ModelMap modelMap) {
       HttpSession session = request.getSession();
       User user = (User)session.getAttribute("islogin");
       List<Message> messageList=messageService.queryUnreadMsgByUId(user.getId());
       modelMap.addAttribute("messageList", messageList);
       return "message/noread";
   }
   //已读消息
   @RequestMapping("/readed.do")
   public String goReaded(HttpServletRequest request,ModelMap modelMap,Page page) {
       page.setPageSize(8);
       HttpSession session = request.getSession();
       User user = (User)session.getAttribute("islogin");
       com.github.pagehelper.Page<Message> messageList = (com.github.pagehelper.Page<Message>) messageService.queryMessageByUserIdPage(user.getId(),page);
       modelMap.addAttribute("messageList", messageList);
       page.setPages(messageList.getPages());
       modelMap.addAttribute("page", page);
       return "message/readed";
   }
   //删除消息 多行删除
   @RequestMapping("/delReaded.do")
   @ResponseBody
   public int delReaded(@RequestParam(value = "idList[]")List<Integer> idList) {
      return messageService.delMessages(idList);
   }
   @RequestMapping("/delAllReaded.do")
   public String delReaded(HttpServletRequest request) {
       HttpSession session = request.getSession();
       User user = (User)session.getAttribute("islogin");
       messageService.delAllMessages(user.getId());
       return "redirect:readed.do";
   }
   @RequestMapping("/readMsgs.do")
   @ResponseBody
   public int readMsgs(@RequestParam(value = "idList[]")List<Integer> idList) {
       return messageService.readMessages(idList);
   }
}
