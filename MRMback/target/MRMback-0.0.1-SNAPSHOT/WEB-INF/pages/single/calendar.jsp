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

<link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
<link href='../css/fullcalendar.min.css' rel='stylesheet' />
<link href='../css/fullcalendar.print.min.css' rel='stylesheet' media='print' />
 <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css" />
<script src='../js/jquery.min.js'></script>
<script src='../js/moment.min.js'></script>
<script src='../js/fullcalendar.min.js'></script>
<script src='../js/bootstrap.min.js'></script>
<script src="../js/vue.min.js"></script>
 <script type="text/javascript" src="${basepath}/js/jquery.form.js"></script>
<script src="${basepath}/dist/sweetalert2.min.js"></script>
<style>
 [v-cloak]{display:none}
body,
 html {
     padding: 0px;
     margin: 0px;
     height: 100%;
     font-size: 15px;
 }
  #calendar {
   max-width:1000px;
   margin-top:10px;
    font-size: 19px;
  }
  .fc-toolbar.fc-header-toolbar {
     font-size: 15px;
  }
  
  
  .done {
            background-color:DarkGray;
            width:100%;
        }
   .check {
            background-color:red;
            width:70%;
        }
       .nodone{
           background-color: red;
           border-width: 0;
           margin: 0;
           padding: 0;
           width: 110%;
       }
       
         .bottomTip{
              color:#b94a48;
              display: none;
            
            }
          .legendDiv{
             display:inline-block;
             
             width: 15px;
             height: 15px;
             
          }


</style>
</head>

<body>
<div id="app" v-cloak>
  <a href="${basepath }/room/meetingRoom.do"><button class="btn btn-primary" style="margin-left: 20px;margin-top: 20px;">返回</button></a>
   <div class="container-fluid">
      
	  <div class="row">
	      
	        <div class="col-md-3" style="font-size: 16px;margin-top: 2%;padding-left: 30px;">
                <div class="row">
                <div class="panel panel-success">
                    <div class="panel-heading">会议室信息</div>
                    <div class="panel-body">
                        ${room.departmentName}<br/>
                        ${room.name}<br/>
                                                          容量：${room.capacity}人<br/>
                                                           级别:
				                        <c:if test="${ room.scale==1}">
				                      普通
				               </c:if>
				                <c:if test="${ room.scale==2}">
				                       中级
				               </c:if>
				               <c:if test="${ room.scale==3}">
				                       高级
				               </c:if> <br/>
				          
				                          多媒体:
				               <c:if test="${ room.multimedia==1}">
				                 <c:if test="${ room.deviceState!=1}">故障</c:if>
				                 <c:if test="${ room.deviceState==1}">完好</c:if>
				               </c:if>
				               <c:if test="${ room.multimedia==0}">
				                                无
				               </c:if><br/>
				              <c:if test="${ room.isCheck==0}">
				                          不
				              </c:if>
				                     需要审核
                     </div>
                 </div>
                </div>
                 <div class="row">
                <div class="panel panel-info">
                    <div class="panel-heading">图例</div>
                    <div class="panel-body">
                        <ul>
                          <li>可以预约 <div class="legendDiv" style="background-color: #8fdf82;opacity: 0.4;border: 1px solid black;"></div></li>
                          <li>已被预约 <div class="legendDiv" style="background-color:DarkGray; border: 1px solid black;"> </div></li>
                          <li>选择时间 <div class="legendDiv" style="background-color: #337ab7;border: 1px solid black; "></div></li>
                          <li>不可预约 <div class="legendDiv"><img class="legendDiv" src="${basepath }/img/forbid.jpg"></div></li>
                          <li>待审核 <div class="legendDiv" style="background-color:#B22222;opacity: 0.4;border: 1px solid black;"></div>(颜色越深，数量越多)</li>
                        </ul>
                                                                    
                     </div>
                 </div>
                </div>
            </div>
	      
	      
		  
		    <div class="col-md-9">
		    <div id='calendar' class="fc fc-ltr"></div>
		    </div>
	  </div>
  </div>
 
 
  <button id="add" style="display:none" data-toggle="modal" data-target="#myModal" @click="refresh"> </button>
 
  <div class="modal" tabindex="-1" role="dialog" id="myModal" >
         <div class="modal-dialog" role="document">
             <div class="modal-content">
                 <div class="modal-header">
                     <button type="button" class="close"  data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                     <h4 class="modal-title">确认预约信息</h4>
                 </div>
                 
                 <div class="modal-body">
                 <form id="appointForm" method="post" action="${basepath}/single/add.do"  >
                     <div  align="center" style="font-weight: bolder;font-size: 20px; ">
							会议室：{{roomname}}
                     </div>
                     <div  align="center" style="font-weight: bolder;font-size:20px; ">
							预约时间：{{riqi}}&nbsp;{{kaishi}}:00-{{jieshu}}:00
                     </div>
                     <input type="hidden" name="roomId" :value="roomid">
                     <input type="hidden" name="userId" value="${islogin.id }">
                     <input type="hidden" name="appointTime" :value="riqi">
                     <input type="hidden" name="appointStart" :value="kaishi">
                     <input type="hidden" name="appointEnd" :value="jieshu">
                   
                      <div class="form-group">
                         <label for="realName" class="control-label">申请人：</label>
                         <input type="text"  class="form-control formGroup" value="${islogin.name }" name="realName" id="realName" onblur="isNameEmpty(this.value)"/>
                         <div class="bottomTip" id="nameTip" >请输入实际使用人名字</div>
                      </div>
                      <div class="form-group">
                       <label>手机号：</label><input type="text"   class="form-control formGroup" value="${islogin.phone }" name="realPhone" id="realPhone" onblur="isPhone(this.value)"/>
                       <div class="bottomTip" id="phoneTip"></div>
                      </div>
                     
                     <div class="form-group">
                     <label >请填写申请原因：</label>
                     <textarea class="form-control formGroup"   name="reason" maxlength="50" id="reason" rows="3" style="padding: 5px;" v-model="reasonText"  onblur="isReasonEmpty(this.value)"></textarea>
                        <div class="bottomTip" id="reasonTip" style=" float:left"></div>
                         <div style="float:right; ">
                            <em>{{reasonText.length}}/50</em>
                        </div> 
                     </div>  
                      </form>             
                 </div>
                 <div class="modal-footer">
                     <button type="button" class="btn btn-default" data-dismiss="modal" >取消</button>
                     <button type="button" class="btn btn-primary" @click="appoint" id="submit">确认预约</button>                     
                 </div>
                
             </div>
         </div>
  </div>
 
