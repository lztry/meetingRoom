function showRemind(conf){
	//透明度为1
    //颜色深蓝 
    toastr.options = {  
            closeButton: true,                                            // 是否显示关闭按钮，（提示框右上角关闭按钮）
            debug: false,                                                    // 是否使用deBug模式
            positionClass: "toast-top-full-width",              // 设置提示款显示的位置
            onclick: null,                                                     // 点击消息框自定义事件 
            showDuration: "300",                                      // 显示动画的时间
            hideDuration: "1000",                                     //  消失的动画时间
            timeOut: null,                                             //  自动关闭超时时间 
            extendedTimeOut: null,                             //  加长展示时间
            showEasing: "swing",                                     //  显示时的动画缓冲方式
            hideEasing: "linear",                                       //   消失时的动画缓冲方式
            showMethod: "fadeIn",                                   //   显示时的动画方式
            hideMethod: "fadeOut"                                //   消失时的动画方式
        };
       if(conf.isSu==true)
       toastr.success("<a href="+conf.suHref+">您预约的会议室"+conf.situ+ "已通过预约（点击查看详情）</a>");
       else
       toastr.info("<a href="+conf.inHref+">您预约的会议室"+conf.situ+"预约失败（点击查看详情）</a>");
	
}