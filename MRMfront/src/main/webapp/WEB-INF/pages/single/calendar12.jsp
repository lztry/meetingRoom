<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>预约时间表</title>
<link href='../css/fullcalendar.min.css' rel='stylesheet' />
<link href='../css/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<link href="${basepath}/AmazeUI-2.4.2/assets/css/amazeui.css" rel="stylesheet" type="text/css" />
        <link href="${basepath}/AmazeUI-2.4.2/assets/css/admin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="${basepath}/AmazeUI-2.4.2/assets/css/app.css"/>
<script src='../js/moment.min.js'></script>
<script src='../js/jquery.min.js'></script>
<script src='../js/fullcalendar.min.js'></script>
<script src='../js/bootstrap.min.js'></script>
<script src="../js/vue.min.js"></script>
<link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
<style>
  body {
    margin: 40px 10px;
    padding: 0;
    font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
   
  }

  #calendar {
    max-width: 900px;
    margin: 30px auto;
  }
  
  .done:before {
            content:"【 已审核】";
            background-color:yellow;
            color:green;
            text-align:center;
            font-weight:bold;
            width:100%;
        }
        /* Event 参数 className 的值 */
        .doing:before {
            content:"【 未审核 】";
            background-color:yellow;
            color:red;
            text-align:center;
            font-weight:bold;
        }
        
        /*导航条 左上角图标*/
        .am-topbar .am-text-ir {
             display: block;
             margin-left:10px;
             margin-right: 10px;
             height: 50px;
             width: 100px;
             background: url(${basepath}/img/ysuLogo.png) no-repeat left center;
             -webkit-background-size: 100px 45px;
             background-size: 100px 45px;
        }

</style>
</head>

<body>
<script>
	var riqi;
	var kaishi;
	var jieshu;
  $(document).ready(function() {
	    if(${isexist }==1)
	    {
	    	alert("您所选时间已被预约，请选其他时间");
	    }
		
	
	function getNowFormatDate() {
	        var date = new Date();
	        var seperator1 = "-";
	        var year = date.getFullYear();
	        var month = date.getMonth() + 1;
	        var strDate = date.getDate();
	        if (month >= 1 && month <= 9) {
	            month = "0" + month;
	        }
	        if (strDate >= 0 && strDate <= 9) {
	            strDate = "0" + strDate;
	        }
	        var currentdate = year + seperator1 + month + seperator1 + strDate; 
	        return currentdate;
	}
	 var events =[];
    $('#calendar').fullCalendar({
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'agendaWeek,agendaDay,listWeek'
      },
      handleWindowResize : true, //自适应
      slotLabelFormat : "H(:mm)a",
      slotDuration : "01:00:00",      //一格时间槽代表多长时间，默认00:30:00（30分钟） 
      defaultView: 'agendaWeek',
      defaultDate: getNowFormatDate(),
      navLinks: true, // can click day/week names to navigate views
      weekNumbers: true,
      weekNumbersWithinDays: true,
      weekNumberCalculation: 'ISO',
      buttonText : {today:'今天',month:'月',week:'周',day:'日',listWeek:'列表'},  //对应顶部操作按钮的名称自定义  
      monthNames : ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"], //月份自定义命名  
      monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"], //月份缩略命名（英语比较实用：全称January可设置缩略为Jan）  
      dayNames: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],       //同理monthNames  
      dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],  //同理monthNamesShort  
      weekNumberTitle : "周",         
      editable: false,
      eventLimit: true, // allow "more" link when too many events
      minTime : "06:00:00",           //周/日视图左边时间线显示的最小日期，默认00:00:00  
      maxTime : "22:00:00",           //周/日视图左边时间线显示的最大日期，默认24:00:00  
      timeFormat: 'H:mm',
      contentHeight :"auto",   
      allDaySlot : false,   //视图在周视图、日视图顶部显示“全天”信息，默认true显示全天  
      selectable : true,
      slotEventOverlap 	: false,
      longPressDelay : 300,
      selectHelper:true,
      events: function(start,end, timezone,callback){
          var date = this.getDate().format("YYYY-MM-DD");
          $.ajax({
          url:"${basepath}/single/display.do",
          data: {"roomid": ${room.id}},
          dataType: "json",
          success:function(res){
        	     events =[];
                 for(i in res){ 
                		 events.push({
                             id:res[i].id,
                             //title:res[i].reason,
                             start:new Date(res[i].start),
                             end:new Date(res[i].end),
                             state:res[i].state,
                             className:'done'
                             });               
                 }
                 callback(events);
          },
          error:function(errMsg){
              alert("数据传输失败");
          },
          
          }); 
      },
      select: function( startDate, endDate, allDay, jsEvent, view ){
    	  var start = new Date(startDate.format());
		  var end = new Date(endDate.format());
		  var line = new Date(new Date(startDate.format('YYYY-MM-DD')).getTime()+24*60*60*1000-1);
		  var top = new Date(new Date().getTime());
		  if(start<top){
			  return ;
		  }
    	  if(end<line)
    	  {
    		  for(i in events){
        			  if(end>events[i].start&&end<=events[i].end)
            		  {
            			  alert("亲爱的老师，时间冲突");
            			  window.location.reload();
            			  return ;
            		  }
            		  else if(end>events[i].end&&start<events[i].start)
            		  {
            			  alert("亲爱的老师，时间冲突");
            			  window.location.reload();
            			  return ;
            		  }
            		  else if(start>events[i].start&&start<events[i].end)
                      {
                          alert("亲爱的老师，时间冲突");
                          window.location.reload();
                          return ;
                       }

            		  else{
            			    console.log("123");
            		  }	
        	  }
    	  }
    	  else{
    		alert("请选择当天时间");
    		window.location.reload();
    		return ;
    	  }
    	 
    	  riqi = startDate.format('YYYY-MM-DD');
    	  kaishi = startDate.format('HH');
    	  jieshu =endDate.format('HH');
    	  $("#add").trigger("click"); 
    	  console.log('select选中的时间为：', startDate.format('hh'));
    	  console.log('select选中的时间为：', new Date(endDate.format()));
      },
      dayClick : function( date ) {
    	    //do something here...
    	    console.log('dayClick触发的时间为：', date.format());
    	    // ...
    	}
    });

  });
 
