package com.mrm.ysu.pojo;

import java.util.Arrays;

public class QueryRoom extends Page{
    private Integer peopleNum;    //人数
    private Integer userScale;    //用户级别
    private String appointTime ;  //预约开始时间 
    private Integer start;        //开始整点 
    private Integer end;          //结束整点
    private String location;     //位置 
    private Integer multimedia;   //是否有多媒体
    private Integer check;        //是否审核
    private Integer departmentId; //系别id
    private String order="capacity";        //排序
    private int[] roomList;    //会议室列表以逗号分隔
   
    public int[] getRoomList() {
        return roomList;
    }
    public void setRoomList(int[] roomList) {
        this.roomList = roomList;
    }
    public String getOrder() {
        return order;
    }
    public void setOrder(String order) {
        this.order = order;
    }
    public Integer getPeopleNum() {
        return peopleNum;
    }
    public void setPeopleNum(Integer peopleNum) {
        this.peopleNum = peopleNum;
    }
    public Integer getUserScale() {
        return userScale;
    }
    public void setUserScale(Integer userScale) {
        this.userScale = userScale;
    }
    public String getAppointTime() {
        return appointTime;
    }
    public void setAppointTime(String appointTime) {
        this.appointTime = appointTime;
    }
    public Integer getStart() {
        return start;
    }
    public void setStart(Integer start) {
        this.start = start;
    }
    public Integer getEnd() {
        return end;
    }
    public void setEnd(Integer end) {
        this.end = end;
    }
    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }
    public Integer getMultimedia() {
        return multimedia;
    }
    public void setMultimedia(Integer multimedia) {
        this.multimedia = multimedia;
    }
    public Integer getCheck() {
        return check;
    }
    public void setCheck(Integer check) {
        this.check = check;
    }
    public Integer getDepartmentId() {
        return departmentId;
    }
    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }
    @Override
    public String toString() {
        return "QueryRoom [peopleNum=" + peopleNum + ", userScale=" + userScale + ", appointTime=" + appointTime
                + ", start=" + start + ", end=" + end + ", location=" + location + ", multimedia=" + multimedia
                + ", check=" + check + ", departmentId=" + departmentId + ", order=" + order + ", roomList="
                + Arrays.toString(roomList) + "]";
    }
    
   
}
    
