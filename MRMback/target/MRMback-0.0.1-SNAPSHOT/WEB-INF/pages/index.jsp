<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>会议室预约后台</title>
    <!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->
    <link rel="shortcut icon" href="${basepath }/img/Logo.ico">
    <link href="${basepath }/css/font-awesome.min93e3.css" rel="stylesheet">
    <link href="${basepath }/css/bootstrap.min.css" rel="stylesheet">
    <link href="${basepath }/css/animate.min.css" rel="stylesheet">
    <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
</head>

<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div id="ulVue">
                <ul class="nav" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element">
                            <span><img alt="image" class="img-circle" src="${basepath }/img/0e04b6569da8bac2422cc398d0a63880.jpg" /></span>
                            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear"></span>
                               <span class="block m-t-xs"><h3>信院会议室预约系统</h3></span>
                            </a>
                        </div>
                    </li>
                    <li>
                        <a  class="J_menuItem"  href="${basepath }/appoint/check.do">
                            <i class="glyphicon glyphicon-edit"></i>
                            <span class="nav-label">待审核</span>
                             <span class="label label-danger pull-right" v-if="appointnum!=0" >{{appointnum}}</span>
                        </a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/appoint/record.do"><i class="glyphicon glyphicon-list-alt"></i> <span class="nav-label">预约记录</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/room/meetingRoom.do"><i class="glyphicon glyphicon-home"></i> <span class="nav-label">会议室管理</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/user/list.do"><i class="glyphicon glyphicon-user"></i> <span class="nav-label">用户管理</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/department/department.do"><i class="glyphicon glyphicon-bookmark"></i> <span class="nav-label">系别管理</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/appoint/selfappoint.do"><i class="glyphicon glyphicon-check"></i> <span class="nav-label">待使用</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath}/user/password.do"><i class="glyphicon glyphicon-cog"></i> <span class="nav-label">修改密码</span></a>
                    </li>
                    <li>
                        <a href="${basepath }/user/logoff.do"><i class="glyphicon glyphicon-off"></i> <span class="nav-label">退出登录</span></a>
                    </li>
                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
                </div>
            </nav>
            <div class="row J_mainContent" id="content-main">
                <iframe class="J_iframe"  name="iframe0" width="100%" height="100%" src="${basepath }/appoint/check.do" frameborder="0" data-id="${basepath }/appoint/check.do" seamless></iframe>
            </div>
            <div class="footer">
                <div class="pull-right">&copy; 2019 <a href="http://http://ise.ysu.edu.cn/" target="_blank">燕山大学信息科学与工程学院</a>
                </div>
            </div>
        </div>
        <!--右侧部分结束-->
    </div>
    <script src="${basepath }/js/jquery.min.js"></script>
    <script src="${basepath }/js/bootstrap.min.js"></script>
    <script src="${basepath }/js/jquery.metisMenu.js"></script>
    <script src="${basepath }/js/layer/layer.min.js"></script>
    <script src="${basepath }/js/hplus.min.js?v=4.1.0"></script>
    <script src="${basepath }/js/vue.min.js"></script>
    <script type="text/javascript" src="${basepath }/js/contabs.min.js" ></script>
    <script type="text/javascript">
	    $.ajax({
	        url:"${basepath}/appoint/count.do",
	        type:"post",
	        dataType:"text",
	        async:true,
	        success:function(data){
	            vue.appointnum= parseInt(data);
	        }
	    });
	    
	    var vue = new Vue({
	        el:"#ulVue",
	        data:{
	            appointnum:0
	        },
	    });    
   
    </script>
</body>

</html>
