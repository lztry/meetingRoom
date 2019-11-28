package com.mrm.ysu.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;




/**  

* <p>Title: WebSocketController.java</p>  

* <p>Description: </p>  
 
* @author Dingxuesong  

* @date 2018年9月3日  

* @version 1.0  

*/
@ServerEndpoint("/server/{param}")
public class WebSocketController {

    public static Map<String, Session> sessions = new HashMap<>();
    @OnOpen
    public void open(@PathParam("param")String param,Session session) throws IOException {
        sessions.put(param, session);        
        
    }
    
    //客户端向服务器发消息
    @OnMessage
    public void message(Session session,String message) throws IOException {
        System.out.println(message);
        
        if(message.equals("newinform")) {
            Session admin=sessions.get("admin");
            if(admin!=null)
            admin.getBasicRemote().sendText("newinform");
        }
    }
    
    @OnError
    public void error(Session session,Throwable throwable){
    }
   
    @OnClose
    public void close(Session session,@PathParam("param")String param){
        sessions.remove(param);
    }
    //服务器向客户端发
    public static void pass(String account,String mes) throws IOException {
        Session session=sessions.get(account);
        if(session!=null)
        session.getBasicRemote().sendText(mes);
    }
    public static void reject(String account,String mes) throws IOException {
        Session session=sessions.get(account);
        if(session!=null)
        session.getBasicRemote().sendText(mes);
    }
}
