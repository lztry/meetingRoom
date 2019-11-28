<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=0">

        <title>修改密码</title>
        <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet" />
        <link href="${basepath }/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
        <link href="${basepath }/css/animate.min.css" rel="stylesheet">
        <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet"> 
        <link href="${basepath }/css/plugins/sweetalert/sweetalert2.min.css" rel="stylesheet">
    </head>
    <body class="gray-bg">
	    <div class="row wrapper border-bottom white-bg page-heading">
	        <div class="col-sm-4">
	            <h2>个人中心</h2>
	        </div>
	    </div>
	    <div class="wrapper wrapper-content">
	        <div class="row">
	            <div class="col-md-offset-1 col-md-9">
	                <div class="ibox float-e-margins">
	                    <div class="ibox-title">
	                                                            修改密码
	                    </div>
	                    <div class="ibox-content">
	                         <form method="post" class="form-horizontal" id="passwordForm" action="updatepwd.do">
	                             <div class="form-group">
	                                <label class="col-sm-2 control-label">原密码</label>
	
	                                <div class="col-sm-9">
	                                    <input type="password" class="form-control" id="oldpwd" name="oldpwd" >
	                                </div>
	                            </div>
	                            <div class="hr-line-dashed"></div>
	                             <div class="form-group">
	                                <label class="col-sm-2 control-label">新密码</label>
	                                <div class="col-sm-9">
	                                    <input type="password" class="form-control" id="newpwd" name = "newpwd" >
	                                </div>
	                            </div>
	                             <div class="form-group">
	                                <label class="col-sm-2 control-label">确认密码</label>
	                                <div class="col-sm-9">
	                                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" >
	                                </div>
	                            </div>
	                            <div class="hr-line-dashed"></div>
	                            <div class="form-group">
	                                <div class="col-sm-4 col-sm-offset-2">
	                                    <button class="btn btn-primary" type="submit" id="alterPwdBtn">确认修改</button>
	                                 </div>
	                            </div>
	                        </form>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	 <script type="text/javascript" src="${basepath}/js/jquery.min.js"></script>
     <script src="${basepath}/js/vue.min.js"></script>
     <script src="${basepath}/js/md5.js"></script>
     <script src="${basepath}/js/bootstrap.min.js"></script>
     <!-- 兼容ie -->
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>   
    <script src="${basepath}/js/jquery.cookie.js"></script>
    <script src="${basepath}/js/jquery.form.js"></script>
    <script src="${basepath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basepath }/js/plugins/sweetalert/sweetalert2.min.js" ></script>   
    
    <script type="text/javascript">
    $.validator.setDefaults({
        highlight: function(e) {
            $(e).closest(".form-group").removeClass("has-success").addClass("has-error")
        },
        success: function(e) {
            e.closest(".form-group").removeClass("has-error").addClass("has-success")
        },
        errorElement: "span",
        errorPlacement: function(e, r) {
            e.appendTo(r.is(":radio") || r.is(":checkbox") ? r.parent().parent().parent() : r.parent())
        },
        errorClass: "help-block m-b-none",
        validClass: "help-block m-b-none"
    })
    jQuery.validator.addMethod("isOldPwd", function(value, element) {  
		 return this.optional(element) || ( '${islogin.password}' == hex_md5(value)) ;  
    }, "原密码不正确");  
    var e = "<i class='fa fa-times-circle'></i> ";
    
    $().ready(function() {
        $("#passwordForm").validate({
            rules: {
                oldpwd: {
                	required: !0,
                	isOldPwd : true 
                },
                newpwd:{
                	required: !0,
                	minlength: 6,
                },
                confirm_password:{
                	required: !0,
                	equalTo: "#newpwd"
                }	
            },
            messages: {
            	 oldpwd: {
                     required:  e + "请输入原密码",
                     isOldPwd :  e + "原密码不正确" 
                 },
                 newpwd:{
                     required: e + "请输入新密码",
                     minlength: e + "新密码必须5个字符以上",
                 },
                 confirm_password:{
                     required: e + "请再次输入密码",
                     equalTo:  e + "两次输入的密码不一致"
                 }
            },
            submitHandler: function(form) { 
            	$.ajax({
                    "url":"${basepath}/user/updatepwd.do",
                    "type":"post",
                    "dataType":"json",
                    "data":{                     
                        oldpwd:hex_md5($("#oldpwd").val()),
                        newpwd:hex_md5($("#newpwd").val())
                        },
                    "success":function(data){
                           $.cookie('dxs','',{ expires: -1, path: '/' });
                           $.cookie('dxsL','', { expires: -1, path: '/' });
                        swal({
                            title: '修改成功',
                            type: 'success',
                            allowOutsideClick:false,
                            confirmButtonText: '确定',
                        }).then(function(result){
                            if(result.value){
                                window.location.reload();
                            }
                        });
                    },
                    "error":function(){
                    	swal({
                            title: '系统繁忙，修改失败',
                            type: 'warning',
                            allowOutsideClick:false,
                            confirmButtonText: '确定',
                        })
                    }
                });
            }  
        })
    });
    $(function() {
    	 //取消错误样式
    	$(".form-control").focus(function(){
            $(this).parent().removeClass("has-error");
            $(this).siblings(".bottomTip").hide();
        }); 
       
    });
 
    </script>
    </body>

</html>