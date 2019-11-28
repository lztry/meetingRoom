<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ include file="/WEB-INF/common/Head.jsp" %>
<!doctype html>
<html lang="ch">
    <head>
        <meta charset="utf-8">
        <title>燕大会议室管理系统</title>
        <link href="${basepath }/css/bootstrap.min.css" rel="stylesheet">
        <!-- 分页css -->
        <link href="${basepath }/css/admin.css" rel="stylesheet">
        <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css">
       <style type="text/css">
           [v-cloak]{display:none}
           html,body{
             padding:0;
             margin:0;
             background: #eff3f6 bottom;
              font-size: 14px;
           }
           .modal-dialog{
             min-width: 500px;
           }
           .errTips{
             color: red;
           }
       
        
        </style>
    </head>

    <body>
        <div id="wrap" v-cloak>
             <div style="margin: 20px;" class="row">
                 <div class="col-md-3">
	                 <button class="btn btn-primary" data-toggle="modal" data-target="#addSource">添加会议室</button>
	                 <button class="btn btn-success" data-toggle="modal" data-target="#addArea">添加办公楼</button>
                 </div>
                 <div class="col-md-4 col-md-offset-3">
		              <form class="input-group ">
		                  <input type="text" name="location" value="<c:out value="${page.searchWay}" />" class="form-control" placeholder="输入会议室搜索">
		                  <span class="input-group-btn">
		                    <button class="btn btn-default" type="submit">搜索</button>
		                  </span>
		              </form>
                </div>
             </div>
             <div class="table-responsive">
	             <table class="table table-striped table-condensed">
	             <thead>
	                 <tr>
	                     <th style="text-align:center">会议室名称</th>
	                     <th style="text-align:center">级别</th>
	                     <th style="text-align:center">系别</th>
	                     <th style="text-align:center">容量</th>
	                     <th style="text-align:center">多媒体</th>
	                     <th style="text-align:center">设备状态</th>
	                     <th style="text-align:center">是否审核</th>
	                     <th style="text-align:center">提前时间</th>
	                     <th style="text-align:center">操作</th>
	                 </tr>
	             </thead>
	             <tbody>
	             
	                  <tr v-for="(meetingRoom,index) in meetingRoomList" style="text-align:center">
	                     <td>{{meetingRoom.name }}</td>
	                     <td v-if="meetingRoom.scale ==1">普通</td>
	                     <td v-if="meetingRoom.scale ==2">中级</td>
	                     <td v-if="meetingRoom.scale ==3">高级</td>
	                     <td>{{meetingRoom.departmentName }}</td>
	                     <td>{{meetingRoom.capacity }}人</td>
	                     <td v-if="meetingRoom.multimedia ==1">有</td>
	                     <td v-else>无</td>
	                     <td v-if="meetingRoom.deviceState ==1">无故障</td>
	                     <td v-else>有故障</td>  
	                       
	                     <td v-if="meetingRoom.isCheck ==0">无需审核</td>
	                     <td v-else>需要审核</td>  
	                     <td>{{meetingRoom.aheadTime }}天</td>
	                     <td>
	                          <button class="btn btn-success" @click="selectNum=index" data-toggle="modal" data-target="#changeSource">修改</button>
	                          <button class="btn btn-danger" @click="del(meetingRoom.id)" data-toggle="modal" data-target="#deleteSource">删除</button>
	                          <a :href="'${basepath }/single/calendar.do?roomid='+meetingRoom.id"><button class="btn btn-primary">去预约</button></a>
	                     </td>
	                 </tr>
	             
	             </tbody>
	         </table>
	         <h1  id="tips" align="center" style="display:none"> 没有符合条件的会议室</h1>
	         
	         </div>
             <div id="pagelist" class="pagelist"></div>
            <!-- 弹窗添加办公楼 -->
             <div class="modal fade" id="addArea" role="dialog" aria-labelledby="gridSystemModalLabel">
                 <div class="modal-dialog" role="document">
                     <div class="modal-content">
                         <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                             <h4 class="modal-title" id="gridSystemModalLabel">添加办公楼</h4>
                         </div>
                         <form  class="form-horizontal" action="${basepath }/area/addarea.do" method="post" onsubmit='return checkAreaForm()'>
                             <div class="modal-body">
                                 
                                    <div class="form-group ">
                                         <label  class="col-md-4 control-label">选择校区：</label>
                                         <div class="col-md-8" >
                                             <select  class="form-control" name="parentid" id="xiaoqu"  v-model="selectedxiaoqu">
                                                 <option  v-for="xiaoqu in area" :value="xiaoqu.codeid">{{xiaoqu.roomname}}</option>
                                            </select> 
                                         </div>
                                     </div>
                                   <div  id="repeatBuidingErrDiv" class="form-group">
                                       <label  class="col-md-4 control-label">办公楼名称：</label>
                                       <div class="col-md-8">
                                           <input  id="buildingName" name="roomname" class="form-control" id="sKnot" placeholder="比如信息馆" required="required">
                                           <span  id="repeatBuidingErrSpan" style="color: red;display: none;">此位置已存在，无须添加</span>
                                       </div>
                                   </div>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                 <button type="submit" class="btn  btn btn-primary" >保 存</button>
                              </div>
                                 
                         </form>
                             
                        
                         
                     </div>
                     <!-- /.modal-content -->
                 </div>
                 <!-- /.modal-dialog -->
             </div>
             <!-- /.modal -->
             <!--弹出窗口 添加资源-->
             <div class="modal fade" id="addSource" role="dialog" aria-labelledby="gridSystemModalLabel" data-backdrop="static">
                 <div class="modal-dialog" role="document">
                     <div class="modal-content">
                         <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                             <h4 class="modal-title" id="gridSystemModalLabel">添加会议室</h4>
                         </div>
                         <div class="modal-body">
                             <div class="container-fluid">
                                 <form class="form-horizontal" action="add.do" method="post" id="addRoomForm">
                                    <div id="repeatErrDiv" >
	                                    <div class="form-group">
	                                         <label  class="col-md-4 control-label">位置：</label>
	                                         <div class="col-md-4" >
	                                             <select class="form-control"    @change="changexiaoqu()" v-model="selectedxiaoqu" required="required">
	                                                     <option v-for="xiaoqu in area" :value="xiaoqu.codeid">{{xiaoqu.roomname}}</option>
	                                             </select> 
	                                         </div>
	                                         <div class="col-md-4">
	                                             <select class="form-control" @change="changetb()" v-model="selectedtb" required="required">
	                                                 <option v-for="s in tb" :value="s.codeid">{{s.roomname}}</option>
	                                             </select> 
	                                         </div>
	                                      
	                                     </div>
	                                     <div class="form-group ">
	                                         <label  class="col-md-4 control-label">名称：</label>
	                                         <div class="col-md-8 ">
	                                             <input type="text" name="roomNum" id="roomNum" class="form-control" placeholder="比如101"  v-model="roomNum" required="required">
	                                             <input type="hidden" name="selectedtb" :value="selectedtb"/>                                                                      
	                                             <input  type="hidden" id="rooName" name="name" v-model="roomName"/>
	                                              <span id="repeatErrSpan" style="color: red;display: none;">会议室已存在</span>
	                                         </div>
	                                         
	                                     </div>
	                                    
                                     </div>
                                     <div class="form-group">
                                         <label class="col-md-4 control-label">级别：</label>
                                         <div class="col-md-8 ">
                                             <select class="form-control" name="scale" required="required">
                                                <option value =1 >普通</option>
                                                <option value =2 >中级</option>
                                                <option value =3 >高级</option>
                                             </select>
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">系别：</label>
                                         <div class="col-md-8">
                                             <select name="departmentId" class="form-control" required="required"> 
                                                  <option v-for="department in departmentList" :value="department.id">{{department.name}}</option>
                                             </select>
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">容量：</label>
                                         <div class="col-md-8">
                                             <input type="number" name="capacity" class="form-control" id="sKnot" placeholder="容量" required="required"  min="1" >
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label class="col-md-4 control-label">多媒体：</label>
                                         <div class="col-md-8">
                                             <label >
                                                 <input  type="radio" name="multimedia" id="anniu" value=1 required="required">有</label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                             <label>
                                                 <input  type="radio" name="multimedia" id="meun" value=0 > 无</label>
                                         </div>
                                     </div>
                                   
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">审核：</label>
                                         <div class="col-md-8">
                                             <label>
                                                 <input type="radio" name="isCheck" value=1 required="required">需要</label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                             <label>
                                                 <input type="radio" name="isCheck"  value=0 > 不需要
                                             </label>
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label class="col-md-4 control-label">提前预约天数：</label>
                                         <div class="col-md-8">
                                             <input type="number" name="aheadTime" class="form-control input-sm duiqi" id="sKnot" placeholder="提前预约天数" required="required" min="1">
                                         </div>
                                     </div>
                                     <div class="modal-footer">
                                      <button type="button" class="btn btn-default" data-dismiss="modal">取 消</button>
                                        <button type="submit" class="btn btn-primary">保 存</button>
                                     </div>
                                 </form>
                                 
                             </div>
                            
                         </div>
                         
                     </div>
                     <!-- /.modal-content -->
                 </div>
                 <!-- /.modal-dialog -->
             </div>
             <!-- /.modal -->

             <!--修改会议室弹出窗口-->
             <div class="modal fade" id="changeSource" role="dialog" aria-labelledby="gridSystemModalLabel" v-if="meetingRoomList.length!=0">
                 <div class="modal-dialog" role="document">
                   
                     <div class="modal-content">
                     
                         <div class="modal-header">
                             <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                             <h4 class="modal-title" id="gridSystemModalLabel">修改会议室</h4>
                         </div>
                         <div class="modal-body">
                             <div class="container-fluid">
                                 <form class="form-horizontal" action="edit.do" method="post">
                                    <input type="hidden" name="id" :value="meetingRoomList[selectNum].id">
                                     <div class="form-group ">
                                         <label for="sName" class="col-md-4 control-label">名称：</label>
                                         <div class="col-md-8 ">
                                             <input type="text" class="form-control"  readonly :value="meetingRoomList[selectNum].name">
                                         </div>
                                     </div>
                                      <div class="form-group">
                                         <label  class="col-md-4 control-label">系别：</label>
                                          <div class="col-md-8 ">
                                             <input  type="text" :value="meetingRoomList[selectNum].departmentName" class="form-control" disabled="disabled">
                                          </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="sLink" class="col-md-4 control-label">级别：</label>
                                         <div class="col-md-8 ">
                                             <select name="scale" class="form-control" :value="meetingRoomList[selectNum].scale" required="required">
                                                <option value =1 >普通</option>
                                                <option value =2 >中级</option>
                                                <option value =3 >高级</option>
                                             </select>
                                         </div>
                                     </div>
                                    
                                     <div class="form-group">
                                         <label for="sKnot" class="col-md-4 control-label">容量：</label>
                                         <div class="col-md-8">
                                             <input type="number" min=1 name="capacity" class="form-control" id="sKnot" placeholder="容量" :value="meetingRoomList[selectNum].capacity" required="required">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">多媒体：</label>
                                         <div class="col-md-8">
                                             <label class="control-label" >
                                                 <input type="radio" name="multimedia" id="anniu" value=1 :checked="meetingRoomList[selectNum].multimedia==1">有
                                              </label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                             <label class="control-label" >
                                                 <input type="radio" name="multimedia" id="meun" value=0 :checked="meetingRoomList[selectNum].multimedia==0"> 无
                                             </label>
                                         </div>
                                     </div>
                                     <div class="form-group" v-if="meetingRoomList[selectNum].multimedia==1">
                                         <label  class="col-md-4 control-label">故障：</label>
                                         <div class="col-md-8">
                                             <label class="control-label">
                                                 <input type="radio" name="deviceState" id="anniu" value=0 :checked="meetingRoomList[selectNum].deviceState==0">有</label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                             <label class="control-label">
                                                 <input type="radio" name="deviceState" id="meun" value=1 :checked="meetingRoomList[selectNum].deviceState==1"> 无</label>
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">审核：</label>
                                         <div class="col-md-8">
                                             <label class="control-label"  >
                                                 <input type="radio" name="isCheck" id="anniu" value=1 :checked="meetingRoomList[selectNum].isCheck== 1">需要</label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                             <label class="control-label">
                                                 <input type="radio" name="isCheck" id="meun" value=0 :checked="meetingRoomList[selectNum].isCheck==0"> 不需要</label>
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label  class="col-md-4 control-label">提前预约天数：</label>
                                         <div class="col-md-8">
                                             <input type="number" min=1 name="aheadTime" class="form-control"  placeholder="提前预约天数" :value="meetingRoomList[selectNum].aheadTime" required="required">
                                         </div>
                                     </div>
                                     
                                     <div class="modal-footer">
                                        <button type="button" class="btn btn-defult" data-dismiss="modal">取 消</button>
                                        <button type="submit" class="btn btn-primary">保 存</button>
                                     </div>
                                 </form>
                             </div>
                         </div>
                     </div>
                     
                     <!-- /.modal-content -->
                 </div>
                 <!-- /.modal-dialog -->
             </div>
             <!-- /.modal -->
        </div>
    </body>
    <script src="${basepath }/js/jquery.min.js"></script>
    <script src="${basepath }/js/bootstrap.min.js"></script>
    <script src="${basepath }/js/vue.min.js"></script>
    <script src="${basepath}/js/jquery.form.js"></script>
    <script src="${basepath}/js/page.js"></script>
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script src="${basepath}/dist/sweetalert2.min.js"></script>
    <script src="${basepath }/js/jquery.validate.min.js"></script>
    <script src="${basepath }/js/messages_zh.min.js"></script>
	<script type="text/javascript">
	    $(function(){
	    	var validator =null;
	    	//模态框消失 去除所有样式
	    	$('#addSource').on('hidden.bs.modal', function (e) {
	    		$(".form-group").removeClass("has-error").removeClass("has-success");
	    		if(validator != null)
	    		   validator.resetForm();
	    		 $("#repeatErrDiv").removeClass("has-error");
                 $("#repeatErrSpan").hide();
	        })
	        $('#addArea').on('hidden.bs.modal', function (e) {
	        	$("#repeatBuidingErrDiv").removeClass("has-error");
                $("#repeatBuidingErrSpan").hide();
            })
	        $("#pagelist").mypage({
	           pageNo:${page.pageNo},
	           params:"${page.params}",
	           url:"${page.url}",
	           totalPage:${page.pages}
	       }); 
	       $.validator.setDefaults({
	            highlight: function(e) {
	                $(e).closest(".form-group").removeClass("has-success").addClass("has-error")
	            },
	            success: function(e) {
	                e.closest(".form-group").removeClass("has-error").addClass("has-success")
	            },
	            errorElement: "span",
	            errorPlacement: function(e, r) {
	                e.appendTo(r.is(":radio") || r.is(":checkbox") ? r.parent().parent() : r.parent())
	            },
	            errorClass: "errTips",
	       })
	       validator = $("#addRoomForm").validate({
	    	   submitHandler: function(form) { 
	              $.ajax({
	                   url:"${basepath}/room/existRoom.do",
	                   data:{name:$("#rooName").val()},
	                   type:"POST",
	                   beforeSend: function () {
	                       $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
	                   },
	                   complete: function (XMLHttpRequest,status) {
	                       $("#pload").remove();
	                   },
	                   success:function(data){
	                       if(data == 0){
	                    	   $("#repeatErrDiv").removeClass("has-error");
                               $("#repeatErrSpan").hide();
	                           $(form).ajaxSubmit({
	                                success:function(){
	                                	swal({
	                                        title: '添加成功',
	                                        type: 'success',
	                                        allowOutsideClick:false,
	                                        confirmButtonText: '确认',
	                                    }).then(function(result){
	                                            window.location.reload();     
	                                    });
	                                },
	                                error:function(){
	                                	swal({
                                            title: '添加失败',
                                            type: 'success',
                                            allowOutsideClick:false,
                                            confirmButtonText: '确认',
                                        }).then(function(result){
                                                window.location.reload();     
                                        });
	                                }
	                           }); 
	                       }
	                       else{
	                           $("#repeatErrDiv").addClass("has-error");
	                           $("#repeatErrSpan").show();
	                       }

	                   }
	                }) 
	            }  
	       });
	   });
	  
		var area;
		$.ajax({
		    url: "${basepath}/area/list.do",
		    type: "post",
		    dataType: "json",
		    async: false,
		    success: function(data) {
		        area = data;
		    }
		});
		//验证办公楼是否重复
		function checkAreaForm(){
			if($("#buildingName").val()==''){
				return false;
			}
			var selectableOffice = vue.tb;
			for(var i = 0;i<selectableOffice.length;i++ ){
				if(selectableOffice[i].roomname ==$("#buildingName").val()){
					$("#repeatBuidingErrDiv").addClass("has-error");
					$("#repeatBuidingErrSpan").show();
					return false;
				}
			}
			return true;
		}
		
		   $(function(){
			   $('body').on('hidden.bs.modal', '.modal', function () {
				   vue.$forceUpdate();
				});
		   })
		   var vue = new Vue({
			   el:"#wrap",
			   data:{
				   meetingRoomList:${meetingRoomList},
				   departmentList:${departmentList},
				   selectNum:0,
				   selectedxiaoqu: area[0].codeid,
		           selectedtb: area[0].children[0].codeid,
				   area: area,
		           tb: area[0].children,
		           xiaoquname: area[0].roomname,
				   tbname:area[0].children[0].roomname,
				   roomNum:"",
			   },
			   computed:{
				   roomName:function(){
					   return this.roomName=this.xiaoquname+this.tbname+this.roomNum;
				   }
			   
			   },
			   methods:{
				   del:function(id){
					   $.ajax({
						   url: "${basepath}/room/preDel.do",
				           type: "post",
						   data:{"id":id},
						   success:function(data){
							   if(data == 1){
								   swal({
					                      title: '是否要删除',
					                      text: '删除后将无法恢复，您确定还要继续删除吗？',
					                      type: 'warning',
					                      showCancelButton: true,
					                      focusConfirm: false,
					                      allowOutsideClick:false,
					                      confirmButtonText: '确定',
					                      cancelButtonText:'取消',
					                      focusConfirm: false,
					                  }).then(function(result){
					                      if (result.value) {
					                    	  window.location.href="del.do?id="+id;
					                      }
					                  });
							   }
			                   else{
			                	   swal({
			                            title: '不能删除',
			                            text: '当前会议室还有会议安排，请确定无安排后再删除会议室',
			                            type: 'warning',
			                            allowOutsideClick:false,
			                            confirmButtonText: '确认',
			                        });
			                   }
						   }
					   });
				   },
				   changexiaoqu: function() {
		               for(var i = 0; i < this.area.length; i++) {
		                   if(this.selectedxiaoqu == this.area[i].codeid) {
		                       this.tb = this.area[i].children;
		                       this.selectedtb =this.area[i].children[0].codeid;
		                       this.xiaoquname=this.area[i].roomname;
		                       this.tbname=this.tb[0].roomname;
		                       return;
		                   }
		               }
		           },
		           changetb: function() {
		                for(var i = 0; i < this.tb.length; i++) {
		                    if(this.selectedtb == this.tb[i].codeid) {
		                        this.tbname=this.tb[i].roomname;
		                        return;
		                    }
		                }
		           }
			   }
		   })
	
	</script>

</html>