 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>预约信息</title>
        <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
        <link href="${basepath}/css/page.css" rel="stylesheet"/>
         <link href="${basepath }/css/plugins/sweetalert/sweetalert2.min.css" rel="stylesheet">
       <style>
         html,body{
            font-size: 14px;
            padding: 0px 5px ;
        padding-top: 3px;
         }
         [v-cloak]{display:none}
       </style>   
</head>
<body>
	   <div id="wrap" v-cloak>
           <div class="table-responsive" >
                  <div class="input-group" style="padding: 10px;width: 300px;float: right; ">
				      <input type="text" class="form-control" placeholder="请输入会议室名称" id="searchInput">
				      <span class="input-group-btn">
				          <button class="btn btn-primary" type="button" @click="search()" >搜索</button>
				      </span>
				  </div><!-- /input-group -->
				  <div id="delDiv" style="display:none;">
                       <label>
                           <input type="checkbox"  v-model="checkall" @click="checkAll()">
                                                              全选
                      </label>
                      <button type="button" class="btn btn-danger" @click="del()">删除</button>
                  </div>
                 <table class="table  table-hover table-condensed table-striped ">
                      <thead>
                          <tr>
                                <th></th>
                                <th>会议室</th>
                                <th>使用时间</th>
                                <th>申请原因</th>
                                <th>申请时间</th>
                                <th>实际使用人</th>
                                <th>处理时间</th>
                                <th>失败原因</th>
                                <th>操作</th>
                          </tr>
                       </thead>
                       <tbody>
                          
                               <tr v-for="appoint in appointList">
                                  <td>
                                      <input type="checkbox" :value="appoint.id" v-model="checkArr">
                                  </td>
                                  <td>{{appoint.meetingRoom.name}}</td>
                                  <td>{{appoint.appointTime}}<br/>{{appoint.appointStart}}:00~{{appoint.appointEnd}}:00</td>
                                  <td>{{appoint.reason}}</td>
                                  <td>{{appoint.submitTime}}</td>
                                  <td>{{appoint.realName}}<br/> {{appoint.realPhone}}</td>
                                  <td>{{appoint.dealTime}}</td>
                                  <td>{{appoint.message}}</td>
                                  <td>
                                      <button type="button" class="btn btn-danger" @click="delsingle(appoint.id)">删除</button>
                                  </td>
                               </tr>
                         
                       </tbody>
                 </table>
                 <div id="pagelist" class="pagelist" ></div>
                  <h1  id="tips" align="center" style="display:none"> </h1>
            </div>
             
	   </div>

               
                   
    </body>
    <script src="${basepath}/js/jquery.min.js"></script>
    <script src="${basepath}/js/vue.min.js"></script>
    <script src="${basepath}/js/remind.js"></script>
    <script src='../js/bootstrap.min.js'></script>
    <script src='../js/page.js'></script>
    <!-- 兼容ie -->
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script src="${basepath }/js/plugins/sweetalert/sweetalert2.min.js" ></script>   
       
          
<script type="text/javascript">
	
  $(function(){
	  //分页条属性选项
      var pageNo=1;
      var totalPage=0;
      $.ajax({
          url:"${basepath}/user/queryappoint.do",
          data:{
              userId:${islogin.id},
              state:2
          },
          type:"post",
          beforeSend: function () {
              $("body").append('<div id="pload" style="position:fixed;top:40%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
          },
          complete: function (XMLHttpRequest,status) {
              $("#pload").remove();
          },
          dataType:"json",
          success:function(data){
        	  console.log(data);
              vue.appointList = data.resultList;
              $("#pagelist").empty();
              pageNo = data.page.pageNo;
              totalPage = data.page.pages;
              if(totalPage != 0){
                  $("#pagelist").mypage({
                        pageNo:pageNo,
                        totalPage:data.page.pages
                    }); 
                  $("#delDiv").show();
              }
              else{
                  $("#tips").show();
                  $("#tips").html("没有预约信息");
                  $("#delDiv").hide();
              }
          }
      });
     
      //分页条点击事件
      $('body').on('click','#pagelist>a',function(){
    	
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
          vue.myPageNo=myPageNo;
     
       }); 
      function query(){
    	  $("#tips").hide();
    	  $.ajax({
              url:"${basepath}/user/queryappoint.do",
              data:{
                  userId:${islogin.id},
                  roomName:vue.searchText,
                  pageNo:vue.myPageNo,
                  state:2
              },
              type:"post",
              beforeSend: function () {
                  $("body").append('<div id="pload" style="position:fixed;top:40%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
              },
              complete: function (XMLHttpRequest,status) {
                  $("#pload").remove();
              },
              dataType:"json",
              success:function(data){
                  vue.appointList = data.resultList;
                  $("#pagelist").empty();
                  pageNo = data.page.pageNo;
                  totalPage = data.page.pages;
                  if(totalPage != 0){
                      $("#pagelist").mypage({
                            pageNo:pageNo,
                            totalPage:data.page.pages
                        }); 
                  }
                  else{
                      $("#tips").show();
                      $("#tips").html("没有满足条件的预约信息");
                      $("#delDiv").hide();
                  }
              }
          });
      }
      var vue = new Vue({
          el:"#wrap",
          data:{
        	  checkArr:[],          
              checkall:false,
        	  myPageNo:1,
        	  appointList:null,
        	  searchText:""
        	  
          },
          computed:{
        	  length:function(){
        		  var length = this.checkArr.length;
        		  if(length<=appointList.length)
        			  checkall=false;
        	  }
          },
          methods:{
        	  search:function() {
        		  this.searchText = $("#searchInput").val();
        		  this.myPageNo=1;
        	      totalPage=0;
        		  query();
        	  },
        	  
        	  checkAll:function(){ // 点击全选事件函数
                  if(this.checkall==true){ // 判定全选checkbox的勾选状态
                	  this.checkArr = []
                      for(var i=0;i<this.appointList.length;i++){
                          this.checkArr.push(this.appointList[i].id);
                      }
                	 
                  }
                  else { // 如果是去掉全选则清空checkbox选项绑定数组
                      this.checkArr = [];
                    
                  }
               },
               del:function(){
            	   if(vue.checkArr.length==0){
                       return;
                   }
                   swal({
                       title: "删除确认",
                       text: "删除后，您将无法恢复！",
                       type: "warning",
                       cancelButtonText:'取消',
                       confirmButtonText: '确定',
                       showCancelButton: true,
                       allowOutsideClick:false,
                     }).then(function(willDelete) {
                       if (willDelete.value) {
                           $.ajax({
                               url:"${basepath}/user/delappoints.do",
                               data:{checkArr:vue.checkArr},
                               type:"post",
                               success:function(data){
                                   if(data=="1"){
                                       swal({
                                           title:"删除成功！", 
                                           type: 'success',    
                                           allowOutsideClick:false,
                                       }).then(function(value){
                                           window.location.reload();
                                       });
                                    }
                               }
                           });
                        }
                    })
               },
               delsingle:function(id){
            	   swal({
                       title: "删除确认",
                       text: "删除后，您将无法恢复！",
                       type: "warning",
                       cancelButtonText:'取消',
                       confirmButtonText: '确定',
                       showCancelButton: true,
                       allowOutsideClick:false,
                     }).then(function(willDelete) {
                    	if (willDelete.value) {
                         $.ajax({
                             url:"${basepath}/user/delappoint.do",
                             data:{
                                 id:id
                             },
                             success:function(data){
                                 if(data=="1"){
                                    swal({
                                         title:"删除成功！", 
                                         type: 'success',    
                                         allowOutsideClick:false,
                                     }).then(function(value){
                                         window.location.reload();
                                     });
                                 }
                                   
                             }
                         });
                    	}
                     })
                  
                },
          },
          watch:{
              myPageNo:function(val){
            	  query();
              },
              checkArr:function(val){
                  if(this.checkArr.length!=this.appointList.length)
                	  this.checkall=false;
                  else if(this.checkArr.length == this.appointList.length)
                      this.checkall=true;
              }
              
          }
       });
  });
</script>

</html>