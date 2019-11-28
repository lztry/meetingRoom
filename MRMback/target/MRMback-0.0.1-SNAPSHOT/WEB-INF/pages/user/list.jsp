<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!doctype html>
<html lang="ch">
<head>
<meta charset="utf-8">
<title>燕大会议室管理系统</title>

<link rel="stylesheet" type="text/css" href="${basepath}/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="${basepath}/css/admin.css">
<style>
[v-cloak]{display:none}
</style>
</head>
<body>
 <div id="app" v-cloak>
 
           <div style="margin: 20px;" class="row">
               <div class="col-md-3">
                   <button class="btn btn-primary" data-toggle="modal" data-target="#addUser">添加用户 </button>
                   <button class="btn btn-success" data-toggle="modal" data-target="#upload">批量添加用户 </button>
               </div>
	          <div class="col-md-4 col-md-offset-3">
	          <form class="input-group ">
			      <input type="text" name="name" value="${auser.name}" class="form-control" placeholder="输入姓名搜索">
			      <span class="input-group-btn">
			        <button class="btn btn-default" type="submit">搜索</button>
			      </span>
			     </form>
			  </div>
           </div>
           <div class="table-responsive">
	           <table class="table table-striped table-bordered table-condensed ">
	               <thead>
	                   <tr>
	                       <th style="text-align:center">工号</th>
	                       <th style="text-align:center">姓名</th>
	                       <th style="text-align:center">电话</th>
	                       <th style="text-align:center">系别</th>
	                       <th style="text-align:center">级别</th>
	                       <th style="text-align:center">操作</th>
	                   </tr>
	               </thead>
	               <tbody align="center">
	                   <c:forEach items="${userlist }" var="userlist" varStatus="status">
	                   <tr>
	                      
	                       <td>${userlist.account }</td>
	                       <td>${userlist.name }</td>
	                       <td>${userlist.phone }</td>
	                       <td>${userlist.department }</td>
	                       <td>${userlist.level }</td>
	                       <td> <button class="btn btn-success" data-toggle="modal" data-target="#reviseUser" @click="update(${status.index })">修改</button>
	                            <button class="btn btn-danger" data-toggle="modal"  data-target="#deleteUser" @click="del(${userlist.id })">删除</button>
	                            <button class="btn btn-danger" style="background-color:blue; border-width: 0;" data-target="#mimaUser" data-toggle="modal" @click="mima(${userlist.id })">重置密码</button>
	                       </td>
	                   </tr>
	                   </c:forEach>
	               </tbody>
	           </table>
	                            
           </div>
                    <!--弹出添加用户窗口-->
                    <div class="modal fade" id="addUser" role="dialog" aria-labelledby="gridSystemModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="gridSystemModalLabel">添加用户</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="container-fluid">
                                        <form class="form-horizontal" method="post" onsubmit='return checkForm()'>
                                            <div class="form-group ">
                                                <label for="sName" class="col-xs-3 control-label">工号：</label>
                                                <div class="col-xs-8 ">
                                                    <input type="text" name="account" class="form-control input-sm duiqi" id="bnum" placeholder="" style="display:inline">
                                                    <span id="s1" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sLink" class="col-xs-3 control-label">姓名：</label>
                                                <div class="col-xs-8 ">
                                                    <input type="text" name="name" class="form-control input-sm duiqi" id="bname" placeholder="" style="display:inline">
                                                    <span id="s2" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sOrd" class="col-xs-3 control-label">电话：</label>
                                                <div class="col-xs-8">
                                                    <input type="text" name="phone" class="form-control input-sm duiqi" id="bphone" placeholder="建议使用常用手机" maxlength="11" style="display:inline">
                                                    <span id="s3" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                                                    <div class="tips"></div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sKnot" class="col-xs-3 control-label">系别：</label>
                                                <div class="col-xs-8">
                                                    <select class="form-control select-duiqi" name="departmentId">
                                                        <c:forEach items="${departments }" var="department">
                                                        <option value="${department.id }">${department.name }</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sKnot" class="col-xs-3 control-label">级别：</label>
                                                <div class="col-xs-8">
                                                    <select class=" form-control select-duiqi" name="scale">
                                                        <option value="1">初级</option>
                                                        <option value="2">中级</option>
                                                        <option value="3">高级</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                            <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                            <button type="submit" class="btn  btn-success">保 存</button>
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
    
                    <!--弹出修改用户窗口-->
                    <div class="modal fade" id="reviseUser" role="dialog" aria-labelledby="gridSystemModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="gridSystemModalLabel">修改用户</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="container-fluid">
                                        <form class="form-horizontal" method="post" onsubmit='return checkForm2()' action="${basepath }/user/update.do">
                                            <input type="hidden" name="id" :value="user.id">
                                            <div class="form-group ">
                                                <label for="sName" class="col-xs-3 control-label">工号：</label>
                                                <div class="col-xs-8 ">
                                                    <input type="text" name="account" class="form-control input-sm duiqi" id="snum" :value="user.account" disabled style="color:black">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sLink" class="col-xs-3 control-label">姓名：</label>
                                                <div class="col-xs-8 ">
                                                    <input type="text" name="name" class="form-control input-sm duiqi" id="sname" :value="user.name" style="display:inline">
                                                    <span id="s4" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sOrd" class="col-xs-3 control-label">电话：</label>
                                                <div class="col-xs-8">
                                                    <input type="text" name="phone" class="form-control input-sm duiqi" id="sphone" :value="user.phone" style="display:inline">
                                                    <span id="s5" class="glyphicon glyphicon-remove" style="color:red;display: none" ></span>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="sKnot" class="col-xs-3 control-label">系别：</label>
                                                <div class="col-xs-8">
                                                    <select class=" form-control select-duiqi" name="departmentId">
                                                        <c:forEach items="${departments }" var="department">
                                                        <template v-if="${department.id }==user.departmentId">
                                                        <option value="${department.id }" selected>${department.name }</option>
                                                        </template> 
                                                        <template v-else>
                                                        <option value="${department.id }">${department.name }</option>
                                                        </template>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                           <div class="form-group">
                                                <label for="sKnot" class="col-xs-3 control-label">级别：</label>
                                                <div class="col-xs-8">
                                                    <select class=" form-control select-duiqi" name="scale">
                                                    <template v-if="user.scale==1">
                                                        <option value="1" selected>初级</option>
                                                    </template>
                                                    <template v-else>
                                                        <option value="1">初级</option>
                                                    </template>
                                                    <template v-if="user.scale==2">
                                                        <option value="2" selected>中级</option>
                                                    </template>
                                                    <template v-else>
                                                        <option value="2">中级</option>
                                                    </template>
                                                    <template v-if="user.scale==3">
                                                        <option value="3" selected>高级</option>
                                                    </template>
                                                    <template v-else>
                                                        <option value="3">高级</option>
                                                    </template>
                                                    </select>
                                                </div>
                                            </div>
                                           <div class="modal-footer">
                                            <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                            <button type="submit" class="btn  btn-success">保 存</button>
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
    
                    <!--弹出删除用户警告窗口-->
                    <div class="modal fade" id="deleteUser" role="dialog" aria-labelledby="gridSystemModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="gridSystemModalLabel">提示</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="container-fluid">
                                        确定要删除该用户？删除后不可恢复！
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                    <a :href="'${basepath }/user/delete.do?id='+selected"><button type="button" class="btn   btn-danger"> 确认</button></a>
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
                    <!--弹出重置密码用户警告窗口-->
                    <div class="modal fade" id="mimaUser" role="dialog" aria-labelledby="gridSystemModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="gridSystemModalLabel">提示</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="container-fluid">
                                        确定要为该用户重置密码？
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                    <a :href="'${basepath }/user/mima.do?id='+selected"><button type="button" class="btn   btn-danger"> 确认</button></a>
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- 弹出文件上传 -->
                    <div class="modal fade" id="upload" role="dialog" aria-labelledby="gridSystemModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="gridSystemModalLabel">批量添加用户</h4>
                                </div>
                                <form method="post" action="${basepath }/user/upload.do" enctype="multipart/form-data">
                                <div class="modal-body">
                                        请选择导入文件！       
                                      
                                    <input type="file" name="excel" accept=".xls">
                                    
                                  
                               
                                </div>
                                <div class="modal-footer">
                                   <a href="${basepath }/template/demo.xls">点我下载导入模板</a>
                                  <button type="button" class="btn  btn-default" data-dismiss="modal">取 消</button>
                                  <button type="submit" class="btn   btn-success"> 确认</button>
                                </div>
                            </form> 
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
    
    
     
              
               <div id="pagelist" class="pagelist"></div>
        
  </div>
	<script src="${basepath}/js/jquery.min.js"></script>
	<script src="${basepath}/js/bootstrap.min.js"></script>
	<script src="${basepath}/js/vue.min.js"></script>
  <script type="text/javascript">
	function checkForm(){
	    var bnum=$('#bnum').val();
	    var bname=$('#bname').val();
	    var bphone=$('#bphone').val();
	    var phonereg = new RegExp("^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$");
	    if(bnum=='')
	    {   
	        $('#s1').css("display",'inline');
	        return false;
	    }
	    if(bname=='')
	        {
	            $('#s2').css("display",'inline');
	            return false;
	        }
	    if(bphone==''||!phonereg.test(bphone))
	        {
	            $('#s3').css("display",'inline');
	            return false;
	        }
	   return true;
	}
	function checkForm2(){
	    var sname=$('#sname').val();
	    var sphone=$('#sphone').val(); 
	    var phonereg = new RegExp("^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$");
	    if(sname=='')
	        {
	            $('#s4').css("display",'inline');
	            return false;
	        }
	    if(sphone==''||!phonereg.test(sphone))
	        {
	            $('#s5').css("display",'inline');
	            return false;
	        }
	   return true;
	}
	</script>
		<script type="text/javascript">
	$(document).ready(function(){
		$(document).ready(function(){
		    $("#cuser").trigger("click");
		    if(${fanhui}==1){
		            alert("成功");
		    }
		    else if(${fanhui}==2){
		    	alert("用户已存在");
		    }
		    if(${isupload}==1){
		    	alert("导入成功");
		    }
		    else if(${isupload}==2){
		    	/* console.log(${errorUsers});
		    	var account="";
		    	var users = ${errorUsers}
		    	for(var i=0;i<users.length ;i++){
		    		
		    		if(users[i].account!=""){
		    			account+=users[i].account+" ";
		    		}
		    		else{
		    			account+=users[i].name+" ";
		    		}
		    	} */
		    	alert("文件异常，部分导入成功，请检查文件格式");
		    }
		  
		    $('#bnum').click(function(){
		        $('#s1').css("display",'none');
		    });
		    $('#bname').click(function(){
		        $('#s2').css("display",'none');
		    });
		    $('#bphone').click(function(){
		        $('#s3').css("display",'none');
		    });
		    $('#sname').click(function(){
		        $('#s4').css("display",'none');
		    });
		    $('#sphone').click(function(){
		        $('#s5').css("display",'none');
		    });
		    
		});
		
	    $("#cuser").trigger("click"); 
	});
	var vue=new Vue({
	    el:"#app",
	    data:{
	        selected:null,
	        userlist:${userli },
	        user:[{}]
	    },
	    
	    methods:{
	        del:function(id){
	            this.selected=id;
	            
	        },
	        update:function(index){
	            this.user = this.userlist[index];
	          //  console.log(index);
	        },
	        
	        mima:function(id){
	            this.selected=id;
	        }
	    } 
	}); 
	
	
	</script>
		<script src="${basepath}/js/page.js"></script>
		<script type="text/javascript">
	            $(function(){
	                 $("#pagelist").mypage({
	                    pageNo:${auser.pageNo},
	                    params:"${auser.params}",
	                    url:"${auser.url}",
	                    totalPage:${user.pages}
	                }); 
	            });
	</script>
</body>

</html>