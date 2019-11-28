package com.mrm.ysu.pojo;

import lombok.Data;

@Data
public class Page {
	
	public Integer pageNo=1;
	public Integer pageSize=10;
	public Integer withPage=1;
	public String url;
	public String params;
	public Integer pages;
	public String searchWay;
}
