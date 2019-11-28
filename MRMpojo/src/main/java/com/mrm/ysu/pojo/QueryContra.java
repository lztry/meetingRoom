package com.mrm.ysu.pojo;

import lombok.Data;

@Data
public class QueryContra {
    
    private String appointTime ;  //预约开始时间 
    private Integer start;        //开始整点 
    private Integer end;          //结束整点
    private Integer roomId;       //会议室id
    public QueryContra() {}
    public QueryContra(String appointTime, Integer start, Integer end, Integer roomId) {
       
        this.appointTime = appointTime;
        this.start = start;
        this.end = end;
        this.roomId = roomId;
    }
    
}
