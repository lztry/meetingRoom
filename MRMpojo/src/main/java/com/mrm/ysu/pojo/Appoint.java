package com.mrm.ysu.pojo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.alibaba.fastjson.annotation.JSONField;

public class Appoint extends Page{
    private Integer id;

    private Integer roomId;

    private Integer userId;
    @JSONField(format="yyyy-MM-dd") 
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date appointTime;

    private Integer appointStart;

    private Integer appointEnd;

    private String reason;

    private Integer state;
    @JSONField(format="yyyy-MM-dd HH:mm:ss") 
    private Date submitTime;

    private String realName;

    private String realPhone;

    private Integer isDel;
    @JSONField(format="yyyy-MM-dd HH:mm:ss") 
    private Date dealTime;
    
    private User user;
    private MeetingRoom meetingRoom;
    private String end;
    private String start; //用做将 date 转string 发后台 和  查询预约提醒向后台穿的时间
    private String roomName;
    
    private String message;
    
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public MeetingRoom getMeetingRoom() {
        return meetingRoom;
    }

    public void setMeetingRoom(MeetingRoom meetingRoom) {
        this.meetingRoom = meetingRoom;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getAppointTime() {
        return appointTime;
    }

    public void setAppointTime(Date appointTime) {
        this.appointTime = appointTime;
    }

    public Integer getAppointStart() {
        return appointStart;
    }

    public void setAppointStart(Integer appointStart) {
        this.appointStart = appointStart;
    }

    public Integer getAppointEnd() {
        return appointEnd;
    }

    public void setAppointEnd(Integer appointEnd) {
        this.appointEnd = appointEnd;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason == null ? null : reason.trim();
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Date getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(Date submitTime) {
        this.submitTime = submitTime;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName == null ? null : realName.trim();
    }

    public String getRealPhone() {
        return realPhone;
    }

    public void setRealPhone(String realPhone) {
        this.realPhone = realPhone == null ? null : realPhone.trim();
    }

    public Integer getIsDel() {
        return isDel;
    }

    public void setIsDel(Integer isDel) {
        this.isDel = isDel;
    }

    public Date getDealTime() {
        return dealTime;
    }

    public void setDealTime(Date dealTime) {
        this.dealTime = dealTime;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    @Override
    public String toString() {
        return "Appoint [id=" + id + ", roomId=" + roomId + ", userId=" + userId + ", appointTime=" + appointTime
                + ", appointStart=" + appointStart + ", appointEnd=" + appointEnd + ", reason=" + reason + ", state="
                + state + ", submitTime=" + submitTime + ", realName=" + realName + ", realPhone=" + realPhone
                + ", isDel=" + isDel + ", dealTime=" + dealTime + ", user=" + user + ", meetingRoom=" + meetingRoom
                + ", end=" + end + ", start=" + start + "]";
    }
    
}