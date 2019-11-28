//日期格式化
            Date.prototype.format = function(fmt) { //author: meizz   
                var o = {
                    "M+": this.getMonth() + 1, //月份   
                    "d+": this.getDate(), //日   
                    "h+": this.getHours(), //小时   
                    "m+": this.getMinutes(), //分   
                    "s+": this.getSeconds(), //秒   
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度   
                    "S": this.getMilliseconds() //毫秒   
                };
                if(/(y+)/.test(fmt))
                    fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for(var k in o)
                    if(new RegExp("(" + k + ")").test(fmt))
                        fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                return fmt;
            }
            function toDate(dateStr) {  
                var params = [0,0,0,0,0,0];
                var dataArr = dateStr.split(/\s|\-|\:/g);
               
                for(var i =0;i<dataArr.length;i++){
                    params[i] =parseInt(dataArr[i]) ;
                }
               return new Date(params[0],params[1]-1,params[2],params[3],params[4],params[5]);
           }
            function getNowFormatDate() {
    	        var date = new Date();
    	        var seperator1 = "-";
    	        var year = date.getFullYear();
    	        var month = date.getMonth() + 1;
    	        var strDate = date.getDate();
    	        if (month >= 1 && month <= 9) {
    	            month = "0" + month;
    	        }
    	        if (strDate >= 0 && strDate <= 9) {
    	            strDate = "0" + strDate;
    	        }
    	        var currentdate = year + seperator1 + month + seperator1 + strDate; 
    	        return currentdate;
    	}
