<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>

<%
	String basepath="";
	if(request.getServerPort()!=80){
		basepath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
	}else{
		basepath=request.getScheme()+"://"+request.getServerName()+request.getContextPath();
	}
	pageContext.setAttribute("basepath", basepath);
	String wbpath="";
	if(request.getServerPort()!=80){
	    wbpath="ws://"+request.getServerName()+":"+request.getServerPort()+"/MRMback";
    }else{
        wbpath="ws://"+request.getServerName()+"/MRMback";
    }
	pageContext.setAttribute("wbpath", wbpath);
	String backpath="";
    if(request.getServerPort()!=80){
        backpath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/MRMback";
    }else{
        backpath=request.getScheme()+"://"+request.getServerName()+"/MRMback";
    }
    pageContext.setAttribute("backpath", backpath);
//	pageContext.setAttribute("resourceServer", "http://172.18.0.2");
//	pageContext.setAttribute("imgServer", "http://172.18.1.8");
%>