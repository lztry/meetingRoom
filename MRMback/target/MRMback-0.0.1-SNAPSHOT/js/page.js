(function($){
	$.fn.mypage=function(options){
		var defaultParams={pageNo:1,params:""}
		var setting=$.extend(defaultParams,options);
		return $(this).each(function(index,element){
			if(setting.pageNo==1){
				$(element).append($('<span class="current">首页</span>'));
				$(element).append($('<span class="current">上一页</span>'));
			}else{
				$(element).append($('<a href="'+setting.url+'?pageNo=1'+setting.params+'">首页</a>'));
				$(element).append($('<a href="'+setting.url+'?pageNo='+(setting.pageNo-1)+setting.params+'">上一页</a>'));
			}
			if(setting.totalPage<=10){
				for(var i=1;i<=setting.totalPage;i++){
					if(setting.pageNo==i){
						$(element).append($('<span class="current">'+i+'</span>'));
					}else{
						$(element).append($('<a href="'+setting.url+'?pageNo='+i+setting.params+'">'+i+'</a>'));
					}
				}
			}else{
				var min=setting.pageNo-4;
				var max=setting.pageNo+5;
				if(min<=0){
					min=1;
					max=10;
				}
				if(max>setting.totalPage){
					max=setting.totalPage;
					min=max-9;
				}
				for(var i=min;i<=max;i++){
					if(setting.pageNo==i){
						$(element).append($('<span class="current">'+i+'</span>'));
					}else{
						$(element).append($('<a href="'+setting.url+'?pageNo='+i+setting.params+'">'+i+'</a>'));
					}
				}
			}
			if(setting.pageNo==setting.totalPage){
				$(element).append($('<span class="current">下一页</span>'));
				$(element).append($('<span class="current">尾页</span>'));
			}else{
				$(element).append($('<a href="'+setting.url+'?pageNo='+(setting.pageNo+1)+setting.params+'">下一页</a>'));
				$(element).append($('<a href="'+setting.url+'?pageNo='+setting.totalPage+setting.params+'">尾页</a>'));
			}
		});
	}
})(jQuery)