</script>
<div id="app">
   <!--顶部导航条 -->
   <div id="navigation" style="height: 50px;">

   </div>
   <div class="panel panel-success" style="margin: 0 auto;max-width: 900px;">
        <div class="panel-heading" style="text-align:center;">预约信息</div>
        <div class="panel-body" style="text-align:center;">
        <span>地点：{{roomname}}</span>
        </div>
    </div>
  <div id='calendar'></div>
  <button id="add" style="display:none" data-toggle="modal" data-target="#passModal" @click="refresh"> </button>
  <div class="modal" tabindex="-1" role="dialog" id="passModal">
         <div class="modal-dialog" role="document">
             <div class="modal-content">
                 <div class="modal-header">
                     <button type="button" class="close"  data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                     <h6 class="modal-title">确认预约信息</h6>
                 </div>
                 <form method="post" action="${basepath}/single/add.do">
                 <div class="modal-body">
                     <p  align="center" style="font-weight: bolder;font-size: 20px; ">
							会议室：{{roomname}}
                     </p>
                     <p  align="center" style="font-weight: bolder;font-size:20px; ">
							预约时间：{{riqi}}&nbsp;{{kaishi}}:00-{{jieshu}}:00
                     </p>
                     <input type="hidden" name="roomId" :value="roomid">
                     <input type="hidden" name="userId" value="${islogin.id }">
                     <input type="hidden" name="appointTime" :value="riqi">
                     <input type="hidden" name="appointStart" :value="kaishi">
                     <input type="hidden" name="appointEnd" :value="jieshu">
                      <div class="input-group">
                      <font size="3px">申请人：</font><input type="text" name="realName" class="form-control" value="${islogin.name }">
                      </div>
                      <div class="input-group">
                      <font size="3px">手机号：</font><input type="text" name="realPhone" class="form-control" id="phone" value="${islogin.phone }">
                       <span id="sss" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                      </div>
                     <font size="3px">请填写申请原因：</font>
                     <textarea class="form-control" name="reason" maxlength="50" id="message-text" rows="3" style="padding: 5px;font-size:18px;" v-model="reasonText"></textarea>
                     <p class="textarea-numberbar" style="font-size:15px;" align="right"><em class="textarea-length">{{reasonText.length}}</em>/<am>50</am></p>
                
                 </div>
                 <div class="modal-footer">
                     <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                     <button type="submit" class="btn btn-primary" id="submit">确认预约</button>                     
                 </div>
                 </form>
             </div>
         </div>
  </div>
</div>
  <script src="${basepath}/js/navigation.js"></script>
<script>
var vue=new Vue({
	el:"#app",
	data:{
		riqi:riqi,
		kaishi:kaishi,
		jieshu:jieshu,
		roomid:${room.id},
		roomname:"${room.name}",
		reasonText:""   //驳回模态框的输入
	},
	methods:{
		refresh:function(){
			this.riqi = riqi;
			this.kaishi = kaishi;
			this.jieshu = jieshu;
		}
	}
}); 
   $(function(){
	    $("#navigation").navigation({
	        mainpage:"${basepath}/index.do",
	        person:"${basepath}/user/person.do",
	        appoint:"${basepath}/user/appoint.do"
	    });
	    
	    var websocket = null;
        window.onload = function() {
            if ("WebSocket" in window) {
                websocket = new WebSocket(
                        "ws://127.0.0.1:8080/MRMback/server/"+${islogin.account});
                console.log(websocket);
            } else {
                console.log("不支持");
            }
            websocket.onmessage = function(ev) {
                alert(ev.data);
                
            };
            websocket.onerror = function(event) {
                
            };
            
            websocket.onopen = function() {
                alert("jsp连接成功");
            };
        }
        
        $("#submit").click(function() {
            websocket.send("newinform");
     });

        function test(e) {  
            websocket.close();
        }

        if(window.attachEvent){
        window.attachEvent('onbeforeunload', test);
        } else {
        window.addEventListener('beforeunload', test, false);
        }
	    
	});
    
</script>
  
       
        
</body>
</html>