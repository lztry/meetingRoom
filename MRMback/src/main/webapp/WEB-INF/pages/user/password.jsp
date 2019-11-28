<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8">

        <title>修改密码</title>
        <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="${basepath }/dist/sweetalert2.min.css" />
        <link rel="stylesheet" type="text/css" href="${basepath }/css/common.css" />
        
        <script type="text/javascript" src="${basepath}/js/jquery.min.js"></script>
        <script src="${basepath}/js/vue.min.js"></script>
        <script src="${basepath}/js/md5.js"></script>
         <script src="${basepath}/js/bootstrap.min.js"></script>
         <script src="${basepath}/dist/sweetalert2.min.js"></script>
        <!-- 兼容ie -->
        <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
  
         <style type="text/css">
             .bottomTip{
              color:#b94a48;
              display: none;
              font-size:16px;
              margin-left: 130px;
              margin-top: -30px;
            
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
        }
        </style>
    </head>

    <body>
         
        <div  id="wrap">
              <div class="jumbotron">
                 <h2 style="margin-left: 240px;">修改密码</h2>
                  <p style="margin-top: 60px;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label class="control-label">原密码：</label><input id="oldInput" type="password"  class="form-control myinput" onblur="verifyOld(this.value)"/> <br/><span class="bottomTip" id="oldTip"></span>  </p>                  
                  <p >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label class="control-label">现密码：</label><input id="newInput" type="password"  class="form-control myinput"  onblur="verifyNew(this.value)"/><br/><span class="bottomTip" id="newTip"></span>  </p>      
                  <p > &nbsp;&nbsp;&nbsp;&nbsp;<label class="control-label">确认密码：</label><input id="conInput" type="password"  class="form-control myinput" onblur="verifyCon(this.value)"/> <br/><span class="bottomTip" id="conTip"></span></p>                  
            
                 <p style="margin-top: 40px;" >
                     <a id="conChange" class="btn btn-primary btn-lg" href="javascript:void(0);" role="button" style="margin-left: 60px;width: 280px;">确认修改</a>
                 </p>
                  

            </div>
        </div>
         <script src="${basepath}/js/jquery.cookie.js"></script>
    <script type="text/javascript">
    function verifyOld(value){
    	if(value!=""){
    		if("${islogin.password}" != hex_md5(value)){
    			$("#oldTip").show();
                $("#oldTip").html("原密码不正确");
                $("#oldTip").parent().addClass("has-error");
                return false;
    		}
    	}
    	else{
    		$("#oldTip").show();
    		$("#oldTip").html("请输入原密码");
    		$("#oldTip").parent().addClass("has-error");
    		 return false;
    	}
    	return true;
    }
    function verifyNew(value){
    	if(value ==""){
    		  $("#newTip").show();
              $("#newTip").html("请输入现密码");
              $("#newTip").parent().addClass("has-error");
              return false;
    	}
    	return true;
    }
    function verifyCon(value){
    	if($("#newInput").val()!=""){
    		
        if(value ==""){
              $("#conTip").show();
              $("#conTip").html("请确认密码");
              $("#conTip").parent().addClass("has-error");
              return false;
        }
        else if(value != $("#newInput").val()){
        		 $("#conTip").show();
                 $("#conTip").html("两次密码不一致");
                 $("#conTip").parent().addClass("has-error");
                 return false;
        	}
    	}
    	else{
    		  $("#newTip").show();
              $("#newTip").html("请输入现密码");
              $("#newTip").parent().addClass("has-error");
              return false;
    	}
    	return true;
    }
    $(function() {
    	 //取消错误样式
    	$(".form-control").focus(function(){
    		
            $(this).parent().removeClass("has-error");
            $(this).siblings(".bottomTip").hide();
        }); 
        $("#conChange").click(function(){
        	
        	if(verifyOld($("#oldInput").val())&&verifyCon($("#conInput").val())&&verifyNew($("#newInput").val())){
        		
        		$.ajax({
                     
                     "url":"${basepath}/user/updatepwd.do",
                     "type":"post",
                     "dataType":"json",
                     "data":{                     
                         oldpwd:hex_md5($("#oldInput").val()),
                         newpwd:hex_md5($("#newInput").val())
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
                         alert("系统繁忙");
                     }
                 });
        	}
        	
        });
    });
 
    </script>
    </body>

</html>