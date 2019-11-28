package com.mrm.ysu.pojo;

import lombok.Data;

@Data
public class IndexPageState {
    private Integer isAllShow;  //显示全部 or 选择可用
    private String startTime;
    private Integer duration;
    private Integer myPageNo;
    private Integer type; //类型 按会议室 or 按时间
    private Integer durationRange;
    private Integer roomMyPageNo;
    private String search;
   
}
