/*
 * 分页条id 意义
 * 0首页
 * -1尾页
 * -2上一页
 * -3下一页
 */
(function($){
	$.fn.mypage=function(options){
		var defaultParams={pageNo:1,params:""}
		var setting=$.extend(defaultParams,options);
		return $(this).each(function(index,element){
			if(setting.pageNo==1){
				$(element).append($('<span class="current">首页</span>'));
				$(element).append($('<span class="current">上一页</span>'));
			}else{
				$(element).append($('<a id="0" href="javascript:void(0)">首页</a>'));
				$(element).append($('<a id="-2" href="javascript:void(0)">上一页</a>'));
			}
			if(setting.totalPage<=10){
				for(var i=1;i<=setting.totalPage;i++){
					if(setting.pageNo==i){
						$(element).append($('<span class="current">'+i+'</span>'));
					}else{
						$(element).append($('<a id="'+i+'" href="javascript:void(0)">'+i+'</a>'));
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
						$(element).append($('<a id="'+i+'" href="javascript:void(0)">'+i+'</a>'));
					}
				}
			}
			if(setting.pageNo==setting.totalPage){
				$(element).append($('<span class="current">下一页</span>'));
				$(element).append($('<span class="current">尾页</span>'));
			}else{
				$(element).append($('<a id="-3" href="javascript:void(0)">下一页</a>'));
				$(element).append($('<a id="-1" href="javascript:void(0)">尾页</a>'));
			}
		});
	}
})(jQuery)