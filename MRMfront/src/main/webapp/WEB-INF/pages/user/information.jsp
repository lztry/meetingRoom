<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=0">

        <title>个人资料</title>

        <link href="${basepath}/AmazeUI-2.4.2/assets/css/amazeui.css" rel="stylesheet" type="text/css" />
         <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css" />
       
        <script type="text/javascript" src="${basepath}/js/jquery.min.js"></script>
        <script src="${basepath}/js/vue.min.js"></script>
        <script src="${basepath}/js/jquery.cookie.js"></script>
         <script src="${basepath}/bootstrap/js/bootstrap.min.js"></script>
         <script src="${basepath}/js/verify.js"></script>
         <script src="${basepath}/dist/sweetalert2.min.js"></script>
        <!-- 兼容ie -->
        <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
  
        <style type="text/css">
        
           .bottomTip{
              color:#b94a48;
           
              display: none;
              font-size:16px;
              margin-left: 120px;
              margin-top: -25px;
            
            }
            /*导航条 左上角图标*/
        .am-topbar .am-text-ir {
             display: block;
                margin-left: 10px;
                margin-right: 10px;
                height: 50px;
                width: 100px;
                background: url(${basepath}/img/ysuLogo.png) no-repeat left center;
                -webkit-background-size: 100px 45px;
                background-size: 100px 45px;
        }
       
        .jumbotron{
               width:600px;
               margin: 30px auto;
               min-height: 450px;
			    box-shadow: 0 0 15px rgba(0, 0, 0, 0.15), 0 0 1px 1px rgba(0, 0, 0, 0.1);
			    border-radius: 10px;
			    padding: 10px 0;
			    font-size:17px;
        }
        .jumbotron>p{
          margin-left: 100px;
        }
        .myinput{
           display:inline-block;
           height: 35px;
            width:200px;
		    padding: 6px 1px;
		    font-size: 20px;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		    display:none;
        }
        </style>
    </head>

    <body>
      
        <script src="${basepath}/js/navigation.js"></script>
        <script>
           $(function(){
                $("#navigation").navigation({
                    mainpage:"${basepath}/index.do",
                    person:"${basepath}/user/person.do",
                    appoint:"${basepath}/user/appoint.do",
                    name:"${islogin.name}"
                });
            });
            
        </script>
          <!--顶部导航条 -->
		   <div id="navigation" style="height: 50px;">
		
		   </div>
		  
		   <div class="jumbotron">
		         <div style="float: right; margin-top: -12px;"><a class="btn btn-primary btn-lg" href="${basepath }/user/password.do">修改密码</a></div>
                  <h2 style="margin-left: 230px;">个人资料</h2>
                  <p style="margin-top: 25px;">&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                      <label class="control-label">账号：</label>
                      ${islogin.account }
                  </p>
                  <p>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                      <label class="control-label">系别：</label>
                      ${islogin.department }
                  </p>
                  <p > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                  <label class="control-label">姓名：</label>
	                 <span class="spanInfo"> ${islogin.name }</span>
	                  <input type="text" value="${islogin.name }" class="form-control myinput formGroup" id="realName" onblur="isNameEmpty(this.value)"/>  <br/>              
                      <span class="bottomTip" id="nameTip" >请输入姓名</span>
                  </p>
                  <p>
                      <label class="control-label">联系方式：&nbsp;</label>
                       <span class="spanInfo"> ${islogin.phone }</span>
                      <input type="text" id="realPhone"  value="${islogin.phone }" class="form-control myinput formGroup" onblur="isPhone(this.value)"/> <br/>
                      <span class="bottomTip" id="phoneTip"></span>  
                  </p>      
            
                 <p style="margin-top: 25px;" >
                     <a id="showChage" class="btn btn-primary btn-lg" href="javascript:void(0);" role="button" style="margin-left: 60px;width: 280px;" >修改信息</a>
                     <a id="change" class="btn btn-success btn-lg" href="javascript:void(0);" role="button" style="margin-left: 60px;width: 280px;display:none;">确认修改</a>
                 </p>
                  

            </div>
		   
		  
        
         
    <script type="text/javascript">
    $(function(){
    	$("#showChage").click(function(){
    		$(this).hide();
    		$("#change").show();
    		$(".spanInfo").hide();
    		$(".myinput").show();
    	 });
    	 $("#change").click(function(){
    		if(isPhone($("#realPhone").val())&&isNameEmpty($("#realName").val())){
    			var changeAjax = $.ajax({
    				 "url":"${basepath}/user/updateinfo.do",
                     "type":"post",
                     "dataType":"json",
                     "data":{
                    	 realname:$("#realName").val(),
                    	 phone:$("#realPhone").val()
                    	 },
                    	 timeout : 20000, //超时时间设置，单位毫秒
                         beforeSend: function () {
                             $("body").append('<div id="pload" style="position:fixed;top:40%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
                         },
                         complete: function (XMLHttpRequest,status) {
                             $("#pload").remove();
                             
                             if(status=='timeout'){//超时,status还有success,error等值的情况
                            	 changeAjax.abort();
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
                     "success":function(data){
                    	 $(this).show();
                         $("#change").hide();
                         $(".spanInfo").show();
                         $(".myinput").hide();
                         if(data>0){
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
                             
                         }
                         else {
                             alert("系统繁忙,请稍后更新");
                         }
                     },
                     "error":function(){
                         //alert("系统繁忙,请刷新界面");
                    	 swal({
                             title: '系统繁忙',
                             type: 'warning',
                             allowOutsideClick:false,
                             timer: 3500,
                             confirmButtonText: '关闭',
                             animation:false
                         });
                     }
    			});
    		}
    		
    	});
    });
   
    </script>
    </body>

</html>