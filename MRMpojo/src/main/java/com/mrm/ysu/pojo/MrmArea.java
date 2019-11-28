package com.mrm.ysu.pojo;

import java.util.List;


public class MrmArea {
    private Integer codeid;

    private Integer parentid;

    private String roomname;

    private List<MrmArea> children;
    
    public List<MrmArea> getChildren() {
        return children;
    }

    public void setChildren(List<MrmArea> children) {
        this.children = children;
    }

    public Integer getCodeid() {
        return codeid;
    }

    public void setCodeid(Integer codeid) {
        this.codeid = codeid;
    }

    public Integer getParentid() {
        return parentid;
    }

    public void setParentid(Integer parentid) {
        this.parentid = parentid;
    }

    public String getRoomname() {
        return roomname;
    }

    public void setRoomname(String roomname) {
        this.roomname = roomname == null ? null : roomname.trim();
    }

    @Override
    public String toString() {
        return "MrmArea [codeid=" + codeid + ", parentid=" + parentid + ", roomname=" + roomname + ", children="
                + children + "]";
    }
    
}