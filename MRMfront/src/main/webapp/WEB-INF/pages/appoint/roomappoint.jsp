<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <title>按照会议室预约</title>

    <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
    <link href="${basepath }/css/page.css" rel="stylesheet">
    <link href="${basepath }/css/plugins/sweetalert/sweetalert2.min.css" rel="stylesheet">
</head>
<style>
 [v-cloak]{display:none}
</style>
<body class="gray-bg">
    <div id="app" class="wrapper wrapper-content animated fadeInRight" v-cloak>
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>会议室列表</h5>
                    </div>
                    <div class="ibox-content">
                         <div class="input-group col-md-offset-7 col-md-5">
                            <input type="text" placeholder="查找会议室" class="input form-control" v-model="search">
                            <span class="input-group-btn">
                                <button type="button" class="btn btn btn-primary"  @click="changeRoom()"> <i class="fa fa-search"></i> 搜索</button>
                            </span>
                            
                        </div>
                               
                        <div class="table-responsive">
                           <table class="table table-hover">
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
                                     <tr v-for="meetingRoom in allRoomList" >
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
                                        <td >
                                             <a href="javascript:void(0);" @click="jumpMeeting(meetingRoom.id)" class="btn btn-primary"   >去预约</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                             <h1 id="roomNoFit" align="center" style="display: none;">没有符合条件的会议室</h1>
                             <div id="roomPagelist" class="pagelist" ></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basepath }/js/plugins/sweetalert/sweetalert2.min.js" ></script>
    <script src="${basepath }/js/vue.min.js"></script>
    <script src="${basepath }/js/page.js"></script>
    <!-- 兼容ie -->
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script type="text/javascript">
    
    var roomTotalPage;
    var roomPageNo;
    $(function(){
    	 $.ajax({
             url:"${basepath}/room/findusable.do",
             type:"post",
             async:false,
             timeout : 20000, //超时时间设置，单位毫秒
             data: {
                 userScale:${islogin.scale},
                 departmentId:${islogin.departmentId},
             },
             dataType: "json",
             success: function(data) {
            	 app.allRoomList = data.resultList;
            	 roomPageNo = data.page.pageNo;
                 roomTotalPage = data.page.pages;
                 if(roomTotalPage != 0){
                     $("#roomNoFit").hide();
                     $("#roomPagelist").mypage({
                           pageNo:roomPageNo,
                           totalPage:data.page.pages
                       }); 
                 }
                 else{
                     $("#roomNoFit").show();
                 }
             }
    	 });
    	  //会议室tab 分页条点击
        $("#roomPagelist").on('click','a',function(){
            var myPageNo = roomPageNo;
            switch($(this).attr("id"))
            {
            case "0":
              myPageNo = 1;
              break;
            case "-1":
              myPageNo = roomTotalPage;
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
            app.roomMyPageNo=myPageNo;
         }); 
    })
  
     var app = new Vue({
         el:"#app",
         data:{
        	 roomName:"",
        	 search:"",
             allRoomList:[],
             roomMyPageNo:1,
         },
         methods:{
        	 changeRoom:function(){
        		 var roomAjax = $.ajax({
                     url:"${basepath}/room/findusable.do",
                     type:"post",
                     async:true,
                     timeout : 20000, //超时时间设置，单位毫秒
                     beforeSend: function (XMLHttpRequest) {
                         $("#pload").remove();
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
                                  });
                                 
                            }
                     },
                     data: {
                         userScale:${islogin.scale},
                         departmentId:${islogin.departmentId},
                         pageNo:app.roomMyPageNo,
                         location:app.search
                     },
                     dataType: "json",
                     success: function(data) {
                         $("#roomPagelist").empty();
                         app.allRoomList=data.resultList;
                         roomPageNo = data.page.pageNo;
                         roomTotalPage = data.page.pages;
                         if(roomTotalPage != 0){
                             $("#roomNoFit").hide();
                             $("#roomPagelist").mypage({
                                   pageNo:roomPageNo,
                                   totalPage:data.page.pages
                               }); 
                         }
                         else{
                             $("#roomNoFit").show();
                         }
                     }
                 });
        	 },
        	 jumpMeeting:function(roomId){
        		 window.location.href="${basepath}/single/calendar.do?roomid="+roomId;
        	 }
         }
     })
    </script>
</body>
</html>
