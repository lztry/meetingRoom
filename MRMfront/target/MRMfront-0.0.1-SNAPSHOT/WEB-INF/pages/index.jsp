<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>


<!-- Mirrored from www.zi-han.net/theme/hplus/ by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:16:41 GMT -->
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>会议室预约</title>
    <!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->
    <link rel="shortcut icon" href="${basepath }/img/mrm_favicon.ico">
    <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="${basepath }/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${basepath }/css/animate.min.css" rel="stylesheet">
    <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
    <link href="${basepath }/css/plugins/toastr/toastr.min.css" rel="stylesheet">
</head>

<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="sidebar-collapse" >
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
                        <a  class="J_menuItem"  href="${basepath }/appoint/meeting.do">
                            <i class="fa fa-home"></i>
                            <span class="nav-label">主页</span>
                        </a>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-envelope"></i> <span class="nav-label">消息提醒 </span> <span class="label label-danger pull-right" v-if="messageList.length!=0">{{messageList.length}}</span></a>
                        <ul class="nav nav-second-level">
                            <li><a class="J_menuItem" href="${basepath }/message/noread.do">未读消息<span class="label label-danger pull-right" v-if="messageList.length!=0">{{messageList.length}}</span></a>
                            </li>
                            <li><a class="J_menuItem" href="${basepath }/message/readed.do">已读消息</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#">
                            <i class="glyphicon glyphicon-blackboard"></i>
                            <span class="nav-label">会议室预约</span>
                            <span class="fa arrow"></span>
                        </a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a class="J_menuItem" href="${basepath }/room/roomappoint.do">按照会议室预约</a>
                            </li>
                            <li>
                                <a class="J_menuItem" href="${basepath }/room/timeappoint.do">按照时间预约</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-table"></i> <span class="nav-label">我的预约</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li><a class="J_menuItem" href="${basepath }/user/suappoint.do">成功预约</a>
                            </li>
                            <li><a class="J_menuItem" href="${basepath }/user/check.do">待审核</a>
                            </li>
                            <li><a class="J_menuItem" href="${basepath }/user/cancel.do">已取消预约</a>
                            </li>
                            <li><a class="J_menuItem" href="${basepath }/user/reappoint.do">失败预约</a>
                            </li>
                             <li><a class="J_menuItem" href="${basepath }/user/appoint.do">所有预约</a>
                            </li>
                        </ul>
                    </li>
                    <!-- <li>
                        <a class="J_menuItem" href="css_animation.html"><i class="fa fa-bar-chart-o"></i> <span class="nav-label">图表统计</span></a>
                    </li> -->
                    <li>
                        <a class="J_menuItem" href="${basepath }/statistic/gostatistic.do"><i class="fa fa fa-bar-chart-o"></i><span class="nav-label">统计图表</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath}/user/person.do"><i class="glyphicon glyphicon-user"></i> <span class="nav-label">个人信息</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath}/user/password.do"><i class="glyphicon glyphicon-cog"></i> <span class="nav-label">修改密码</span></a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="${basepath }/user/loginoff.do"><i class="glyphicon glyphicon-off"></i> <span class="nav-label">退出登录</span></a>
                    </li>
                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row border-bottom">
                <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                    <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
                        
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
                        <li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                 <i class="fa fa-bell"></i> <span class="label label-danger" v-if="messageList.length!=0">{{messageList.length}}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-messages" v-if="messageList.length!=0">
                                 <template v-for="message in messageList">
	                                <li class="m-t-xs" >
	                                    <div class="dropdown-messages-box">
	                                        <a href="${basepath }/message/unreadmsg.do" target="iframe0" class="pull-left">
	                                            <span v-if="message.state==1" style="color:green;font-size: 25px;" class="glyphicon glyphicon-ok" aria-hidden="true"></span>
	                                            <span v-else style="color:orange;font-size: 25px;" class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
	                                        </a>
	                                        <a class="media-body" href="${basepath }/message/noread.do" target="iframe0">
	                                            <small class="pull-right"  v-if="message.state==1" style="color:green;">审核通过</small>
	                                            <small class="pull-right"  v-if="message.state==2" style="color:red;">预约失败</small>
	                                            <strong>{{message.situation }}</strong>
	                                            <br>
	                                            <small class="text-muted">{{message.content}}</small>
	                                        </a>
	                                    </div>
	                                </li>
	                                <li class="divider"></li>
                                </template>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="row J_mainContent" id="content-main">
                <iframe class="J_iframe"  name="iframe0" width="100%" height="100%" src="${basepath }/appoint/meeting.do" frameborder="0" data-id="${basepath }/appoint/meeting.do" seamless></iframe>
            </div>
            <div class="footer">
                <div class="pull-right">&copy; 2019 <a href="http://http://ise.ysu.edu.cn/" target="_blank">燕山大学信息科学与工程学院</a>
                </div>
            </div>
        </div>
        <!--右侧部分结束-->
    </div>
    <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basepath }/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="${basepath }/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script src="${basepath }/js/plugins/layer/layer.min.js"></script>
    <script src="${basepath }/js/hplus.min.js?v=4.1.0"></script>
    <script src="${basepath }/js/plugins/toastr/toastr.min.js"></script>
    <script type="text/javascript" src="${basepath }/js/contabs.min.js" ></script>
    <script src="${basepath }/js/vue.min.js"></script>
    <script type="text/javascript">
    $.ajax({
    	url:"${basepath}/message/queryNotRead.do",
    	type:"post",
    	data:{
    		uid:${islogin.id}
    	},
    	dataType:"json",
    	success:function(data){
    		vue.messageList = data;
    	}
    });
    
    var vue = new Vue({
    	el:"#wrapper",
    	data:{
    		messageList:[]
    	},
    	methods:{
    		//由子页面调用
    		updateMsg:function(idList){
    	        for(var j=0;j<idList.length;j++){
    	            for(var i=0;i<this.messageList.length;i++){
    	                if( parseInt(idList[j]) == this.messageList[i].id){
    	                    this.messageList.splice(i,1);
    	                    break;
    	                }
    	            }
    	        }
    		}
    	}
    });
      var websocket = null;
	  //websocket
	  window.onload = function() {
		  toastr.options = {  
	           closeButton: true,                                            // 是否显示关闭按钮，（提示框右上角关闭按钮）
	           debug: false,                                                    // 是否使用deBug模式
	           positionClass: "toast-top-full-width",              // 设置提示款显示的位置
	           "onclick": function() { window.top.iframe0.location.href="${basepath}/message/noread.do" },                                                 // 点击消息框自定义事件 
	           showDuration: "300",                                      // 显示动画的时间
	           hideDuration: "1000",                                     //  消失的动画时间
	           timeOut: null,                                             //  自动关闭超时时间 
	           extendedTimeOut: null,                             //  加长展示时间
	           showEasing: "swing",                                     //  显示时的动画缓冲方式
	           hideEasing: "linear",                                       //   消失时的动画缓冲方式
	           showMethod: "fadeIn",                                   //   显示时的动画方式
	           hideMethod: "fadeOut"               
	        };
	      if ("WebSocket" in window) {
	          websocket = new WebSocket(
	                  "${wbpath}/server/${islogin.account}");
	      } else {
	          console.log("不支持websocket");
	      }
	      websocket.onmessage = function(ev) {
	          var ms=JSON.parse(ev.data);
	          vue.messageList.push(ms);
	          if(ms.state==1){
	        	  toastr.success(ms.situation+" 预约成功（点击查看详情）");
	          }else {
	        	  toastr.error(ms.situation+" 预约失败（点击查看详情）");
	          }
	      };
	  }
	  function closeWebSocket(e) {  
	      websocket.close();
	  }
	  //关闭websokcet
	  if(window.attachEvent){
	      window.attachEvent('onbeforeunload', closeWebSocket);
	  } else {
	      window.addEventListener('beforeunload', closeWebSocket, false);
	  }
    </script>
</body>

</html>
