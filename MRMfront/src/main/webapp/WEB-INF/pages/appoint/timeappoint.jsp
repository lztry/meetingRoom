<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

    <!-- Mirrored from www.zi-han.net/theme/hplus/graph_echarts.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:59 GMT -->

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>按照时间预约</title>
        <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
        <link href="${basepath }/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">

        <link href="${basepath }/css/animate.min.css" rel="stylesheet">
        <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
        <link rel="stylesheet" href="${basepath }/css/plugins/datepicker/bootstrap-datetimepicker.min.css" />
        <link href="${basepath }/css/page.css" rel="stylesheet">
        <link href="${basepath }/css/plugins/sweetalert/sweetalert2.min.css" rel="stylesheet">
        <style>
            .control-label {
                padding-top: 7px;
            }
            #roomList {
                min-height: 400px;
            }
            
        </style>
    </head>

    <body class="gray-bg">
      <div id="app">
        <div class="row  border-bottom white-bg dashboard-header">
            <div class="col-md-5 form-group">
                <label for="startTime" class="col-md-3 control-label">开始时间</label>
                <div class="input-group date form_date col-md-9">
                    <input id="startTime" class="form-control" size="16" type="text" :value="roomquery.startTime" readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
            </div>
            <div class="col-md-3 form-group">
                <label for="duration" class="col-md-4 control-label">会议时长</label>
                <div class="input-group col-md-8">
                    <select class="form-control" id="duration" v-model="roomquery.duration">
                        <option  v-for="num in durationRange" :value="num">{{num}}小时</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4 form-group">
                <label for="duration" class="col-md-3 control-label">结果显示</label>
                <div class="input-group col-md-9">
                    <select class="form-control"  v-model="roomquery.isAllShow">
                        <option value="1">全部显示</option>
                        <option value="2">只显示可预约</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-sm-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>会议室列表</h5>
                        </div>

                        <div class="ibox-content" id="roomList">
                            <h1 id="timeNoFit" align="center" style="display: none;">没有符合条件的会议室</h1>
                            <h1 id="timeHint" align="center"> 请选择时间</h1>
                            <!--表格-->
                            <div id="roomTable" style="display: none;">
                                <table class="table  table-hover">
                                    <thead>
                                        <tr>
                                            <th>会议室名称</th> 
                                            <th>审核</th>
                                            <th>系别</th>
                                            <th>容量</th>
                                            <th>多媒体</th>
                                            <th>最多提前时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                     
                                    <tbody>
                                      <tr v-for="(meetingRoom,index) in roomlist" >
                                            <td><span style="font-weight: bolder;">{{meetingRoom.name }}</span></td>
                                            <td v-if="meetingRoom.isCheck==1"><span style="color: #990000">需要</span></td>
                                            <td v-else><span style="color: #9900FF">不需要</span></td>
                                          
                                            <td>{{meetingRoom.departmentName }}</td>
                                            <td>{{meetingRoom.capacity }}人</td>
                                            <td v-if="meetingRoom.multimedia ==1">
                                                <span v-if="meetingRoom.deviceState ==1">有 </span> 
                                                <span v-else style="color:red">故障</span>
                                            </td>
                                            <td v-else>无</td>
                
                
                                            <td>{{meetingRoom.aheadTime }}天</td>
                                            <td v-if="meetingRoom.roomState==1">
                                                 <button  class="btn btn-primary" @click="selectId=index;roomName=meetingRoom.name;" data-toggle="modal" data-target="#appointModal" >预约</button>
                                            </td>
                                            <td v-if="meetingRoom.roomState==0">
                                                                                                               被{{meetingRoom.realName}}老师</span>预约
                                            </td>
                                            
                                            <td v-if="meetingRoom.roomState==2">
                                                                                                               未到预约时间
                                            </td>
                                        </tr>
                                  
                                    </tbody>
                                </table>
                            </div>
                              
                              <div id="timePagelist" class="pagelist" ></div>
                            
                        </div>
                        
                            <!--分页条-->
                            <div id="timePagelist" class="pagelist" ></div>
                        </div>
                    </div>
                </div>
            </div>
          <!--
            模态框 用来确定预约，添加预约实际联系人
        -->
        <div class="modal fade" tabindex="-1" role="dialog" id="appointModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">预约</h4>
                    </div>
                    <div class="modal-body">
                        <p align="center" style="font-weight: bolder; font-size: larger;">
                            {{roomName}}<br/> 开始时间： {{roomquery.startTime}}<br/> 会议时长：{{roomquery.duration}}小时
                        </p>
                        <form id="appointForm" style="padding-right:10px;" method="post">
                            <div class="form-group">
                                <label class="control-label" style="font-weight: bolder;">实际使用人：</label>
                                <div class="controls">
                                    <input class="form-control" type="text"  value="${islogin.name }" name="realName" id="realName" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label" style="font-weight: bolder;">联系电话：</label>
                                <div class="controls">
                                    <input class="form-control" type="text"  value="${islogin.phone }" name="realPhone" id="realPhone"  />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label" style="font-weight: bolder;">预约原因：</label>
                                <div class="controls">
                                    <textarea  id="reason" name="reason" class="form-control" maxlength="50" rows="3"  v-model="reasonText" ></textarea>
                                    <p style="float:right;">
                                        <em>{{reasonText.length}}/50</em>
                                    </p>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" id="cancelAppoint" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" id="confirmAppoint" >确定预约</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
        <!-- /.modal -->
      </div>
        <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
        <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
        <script src="${basepath }/js/dateFormat.js"></script>
        <script type="text/javascript" src="${basepath }/js/plugins/datepicker/bootstrap-datetimepicker.js"></script>
        <script type="text/javascript" src="${basepath }/js/plugins/datepicker/bootstrap-datetimepicker.zh-CN.js"></script>
        <script src="${basepath }/js/plugins/validate/jquery.validate.min.js"></script>
        <script src="${basepath }/js/plugins/validate/additional-methods.js" ></script>
        <script src="${basepath }/js/plugins/sweetalert/sweetalert2.min.js" ></script>
        <script src="${basepath }/js/vue.min.js"></script>
        <script src="${basepath }/js/page.js"></script>
		<!-- 兼容ie -->
		<script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    </body>
    <script>
       //计算当前整点事件 如果小于6点 初始为6点，如果大于22则为第二天6点 
	    var startDate=new Date(new Date().valueOf() + 1 * 60 * 60 * 1000);
	    if(startDate.getHours()<6){
	        var strDate = startDate.format("yyyy-MM-dd");
	        startDate=toDate(strDate+" 06:00");
	    }
	    else if(startDate.getHours()>=22){
	        var strDate =new Date( startDate.valueOf() +  4* 60 * 60 * 1000).format("yyyy-MM-dd");
	        startDate=toDate(strDate+" 06:00");
	    }
       
        $(function(){
        	 $('.form_date').datetimepicker({
                 language: 'zh-CN',
                 format: "yyyy-mm-dd hh:00",
                 weekStart: 1,
                 startDate: startDate, 
                 pickerPosition: 'bottom-left',
                 todayBtn: 1,
                 autoclose: 1,
                 todayHighlight: 1,
                 startView: 2,
                 minView: 1,
                 forceParse: 0
             });
           //日期修改 
             $('.form_date').datetimepicker()
                 .on('changeDate', function(ev) {
                     var value = $("#startTime").val();                      
                     if(value!=""){
                       app.roomquery.startTime = value;                         
                       app.durationRange = (22 -ev.date.getHours());
                     }
                     else{
                         app.roomquery.startTime="";
                         app.durationRange=0;
                         app.roomquery.duration=0;
                     }
                 });
           //分页条
             $("#timePagelist").on('click','a',function(){
                 var myPageNo = pageNo;
                 switch($(this).attr("id"))
                 {
                 case "0":
                   myPageNo = 1;
                   break;
                 case "-1":
                   myPageNo = totalPage;
                   break;
                 case "-2":
                    myPageNo--; 
                    break;
                 case "-3":
                   myPageNo++;
                    break;    
                 default:
                    myPageNo = $(this).attr("id");
                 }
                 app.roomquery.myPageNo=myPageNo;
            
              }); 
            /*表单验证*/
            //默认样式
            $.validator.setDefaults({
                highlight: function(e) {
                    $(e).closest(".form-group").removeClass("has-success").addClass("has-error")
                },
                success: function(e) {
                    e.closest(".form-group").removeClass("has-error").addClass("has-success")
                },
                errorElement: "span",
                errorPlacement: function(e, r) {
                    e.appendTo(r.parent())
                },
                errorClass: "help-block",
            })
            //错误提示
            var e = "<i class='fa fa-times-circle'></i> ";
            function validform() {     
                return $("#appointForm").validate({
                    onfocusout: function(element) { $(element).valid(); },
                    rules: {     
                     realName:"required",
                     realPhone:{
                        required: !0,
                        isMobile : true 
                     },
                     reason:{
                        required: !0,
                     }
                   },     
                    messages:{     
                    realName: e + "请输入您的名字",
                    realPhone: {
                        required: e + "请输入您的手机号",
                        isMobile : e + "手机号格式不对哟"
                    },
                     reason:{
                        required: e + "请输入预约原因",
                     }
                   }
                });
            }     
            $(validform());
            var result = validform();
            $("#confirmAppoint").click(function(){
                if (result.form()) {
                	 var meetingRoom = app.roomlist[app.selectId];
                	 var realName = $("#realName").val();
                     var realPhone = $("#realPhone").val();
                     var reason=app.reasonText;
                     $("#appointModal").modal('hide');
                     $("#appointForm").validate().resetForm();
                     $(".form-group").removeClass("has-error").removeClass("has-success");
                     var time = toDate(app.roomquery.startTime);
                      var appointAjax= $.ajax({
                         url: "${basepath}/appoint/appoint.do",
                         type:"post",
                         timeout : 20000, //超时时间设置，单位毫秒
                          beforeSend: function () {
                              $("body").append('<div id="pload" style="position:fixed;top:40%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                          },
                          complete: function (XMLHttpRequest,status) {
                              $("#pload").remove();
                              if(status=='timeout'){//超时,status还有success,error等值的情况
                                  appointAjax.abort();
                                       swal({title: '对不起，服务器连接超时',type: 'warning', allowOutsideClick:false,confirmButtonText: '关闭',animation:false});
                                 }
                          },
                         data:{
                             "roomId": meetingRoom.id,
                             "isCheck": meetingRoom.isCheck,
                             "userId": ${islogin.id},
                             "appointTime":time.format("yyyy-MM-dd"),
                             "appointStart":time.getHours(),
                             "appointEnd": time.getHours()+app.roomquery.duration,
                             "realName":realName,
                             "realPhone":realPhone,
                             "reason":reason
                         },
                         success: function(data) {
                            console.log(data);
                             if(data=='0'){
                                 swal({
                                     title: '对不起',
                                     text: "此时间段会议室已被预约，请选择其他时间或预约其他会议室",
                                     type: 'warning',
                                     allowOutsideClick:false,
                                     confirmButtonText: '关闭',
                                 }).then(function(result){
                                     if (result.value) {
                                         window.location.reload();     
                                         }
                                    });
                             }
                             else{
                                
                                 app.selectId=-1;
                                 if(meetingRoom.isCheck == 1){
                                   // alert("申请成功,");
                                    swal({
                                        title: '申请成功',
                                        text: "等待管理员审核，请关注通知消息",
                                        type: 'success',
                                        allowOutsideClick:false,
                                        confirmButtonText: '确定',
                                    });
                                 }
                                 else{
                                    swal({
                                        title: '预约成功',
                                        type: 'success',
                                        allowOutsideClick:false,
                                        confirmButtonText: '确定',
                                    });
                                     for(var i=0;i<app.roomlist.length;i++){
                                         if(app.roomlist[i].id==meetingRoom.id){
                                             var room = app.roomlist[i];
                                             room.roomState=0;
                                             room.realName=realName;
                                             app.$set(app.roomlist,i,room)
                                             break;
                                         }
                                     }
                                 }
                             }
                         }
                     });
                }
            })
            $("#cancelAppoint").click(function(){
                $("#appointForm").validate().resetForm();
                $(".form-group").removeClass("has-error").removeClass("has-success");
            })
        })
          //时间tap 的分页条属性选项
            var pageNo;
            var totalPage;
            var app = new Vue({
                el:"#app",
                data:{
                    roomName:"",
                    durationRange:0,
                    reasonText:"",
                    selectId:-1,
                    roomlist:[],
                    roomAjax:null,
                    roomquery:{
                        startTime:"",
                        duration:0,
                        myPageNo:1,
                        isAllShow:1
                    }
                },
                computed:{
                    getIsAllShow:function(){
                        return this.roomquery.isAllShow;
                    }
                },
                /*
                  只要roomquery中的属性发生变化（可被监测到的），便会执行handler函数；
                                           如果想监测具体的属性变化，如isAllShow变化时，才执行handler函数，则可以利用计算属性computed做中间层。
                */
                watch:{
                    roomquery:{
                        handler:function(val,oldval){
                            $("#timeNoFit").hide();
                            var durationRange = this.durationRange;
                            var duration = val.duration;
                            var startTime = val.startTime;
                            var myPageNo = this.roomquery.myPageNo;
                            
                            if(durationRange < duration || startTime == "" ){
                                this.duration = 0;
                                duration = 0;
                            }
                            if(startTime!="" && duration!=0){
                                $("#timeHint").hide();
                                //字符串时间转js date
                                var dateStartTime = toDate(startTime);
                                 $("#timePagelist").show();
                                 var url="${basepath}/room/find.do";
                                 if(val.isAllShow == "2"){
                                    url="${basepath}/room/findusable.do";
                                    
                                 }
                                 var currentAjax= $.ajax({
                                     url: url,
                                     type:"post",
                                     async:true,
                                     timeout : 20000, //超时时间设置，单位毫秒
                                     data: {
                                         end:dateStartTime.getHours()+duration,
                                         start:dateStartTime.getHours(),
                                         userScale:${islogin.scale},
                                         departmentId:${islogin.departmentId},
                                         appointTime:dateStartTime.format("yyyy-MM-dd"),
                                         pageNo:myPageNo
                                     },
                                     beforeSend: function () {
                                         $("body").append('<div id="pload" style="position:fixed;top:50%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                                     },
                                     complete: function (XMLHttpRequest,status) {
                                         $("#pload").remove();
                                       
                                         if(status=='timeout'){//超时,status还有success,error等值的情况
                                                  currentAjax.abort();
                                                  swal({
                                                      title: '对不起，服务器连接超时',
                                                      type: 'warning',
                                                      allowOutsideClick:false,
                                                      timer: 3500,
                                                      confirmButtonText: '关闭',
                                                  });
                                            }
                                     },
                                     dataType: "json",
                                     success: function(data) {
                                         //console.log(data);
                                         app.roomlist = data.resultList;
                                         //console.log(this.roomlist);
                                         $("#roomTable").show();
                                         $("#timePagelist").empty();
                                         pageNo = data.page.pageNo;
                                         totalPage = data.page.pages;
                                         if(totalPage != 0){
                                             $("#timePagelist").mypage({
                                                   pageNo:pageNo,
                                                   totalPage:data.page.pages
                                               }); 
                                         }
                                         else{
                                             $("#timeNoFit").show();
                                             $("#roomTable").hide();
                                         }
                                     }
                                 }); 
                            }
                            else{
                                app.roomlist=[];
                                $("#timeHint").show();
                                $("#roomTable").hide();
                                $("#timePagelist").hide();
                            }   
                        },
                        deep:true//对象内部的属性监听，也叫深度监听
                    }
                },
            });
          
    </script>

    <!-- Mirrored from www.zi-han.net/theme/hplus/graph_echarts.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:18:59 GMT -->

</html>