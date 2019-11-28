package com.mrm.ysu.service.message;

import java.util.List;

import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.Page;

/**  

* <p>Title: ImessageService.java</p>  

* <p>Description: 信息审核Service</p>  
 
* @author Dingxuesong  

* @date 2018年9月3日  

* @version 1.0  

*/
public interface MessageService {
    int add(Message message);
    int update(Message message);
    public List<Message> queryMessageByUserId(int id);
    List<Message> queryUnreadMsgByUId(int id);
    public List<Message> queryMessageByUserIdPage(int id ,Page page);
    int delMessages(List<Integer> idList);
    int readMessages(List<Integer> idList);
    int delAllMessages(int userId);
}
