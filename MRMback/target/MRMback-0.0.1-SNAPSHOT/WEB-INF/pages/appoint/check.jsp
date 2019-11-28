<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!doctype html>
<html lang="ch">

    <head>
        <meta charset="utf-8">
        <title>会议室后台管理</title>
       
        <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${basepath }/css/common.css" />
        <link rel="stylesheet" type="text/css" href="${basepath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css">
         
        <style>
            @-moz-document url-prefix() { fieldset { display: table-cell; } }
            html,body{
                 padding: 0px;
			     margin: 0px;
			     height: 100%;
			     font-size: 15px;
            }
            .table-responsive{
                padding :5px 5px;
            }
        </style>
        <style>
        [v-cloak]{display:none}
        </style>
    </head>

    <body>
      <!--  <button type="button" class="btn btn-success  btn-lg" onclick="window.top.location.reload()">刷新</button>  -->
        <div id="wrap" v-cloak>
            <div  class="table-responsive " >
                <table class="table table-hover table-striped table-condensed">
                    <thead >
                        <tr>
                            <th>编号</th>
                            <th>申请时间</th>                 
                            <th>申请人信息</th>
                            <th>实际使用人</th>
                            <th>预约会议室</th>
                            <th>起止时间</th>
                            <th>预约原因</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                         <tr v-for="(appoint,index) in appointList" :class="{ danger:isInArray(contraArr,appoint.id)}">
                             <td>{{index+1}}</td>
                             <td>{{appoint.submitTime}}</td>
                           
                             <td>{{appoint.user.name}}<br/>{{appoint.user.account}}</td>
                             <td>{{appoint.realName}}<br/>{{appoint.realPhone}}</td>
                             <td>{{appoint.meetingRoom.name}}</td>
                             <td> {{appoint.appointTime}} <br/>{{appoint.appointStart}}:00~{{appoint.appointEnd}}:00</td>
                             <td>{{appoint.reason}}</td>
                             <!-- data-toggle="modal" data-target="#passModal" -->
                             <td>
                                 <button type="button" class="btn btn-success" @click="pass(index,this)" >通过</button>
                                 <button type="button" class="btn btn-danger" @click="fail(index)">驳回</button>
                             </td>
                         </tr> 
                      
                    </tbody>
                </table>
                
                    <!--
                             
                              时间：2018-08-28
                              描述：通过模态框
                    -->
                    <div class="modal" tabindex="-1" role="dialog" id="passModal" v-if="selectIndex!=-1">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title">申请通过批准</h4>
                                </div>
                                <div class="modal-body">
                                    <p  align="center" style="font-weight: bolder;font-size: larger; ">
                                        
                                            {{appointList[selectIndex].user.account}}            
                                            {{appointList[selectIndex].user.department}}
                                            {{appointList[selectIndex].user.name}}<br/>
                                            {{appointList[selectIndex].appointTime}} {{appointList[selectIndex].appointStart}}:00~{{appointList[selectIndex].appointEnd}}:00<br/>
                                            {{appointList[selectIndex].meetingRoom.name}}<br/>
                                    
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                                    <a :href="'${basepath }/appoint/pass.do?id='+appointList[selectIndex].id+'&userId='+appointList[selectIndex].userId+'&name='+appointList[selectIndex].meetingRoom.name" >
                                        <button type="button" class="btn btn-primary" >确认批准</button>
                                    </a>
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
                    
                    <!--
                        作者：2667419310@qq.com
                        时间：2018-08-28
                        描述：驳回模态框
                    -->
                    <div class="modal" id="rejectModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" v-if="selectIndex!=-1">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="exampleModalLabel">驳回原因</h4>
                                </div>
                                <div class="modal-body">
                                    <p align="center" style="font-weight: bolder;font-size: larger; ">
                                            {{appointList[selectIndex].user.account}}            
                                            {{appointList[selectIndex].user.department}}
                                            {{appointList[selectIndex].user.name}}<br/>
                                            {{appointList[selectIndex].appointTime}} {{appointList[selectIndex].appointStart}}:00~{{appointList[selectIndex].appointEnd}}:00<br/>
                                            {{appointList[selectIndex].meetingRoom.name}}<br/>
                                    </p>
                                    <form>
                                        <div class="form-group">
                                            <label for="message-text" class="control-label">驳回上述申请的原因:</label>
                                            <textarea class="form-control" maxlength="50" id="message-text" rows="3" style="padding: 5px;" v-model="reasonText"></textarea>                                         
                                            <p class="textarea-numberbar">
                                                <em class="textarea-length">{{reasonText.length}}/50</em>
                                                <span id="tips" style="color: red;display: none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请输入驳回原因</span>
                                            </p>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                                    <button type="button" class="btn btn-primary" @click="reject(appointList[selectIndex].id,appointList[selectIndex].userId,appointList[selectIndex].meetingRoom.name)">确认驳回</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                        <!--
                                               
                                                   时间：2018-08-28
                                                   描述：冲突模态框
                    -->
                    <div class="modal" tabindex="-1" role="dialog" id="contraModal" v-if="selectIndex!=-1">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title">预约冲突（其它自动驳回）</h4>
                                </div>
                                <div class="modal-body">
                                   
                                       
                                          <table class="table table-hover">
                             <thead >
                                 <tr>
                                     <th>申请时间</th>                 
                                     <th>申请人信息</th>
                                     <th>预约会议室</th>
                                     <th>起止时间</th>
                                     <th>预约原因</th>
                                     <th>操作</th>
                                 </tr>
                             </thead>
                             <tbody v-if="appointList!=null">
                               
                                     <tr  :class="{ success:appoint.id==selectCon}" v-for="(appoint,index) in appointList" v-if="isInArray(contraArr,appoint.id)">
                                         <td>{{appoint.submitTime}}</td>
                                         <td>{{appoint.user.department}}<br/>{{appoint.user.name}}<br/>{{appoint.user.account}}</td>
                                         <td>{{appoint.meetingRoom.name}}</td>
                                         <td> {{appoint.appointTime}} <br/>{{appoint.appointStart}}:00~{{appoint.appointEnd}}:00</td>
                                         <td>{{appoint.reason}}</td>
                                         <td>
                                             <button type="button" class="btn btn-success" @click="passcontra(appoint.id,appoint.userId)">通过</button>
                                         </td>
                                     </tr> 
                               
                             </tbody>
                           </table>
                                  
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                                    
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    
                    
                    
           
            </div>
        </div>
           
    </body>
    <script src="${basepath}/js/vue.min.js"></script>
     <script src="${basepath}/js/jquery.min.js"></script>
    <script src="${basepath}/js/bootstrap.min.js"></script>
    <script src="${basepath}/js/jquery.cookie.js"></script>
  
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script src="${basepath}/dist/sweetalert2.min.js"></script>
    <script>
    function toDate(dateStr) {  
        var params = [0,0,0,0,0,0];
        var dataArr = dateStr.split(/\s|\-|\:/g);
       
        for(var i =0;i<dataArr.length;i++){
            params[i] =parseInt(dataArr[i]) ;
        }
       return new Date(params[0],params[1]-1,params[2],params[3],params[4],params[5]);
   }

    	
	    $.ajax({
            url:"${basepath}/appoint/list.do",
            type:"post",
            beforeSend: function () {
                $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
            },
            complete: function (XMLHttpRequest,status) {
                $("#pload").remove();
            },
            dataType:"json",
            success:function(data){
            	console.log(data);
                vue.appointList=data;
                parent.vue.appointnum = data.length
                //window.parent.setnum(data.length);
            }
        });
           
            var vue = new Vue({
                el:"#wrap",
                data:{
                	selectCon:0,
                    reasonText:"",   //驳回模态框的输入
                    reasonNum:0,     
                    selectIndex:-1,   
                    selectName:"计算机科学与技术 刘世宇", //当前处理事件
                    selectRoom:"东区信息馆401",
                    selectTime:"2018-8-28 9:00~10:00",
                    appointList:[],
                    contraArr:[],
                },
               
                methods:{
                	passcontra:function(id,userid){
                		this.selectCon = id;
                        swal({
                        	position: 'top-end',
                            title: '通过预约',
                            text: '确认通过这个预约吗？通过这个预约其他冲突预约回自动驳回',
                            type: 'warning',
                            showCancelButton: true,
                            focusConfirm: false,
                            allowOutsideClick:false,
                            confirmButtonText: '确认',
                            cancelButtonText:'取消',
                            focusConfirm: false,
                       
                        }).then(function(result){
                        	 vue.selectCon = 0;
                            if (result.value) {
                            	window.location.href="${basepath}/appoint/contrapass.do?id="+id+"&userid="+userid;
                            }
                            else if (result.dismiss === swal.DismissReason.cancel) {
                            	$('#contraModal').modal('hide');
                            }
                           });
                		/* if(confirm("")==true){
                			window.location.href="${basepath}/appoint/contrapass.do?id="+id+"&userid="+userid;
                		}
                		else{
                			$('#contraModal').modal('hide');
                		} */
                       
                		
                	}, 
                	isInArray:function(arr,value){
                	    if(arr.indexOf&&typeof(arr.indexOf)=='function'){
                	        var index = arr.indexOf(value);
                	        if(index >= 0){
                	            return true;
                	        }
                	    }
                	    return false;
                	},
                	fail:function(index){
                		
                		this.selectIndex=index;
                		$('#rejectModal').modal('show');
                		$('#tips').hide();
                		vue.reasonText=''; 
                		console.log(toDate(vue.appointList[index].appointTime+" "+vue.appointList[index].appointStart+":00").getHours());
                		if(new Date() >= toDate(vue.appointList[index].appointTime+" "+vue.appointList[index].appointStart+":00")){
                            swal({
                                title: '预约失效',
                                text: '此预约已过期',
                                type: 'warning',
                                allowOutsideClick:false,
                                confirmButtonText: '确定',
                              }).then(function(result){
                                  if(result.value){
                                      window.location.reload();
                                  }
                              });
                            return false;
                       }
                		
                	},
                	pass:function(index,ob){
                        if(new Date() >= toDate(vue.appointList[index].appointTime+" "+vue.appointList[index].appointStart+":00")){
                			 swal({
                                 title: '预约失效',
                                 text: '此预约已过期',
                                 type: 'warning',
                                 allowOutsideClick:false,
                                 confirmButtonText: '确定',
                               }).then(function(result){
                                   if(result.value){
                                       window.location.reload();
                                   }
                               });
                			 return false;
                		}
                		this.contraArr=[];
                		this.selectIndex=index;
                		var appoint=JSON.stringify(this.appointList[index]);
                		//console.log($(ob));
                		//console.log($(ob).parent());
                		$.ajax({
                			"url":"${basepath }/appoint/queryContra.do",
                            "type":"post",
                             contentType:'application/json',
                             dataType:"json",
                             data:appoint,
                             beforeSend: function () {
                                 $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                             },
                             complete: function (XMLHttpRequest,status) {
                                 $("#pload").remove();
                             },
                             success:function(data){
                            	console.log(data);
                            	
                            	if(data==null||data.length==1||data.length==0){
                            		$('#passModal').modal('show');
                            	}
                            	else{
                            		for(var i=0;i<data.length;i++){
                            			vue.contraArr.push(data[i].id);
                            		}
                            		$('#contraModal').modal('show');
                            	}
                            
                             }
                		});
                	},
                	reject:function(id,userId,name){
                		if(this.reasonText==""){
                			$("#tips").show();
                			return false;
                		}
                		$('#rejectModal').modal('hide');
                	 	$.ajax({
                			"url":"${basepath }/appoint/reject.do",
                			"type":"post",
                			 beforeSend: function () {
                	                $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                	            },
                	            complete: function (XMLHttpRequest,status) {
                	                $("#pload").remove();
                	            },
                			"data":{
                				id:id,
                				userId:userId,
                			    reason:vue.reasonText,
                			    name:name
                			},
                			"success":function(){
                				vue.selectIndex=-1;
                				//alert("驳回成功");
                				swal({
                                     title: '驳回成功',
                                     type: 'success',
                                     allowOutsideClick:false,
                                     confirmButtonText: '确定',
                                   }).then(function(result){
                                	   if(result.value){
                                		   window.location.reload();
                                	   }
                                   });
                			
                			}
                			
                		}); 
                	}
                }
            }); 
            
           
            
        </script>

</html>