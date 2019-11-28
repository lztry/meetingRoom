<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>

    <head lang="en">
       <style type="text/css">
            *,
			*:before,
			*:after {
			  -webkit-box-sizing: border-box;
			          box-sizing: border-box;
			}
			.myIntput{
			    font-size: 14px;
    line-height: 18px;
    height: 42px;
    padding: 11px 8px 11px 50px;
    width: 100%;
    border: 1px solid #fff;
			}
       </style>
        <meta charset="UTF-8">
        <title>信息科学与工程学院会议室预约系统登录</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <meta name="format-detection" content="telephone=no">
        <meta name="renderer" content="webkit">
        <meta http-equiv="Cache-Control" content="no-siteapp" />
        <link rel="shortcut icon" type="image/x-icon" href="${basepath}/images/Logo.ico" />
        <link rel="stylesheet" href="${basepath }/AmazeUI-2.4.2/assets/css/amazeui.css" />
        <link href="${basepath }/css/dlstyle.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css">
    </head>

    <body>

        <div class="login-boxtitle">
            <font size=5>信息科学与工程学院会议室预约系统</font>
        </div>

        <div  class="login-banner">
      
           
            <div class="login-main">
                <div class="login-banner-bg"><span></span><img src="${basepath }/img/bigaa.jpg" style="margin-left: -134px;" height=470px /></div>
                <div class="login-box" >

                    

                    <div class="clear"></div>
                    <div style=" margin:10px auto;   width: 250px;">
                         <img alt="logo" src="${basepath }/img/ysuLogo.png" style="margin-top: 15%;"/>
                        
                    </div>
                    
                    <div class="login-form">
                        
                        <form>
                            <div class="user-name">
                                <label for="user"><i class="am-icon-user"></i></label>
                                <input type="text" class="am-form-field"  id="username" placeholder="请输入工号" >
                            </div>
                            
                            <div class="user-pass">
                                <label for="password"><i class="am-icon-lock"></i></label>
                                <input type="password" class="am-form-field"  id="password" placeholder="请输入密码">
                            </div>
                         
                        </form>
                          
                    </div>
                       <div id="tips" style="margin-top: -15px;color: red;font-size: 14px;display: none;"></div>
                   
                    <div class="am-cf">
                        <input type="submit" id="login" value="登 录" class="am-btn am-btn-primary am-btn-sm">
                    </div>
                  
                </div>
            </div>
        </div>

        
    </body>
    <script src="${basepath}/js/jquery.min.js"></script>
    <script src="${basepath}/js/jquery.cookie.js"></script>
    <script src="${basepath}/js/md5.js"></script>
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script src="${basepath}/dist/sweetalert2.min.js"></script>
    <script type="text/javascript">
    $(function(){
    	$(".am-form-field").focus(function(){
    		$(this).parent().removeClass("am-form-error");
    		$("#tips").hide();
    	});
    	if($.cookie('username')!=null)
    	   $("#username").val($.cookie('adminname'));
    	$("#login").click(function(){
    	    if($("#username").val().length==0){
    	    	$("#username").parent().addClass("am-form-error");
    	    	$("#tips").html("用户名或密码不能为空");
    	    	$("#tips").show();
    	    }
    	    else if($("#password").val().length==0){
    	    	$("#password").parent().addClass("am-form-error");
    	    	$("#tips").show();
    	    	$("#tips").html("用户名或密码不能为空");
    	    }
    	    else{
    	    	$("#username").parent().removeClass("am-form-error");
    	    	$("#password").parent().removeClass("am-form-error");
                $("#tips").hide();
                var currentAjax= $.ajax({
                     url:"${basepath}/user/logincheck.do",
                     type:"post",
                     dataType:"json",
                     timeout : 20000, //超时时间设置，单位毫秒
                     beforeSend: function () {
                         $("body").append('  <div class="am-dimmer am-active"  style="display: block;"></div><div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                     },
                     data:{
                         username:$("#username").val(),
                         password:hex_md5($("#password").val())
                     },
                     complete: function (XMLHttpRequest,status) {
                         $("#pload").remove();
                         $(".am-dimmer").remove();
				         if(status=='timeout'){//超时,status还有success,error等值的情况
				                  currentAjax.abort();
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
                         if(data.result==1){
                             $.cookie('adminname',$("#username").val(), { expires: 7, path: '/' });
                             window.location.href="${basepath}/index.do";
                         }
                         else if(data.result==0){
                        	 $("#username").parent().addClass("am-form-error");
                        	 $("#password").parent().addClass("am-form-error");
                        	 $("#tips").html("用户名或密码错误");
                             $("#tips").show();
                         }
                     }
                 
                 });
    	    }
          
    	});
    })
  /*  var uname=$.cookie('MRMusername');
	var upwd="";
	
	 if($.cookie('dxsL')!=null){
		for(var i=0;i<$.cookie('dxsL');i++)
		    upwd+='.';
	}  */
	
	<%--
	var vue=new Vue({
	    el:"#app",
	    data:{
	        username:uname,
	        password:upwd,
	        remember:false
	    },
	    created:function(){
	        if($.cookie('dxs')!=null && $.cookie('dxs').length>=20){
	        	this.remember=true;
	        }
	    },
	    methods:{
	
	        submit:function(){
	        	 var subPwd=""; 
	             if($("#username").val().length==0||$("#password").val().length==0)
	                 {alert("用户名或密码不能为空");}          
	             else{
	                 if($.cookie('dxs')==null||$.cookie('dxsL')==null||$.cookie('dxsL')!=this.password.length){
	                	 subPwd=hex_md5(this.password);
	                	
	                 }
	                 else
	                	 subPwd=$.cookie('dxs');
	                 console.log(subPwd+vue.username);
	            $.ajax({
	                url:"${basepath}/user/logincheck.do",
	                type:"post",
	                aysnc:false,
	                dataType:"json",
	                data:{
	                    username:this.username,
	                    password:subPwd
	                },
	                success:function(data){
	                    
	                    if(data.result==1){
	                        $.cookie('MRMusername',vue.username, { expires: 7, path: '/' });
	                        /* 
	                        $.cookie('MRMusername','',{ expires: -1, path: '/' });
	                        
	                        alert($.cookie('MRMusername')); */
	                        if(vue.remember==true){
	                        	$.cookie('dxs',subPwd, { expires: 7, path: '/' });
	                            $.cookie('dxsL',vue.password.length, { expires: 7, path: '/' });
	                        }
	                        else{
	                        	$.cookie('dxs','',{ expires: -1, path: '/' });
	                        	$.cookie('dxsL','', { expires: -1, path: '/' });
	                        }

	                        window.location.href="${basepath}/index.do";
	                    }
	                    else if(data.result==0){
	                        alert("用户名或密码错误");
	                    }
	                    else{
	                        alert("系统繁忙");
	                    }
	                    
	                },
	                error:function(){
	                    alert("error");
	                }
	            
	            });}
	        }
	    }
	    
	}); 
   --%>
</script>
</body>

</html>