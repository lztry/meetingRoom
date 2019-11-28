<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
   <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">
<title>图表统计</title>
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>预约情况</h5>
                    </div>
                    <div class="ibox-content">
                       <div  id="lineMain" style="min-height: 300px;width: 100%;"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>使用比例</h5>
                    </div>
                    <div class="ibox-content">
                       <div  id="pieMain" style="min-height: 250px;width: 100%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basepath }/js/plugins/echart/echarts-all.js"></script>
    <script type="text/javascript">
     
        $.ajax({
        	url:"${basepath}/statistic/countNum.do",
        	dataType:"json",
        	data:{userId:${islogin.id}},
        	success:function(data){
                var myChart = echarts.init(document.getElementById('lineMain'));
                var xAxisData = [];
                var yAxisData = [];
                for(var i=0;i<data.length;i++){
                	xAxisData[i]=data[i].monthDate;
                	yAxisData[i]=data[i].appointCount;
                }
            	var option = {
           			title : {
           		        text: '近12个月会议室使用次数',
           		        subtext: '不包含取消的预约'
           		    },
           		    tooltip : {
           		        trigger: 'axis'
           		    },
           		    toolbox: {
           		        show : true,
           		        feature : {
           		            magicType : {show: true, type: ['line', 'bar']},
           		            restore : {show: true},
           		        }
           		    },
           		    calculable : true,	
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data:xAxisData
                    },
                    yAxis: {
                    	minInterval: 1,
                        type: 'value'
                    },
                    series :[{
                    	name:"预约次数",
                        type:'line',
                        data:yAxisData,
                        markPoint : {
                            data : [
                                {type : 'max', name: '最大值'},
                                {type : 'min', name: '最小值'}
                            ]
                        },
                        markLine : {
                            data : [
                                {type : 'average', name: '平均值'}
                            ]
                        }
                    }],
                 };
                 myChart.hideLoading();
                 myChart.setOption(option);  
        	}
        });
        $.ajax({
        	url:"${basepath}/statistic/roomStatis.do",
            dataType:"json",
            data:{userId:${islogin.id}},
            success:function(data){
            	var myChart = echarts.init(document.getElementById('pieMain'));
            	var option = {
           		    title : {
           		        text: '近12个月会议室的使用比例',
           		        subtext: '不包含取消的预约',
           		        x:'center'
           		    },
           		    tooltip : {
           		        trigger: 'item',
           		        formatter: "{a} <br/>{b} : {c}次 ({d}%)",
           		        
           		    },
           		    calculable : true,
           		    series : [
           		        {
           		            name:'使用比例',
           		            type:'pie',
           		            radius : '55%',
           		            center: ['50%', '60%'],
           		            data:data
           		        }
           		    ]
           		};
           	    myChart.hideLoading();
                myChart.setOption(option);	                    
            }
        })
    </script>
</body>
    
</html>