</div>
<!--引导 -->
      
<script src="${basepath}/js/verify.js"></script>
<!-- 兼容ie -->
<script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
<script>
//日期格式化
Date.prototype.format = function(fmt) { //author: meizz   
    var o = {
        "M+": this.getMonth() + 1, //月份   
        "d+": this.getDate(), //日   
        "h+": this.getHours(), //小时   
        "m+": this.getMinutes(), //分   
        "s+": this.getSeconds(), //秒   
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度   
        "S": this.getMilliseconds() //毫秒   
    };
    if(/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for(var k in o)
        if(new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
function toDate(dateStr) {  
    var params = [0,0,0,0,0,0];
    var dataArr = dateStr.split(/\s|\-|\:/g);
   
    for(var i =0;i<dataArr.length;i++){
        params[i] =parseInt(dataArr[i]) ;
    }
   return new Date(params[0],params[1]-1,params[2],params[3],params[4],params[5]);
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

    var riqi;
    var kaishi;
    var jieshu;
    var maxTime = ${room.aheadTime}*24*3600*1000;
  $(document).ready(function() {
      
    
     var events =[];
    $('#calendar').fullCalendar({
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'agendaWeek,agendaDay'
      },
     
      handleWindowResize : true, //自适应
      
      slotLabelFormat : 'H:mm',
      slotDuration : "01:00:00",      //一格时间槽代表多长时间，默认00:30:00（30分钟） 
      defaultView: 'agendaWeek',
      defaultDate: getNowFormatDate(),
      navLinks: true, // can click day/week names to navigate views
   //   weekNumbers: true, 显示周数
    //  weekNumbersWithinDays: true,
      weekNumberCalculation: 'ISO',
      buttonText : {today:'今天',month:'月',week:'周',day:'日',listWeek:'列表'},  //对应顶部操作按钮的名称自定义  
      monthNames : ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"], //月份自定义命名  
      monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"], //月份缩略命名（英语比较实用：全称January可设置缩略为Jan）  
      dayNames: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],       //同理monthNames  
      dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],  //同理monthNamesShort  
      weekNumberTitle : "周",         
      editable: false,
      eventLimit: true, // allow "more" link when too many events
      eventLimitText  : "更多",
      minTime : "06:00:00",           //周/日视图左边时间线显示的最小日期，默认00:00:00  
      maxTime : "22:00:00",           //周/日视图左边时间线显示的最大日期，默认24:00:00  
      timeFormat: 'H:mm',
      contentHeight :"auto",   
      allDaySlot : false,   //视图在周视图、日视图顶部显示“全天”信息，默认true显示全天  
      selectable : true,
      slotEventOverlap  : false,
      selectOverlap:true,//确定是否允许用户选择事件占用的时间段
      unselectAuto:false, //设置当点击页面其他地方的时候，是否清除已选择的区域
      longPressDelay : 300,
      selectHelper:true,
      selectAllow : function(selectInfo){ //精确的编程控制用户可以选择的地方，返回true则表示可选择，false表示不可选择  
   	    //  console.log( selectInfo.start.toArray());
   	      var params = selectInfo.start.toArray();
   	      var start =   new Date(params[0],params[1],params[2],params[3],params[4],params[5]);
   	      params = selectInfo.end.toArray();
   	      var end = new Date(params[0],params[1],params[2],params[3],params[4],params[5]);
   	      if(start.getDay()!=end.getDay())
   	          return false;
   	      var top = new Date().getTime();
   	      var deadline =(new Date().getTime()+maxTime);
   	      if(start.getTime()<top){            
   	          return false;
   	      }
   	      if(end.getTime() > deadline || start.getTime() > deadline)
   	          return false;
   	      for(i in events){
   	          if(events[i].state!=0&&i!=0){
   	              if(end.getTime()>events[i].start.getTime()&&end.getTime()<=events[i].end.getTime())
   	                  return false;
   	              else if(end.getTime()>events[i].end.getTime()&&start.getTime()<events[i].start.getTime())
   	                  return false;
   	              else if(start.getTime()>events[i].start.getTime()&&start<events[i].end.getTime())
   	                  return false;
   	          }
   	  }
   	      return true;  
   	  },  
      events: function(start,end, timezone,callback){

          $.ajax({
          url:"${basepath}/single/display.do",
          data: {
              "roomid": "${room.id}",
              "queryStart":start.format("YYYY-MM-DD"),
             // "queryEnd":new Date(toDate(end.format("YYYY-MM-DD")).getTime()-1000*60*60).format("yyyy-MM-dd")
              "queryEnd":end.format("YYYY-MM-DD")
              },
              type:"post",
              timeout : 20000, //超时时间设置，单位毫秒
              beforeSend: function () {
                  $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
              },
              complete: function (XMLHttpRequest,status) {
                  $("#pload").remove();
                  if(status=='timeout'){//超时,status还有success,error等值的情况
                      appointAjax.abort();
                           swal({
                               title: '对不起，服务器连接超时',
                               type: 'warning',
                               allowOutsideClick:false,
                               timer: 3500,
                               confirmButtonText: '关闭',
                               animation:false
                           });
                          
                     }
              },
          dataType: "json",
          success:function(res){
             // console.log(res);
            //  alert( new Date().dateFormat("yyyy-MM-ddThh:00"));
                 events=[{
                      start:toDate( new Date(new Date().getTime()+1000*60*60).format("yyyy-MM-dd hh:00")),
                      end: toDate(new Date(new Date().getTime()+maxTime).format("yyyy-MM-dd hh:00")),
                      rendering: 'background'
                  }];
                 var check =[]
                 for(i in res){
                    //将后台时间 先拼接成正常时间 然后 转为JS date
                     startStr = res[i].appointTime+" "+res[i].appointStart+":00";
                     endStr = res[i].appointTime+" "+res[i].appointEnd+":00";
                     if(res[i].state==1){
                         events.push({
                             id:res[i].id,
                             title:res[i].realName,
                             start:toDate(startStr),
                             end:toDate(endStr),
                             state:res[i].state,
                             className:'done',                            
                             });
                     }
                     else{
                        events.push({
                         rendering: 'background',
                         start:toDate(startStr),
                         end:toDate(endStr),
                         state:res[i].state,
                         backgroundColor:"red"
                         }); 
                     }
                 }
                 callback(events);
          },
          error:function(errMsg){
              swal({
                  title: '对不起，服务器异常',
                  type: 'warning',
                  allowOutsideClick:false,
                  timer: 3500,
                  confirmButtonText: '关闭',
                  animation:false
              });
          },
          
          }); 
      },
      select: function( startDate, endDate, allDay, jsEvent, view ){
    	  var start = new Date(startDate.format());
          var end = new Date(endDate.format());
          riqi = start.format('yyyy-MM-dd');
          kaishi = start.format('hh');
          jieshu = end.format('hh');
          for(i in events){
              if(events[i].state ==0){
                  if(!(start.getTime() >=events[i].end.getTime()||end.getTime()<=events[i].start.getTime())) {
                      swal({
                          title: '存在待审批预约',
                          text: '当前时间段有预约申请待审批，您确定还要继续预约吗？',
                          type: 'warning',
                          showCancelButton: true,
                          focusConfirm: false,
                          allowOutsideClick:false,
                          confirmButtonText: '确定',
                          cancelButtonText:'取消',
                          focusConfirm: false,
                     
                      }).then(function(result){
                          if (result.value) {
                              $("#add").trigger("click");    
                          }
                          else if (result.dismiss === swal.DismissReason.cancel) {
                              $('#calendar').fullCalendar('unselect'); 
                          }
                      });
                      return false;
                  }
              }
          }
          $("#add").trigger("click");   
      },
      
    });
    $('#myModal').on('hidden.bs.modal', function (e) {
         $(".bottomTip").hide();
         $(".form-control").parent().removeClass("has-error");
         $('#calendar').fullCalendar('unselect');  
         vue.reasonText="";
    });
  });

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
			},
			appoint:function(){
			 
			
			  if(isPhone($("#realPhone").val())&&isReasonEmpty($("#reason").val())&&isNameEmpty($("#realName").val())){
				  $("#add").trigger("click");
			      $('#calendar').fullCalendar('unselect');
				  $("#appointForm").ajaxSubmit({
					  timeout : 20000, //超时时间设置，单位毫秒
	                  beforeSend: function (XMLHttpRequest) {
	                	  $("body").append('<div id="pload" style="position:fixed;top:50%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
	                  },
	                  complete: function (XMLHttpRequest,status) {
	                      $("#pload").remove();
	                      if(status=='timeout'|| status=='error'){//超时,status还有success,error等值的情况
	                    	  XMLHttpRequest.abort();
	                               swal({
	                                   title: '对不起，服务器连接超时',
	                                   type: 'warning',
	                                   allowOutsideClick:false,
	                                   timer: 3500,
	                                   confirmButtonText: '关闭',
	                                   animation:false
	                               });
	                              
	                         }
	                  },
					  success:function(data){
						  if(data == "1"){
		                         if(${room.isCheck} == 1)
		                            // alert("您的预约已提交，等待管理员审核");
		                             swal({
		                                 title: '申请成功',
		                                 text: "请等待管理员审核，随时关注通知消息",
		                                 type: 'success',
		                                 allowOutsideClick:false,
		                                 allowEscapeKey:false,
		                              //   animation:false , //动画
		                                 confirmButtonText: '确定',
		                              
		                             }).then(function(result){
		                                  if (result.value) {
		                                      window.location.reload();     
		                                      }
		                                 });
		                        else
		                             swal({
		                                 title: '预约成功',
		                                 type: 'success',
		                                 allowOutsideClick:false,
		                                 allowEscapeKey:false,
		                                 confirmButtonText: '确定',
		                             }).then(function(result){
		                                  if (result.value) {
		                                      window.location.reload();     
		                                      }
		                                 });
		                     }
		                     else{
		                         swal({
		                             title: '对不起',
		                             text: "此时间段会议室已被预约，请选择其他时间",
		                             type: 'warning',
		                             allowOutsideClick:false,
		                             confirmButtonText: '关闭',
		                        
		                         }).then(function(result){
		                             if (result.value) {
		                                 window.location.reload();     
		                                 }
		                            });
		                     }
					  }
				  });
			  }
				
			}
		}
	}); 
	   
    
</script>
  
       
        
</body>
</html>