<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录</title>
 <script type="text/javascript" src="${basepath}/js/jquery.min.js"></script>
<script type="text/javascript">
$(function(){
	window.top.location.href="${frontpath}/user/login.do";
});
</script>
</head>
<body>
</body>
</html>