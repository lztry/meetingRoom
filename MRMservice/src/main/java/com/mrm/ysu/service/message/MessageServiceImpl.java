package com.mrm.ysu.service.message;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.mrm.ysu.dao.MessageMapper;
import com.mrm.ysu.pojo.Message;
import com.mrm.ysu.pojo.MessageExample;
import com.mrm.ysu.pojo.Page;

/**  

* <p>Title: MessageServiceImpl.java</p>  

* <p>Description: </p>  
 
* @author Dingxuesong  

* @date 2018年9月3日  

* @version 1.0  

*/
@Service
public class MessageServiceImpl implements MessageService{

    /* (non-Javadoc)
     * @see com.mrm.ysu.service.message.ImessageService#add(com.mrm.ysu.pojo.Message)
     */
    
    @Resource
    MessageMapper messageMapper;
    
    @Override
    public int add(Message message) {
        // TODO Auto-generated method stub
        messageMapper.insertSelective(message);
        return 0;
    }

    @Override
    public int update(Message message) {
        // TODO Auto-generated method stub
        return messageMapper.updateByPrimaryKeySelective(message);
    }

    /* (non-Javadoc)
     * @see com.mrm.ysu.service.message.MessageService#queryMessageById(int)
     */
    @Override
    public List<Message> queryUnreadMsgByUId(int id) {
        // TODO Auto-generated method stub
        MessageExample example=new MessageExample();
        example.createCriteria().andUserIdEqualTo(id).andIsReadEqualTo(0);
        return messageMapper.selectByExample(example);
    }
    @Override
    public List<Message> queryMessageByUserId(int id) {
        // TODO Auto-generated method stub
        MessageExample example=new MessageExample();
        example.createCriteria().andUserIdEqualTo(id).andIsDelEqualTo(0);
        return messageMapper.selectByExample(example);
    }
    @Override
    public List<Message> queryMessageByUserIdPage(int id ,Page page){
        if(page.getWithPage()==1) {
            PageHelper.startPage(page.getPageNo(), page.getPageSize());
        }
        MessageExample example=new MessageExample();
        example.createCriteria().andUserIdEqualTo(id).andIsDelEqualTo(0).andIsReadEqualTo(1);
        return messageMapper.selectByExample(example);
    }
    /* (non-Javadoc)
     * @see com.mrm.ysu.service.message.MessageService#readMessage(int)
     */
    @Override
    public int readMessages(List<Integer> idList) {
        Message message  = new Message();
        message.setIsRead(1);
        MessageExample messageExample = new MessageExample();
        messageExample.createCriteria().andIdIn(idList);
        return messageMapper.updateByExampleSelective(message, messageExample);
    }
    @Override
    public int delMessages(List<Integer> idList) {
        Message message  = new Message();
        message.setIsDel(1);
        MessageExample messageExample = new MessageExample();
        messageExample.createCriteria().andIdIn(idList);
        return messageMapper.updateByExampleSelective(message, messageExample);
    }
    @Override
    public int delAllMessages(int userId) {
        Message message  = new Message();
        message.setIsDel(1);
        MessageExample messageExample = new MessageExample();
        messageExample.createCriteria().andUserIdEqualTo(userId);
        return messageMapper.updateByExampleSelective(message, messageExample);
    }
}
