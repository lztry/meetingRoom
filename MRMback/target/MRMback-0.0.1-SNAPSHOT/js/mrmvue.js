var app=new Vue({
	el:"#app",
	data:{},
	created:function(){
		  if(getCookie('username')==""){
			  window.location.href='${basepath}/user/login.do';
		  }
		
	}
	
});