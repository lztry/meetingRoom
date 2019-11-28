<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首页</title>
    <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
    <style>
        .vertical-timeline-block {
            padding: 5px 5px;
        }
        #appointing{
            min-height: 250px;
        }
        #tip{
            line-height: 250px;
            
        }
    </style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content">
     
        <div class="row">
            <div class="col-sm-12">
                <div  class="ibox float-e-margins">
                    <div class="ibox-title">
                       
                        <h5>即将进行的会议</h5>
                    </div>
                    
                    <div class="ibox-content" id="appointing">
	                    <c:if test="${appointMap.size() == 0 }">
	                        <h1 id="tip" class="text-center"  >暂无即将进行的会议</h1>
	                    </c:if>
                        <div class="ibox float-e-margins">
                            <div class="dark-timeline" id="ibox-content">
                                <div id="vertical-timeline" class="vertical-container light-timeline">
                                    <c:forEach items="${appointMap}" var="meeting">
	                                    <div class="vertical-timeline-block">
	                                        <div class="vertical-timeline-block navy-bg">
	                                            <fmt:formatDate value="${meeting.key }" pattern="yyyy年M月d日 "/>
	                                           
	                                        </div>
	                                        <c:forEach items="${meeting.value}" var="meetingInfo">
		                                        <div class="vertical-timeline-content">
		                                            <h2>${meetingInfo.roomName }</h2>
		                                            <span> &nbsp;&nbsp;&nbsp;&nbsp;${meetingInfo.reason }</span>
		                                            <span class="vertical-date">
		                                                <small>${meetingInfo.appointStart}:00 ~ ${meetingInfo.appointEnd}:00</small>
		                                            </span>
		                                        </div>
	                                        </c:forEach>
	                                    </div>
                                    </c:forEach>           
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>

    <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
    <script>
        $(document).ready(function(){$("#lightVersion").click(function(event){event.preventDefault();$("#ibox-content").removeClass("ibox-content");$("#vertical-timeline").removeClass("dark-timeline");$("#vertical-timeline").addClass("light-timeline")});$("#darkVersion").click(function(event){event.preventDefault();$("#ibox-content").addClass("ibox-content");$("#vertical-timeline").removeClass("light-timeline");$("#vertical-timeline").addClass("dark-timeline")});$("#leftVersion").click(function(event){event.preventDefault();$("#vertical-timeline").toggleClass("center-orientation")})});
    </script>
</body>

<!-- Mirrored from www.zi-han.net/theme/hplus/index_v3.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:49 GMT -->
</html>
