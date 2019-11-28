<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
		<link rel="stylesheet" href="${basepath }/css/bootstrap.min.css" />
	</head>
	<style type="text/css">
		html,body{
			height: 100%;
			padding: 0;
			margin: 0;
		}
		div{
			height: 100%;
			
		}
	</style>
	<body>
		<div class="jumbotron">
		  <h2 align="center">亲爱的老师，由于我们的错误</h2>
		  <h1 align="center">页面走丢了</h1>
		  <h2 align="center">请点击下方按钮返回首页</h2>
		  <br/>
		  <p align="center"><a class="btn btn-primary btn-lg" href="${basepath }/appoint/goIndex.do" role="button">返回首页</a></p>
		</div>
	</body>
</html>
