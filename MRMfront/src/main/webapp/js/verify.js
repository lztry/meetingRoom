/*名字校验*/
   function isNameEmpty(name){
        	if(name == ""){
        		 $("#nameTip").show();
                 $("#realName").parent().addClass("has-error");
                 return false;
        	}
        	return true;
        }
   /*原因*/
        function isReasonEmpty(reason){
            if(reason == ""){
                 $("#reasonTip").show();
                 $("#reasonTip").html("请输入预约原因")
                 $("#reason").parent().addClass("has-error");
                 return false;
            }
            return true;
        }
        /*手机号校验*/
        function isPhone(phone){
        
            //alert(phone).formError{
            if(phone!=""){
	            var RegCellPhone = /^(1)([0-9]{10})?$/;
	            var  falg=phone.search(RegCellPhone);
	          
	            if (falg==-1){
	            
	               $("#phoneTip").show();
	               $("#phoneTip").html("手机号格式不正确")
	               $("#realPhone").parent().addClass("has-error");
	            //   $("#realPhone").focus();
	               return false;
	            }
            }
            else{
            	 $("#phoneTip").show();
                 $("#phoneTip").html("联系电话不能为空")
                 $("#realPhone").parent().addClass("has-error");
                 return false;
              //   $("#realPhone").focus();
            }
            return true;
        }
        
        
        
        $(function() {
        	
            //取消错误样式
        	$(".formGroup").focus(function(){
        		
        		$(this).parent().removeClass("has-error");
        		$(this).siblings(".bottomTip").hide();
        	}); 
        });