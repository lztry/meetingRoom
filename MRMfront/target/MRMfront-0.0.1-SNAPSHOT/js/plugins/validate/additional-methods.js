//手机号码验证  
jQuery.validator.addMethod("isMobile", function(value, element) {  
 var length = value.length;  
 var mobile = /^(1)([0-9]{10})?$/;  
 return this.optional(element) || (length == 11 && mobile.test(value));  
}, "请正确填写手机号码");  