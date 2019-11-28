<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<!doctype html>
<html lang="ch">

<head>
    <meta charset="utf-8">
    <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${basepath }/css/common.css" />
    <style>
    [v-cloak]{display:none}
        .pagelist {text-align:center; margin-top: -5px;}
         .pagelist span,.pagelist a{ border-radius:3px; border:1px solid #dfdfdf;display:inline-block; padding:5px 12px;}
         .pagelist a{ margin:0 3px; text-decoration:none}
         .pagelist span.current{ background:#09F; color:#FFF; border-color:#09F; margin:0 2px;}
         .pagelist a:hover{background:#09F; color:#FFF; border-color:#09F; }
         .pagelist label{ padding-left:15px; color:#999;}
         .pagelist label b{color:red; font-weight:normal; margin:0 3px;}
         .input-group input,.input-group button{
           height: 42px;
           font-size: 15px;
         }
         .input-group{
           
         }
    </style>
</head>

<body>
    <div id="wrap" v-cloak>
          
        <div class="table-responsive" style = "padding:10px">
            <table class="table table-striped table-condensed" cellspacing="0"
                width="100%">
                <thead>
                    <tr>
                        <th>申请时间</th>
                        <th>实际使用</th>
                        <th>预约会议室</th>
                        <th>起止时间</th>
                        <th>预约原因</th>
                        <th>操作</th>
                    
                    </tr>
                </thead>
                <tbody>
                    
                    <tr v-for="(appoint,index) in appointList">
                        <td>{{appoint.submitTime}}</td>
                        <td>{{appoint.realName}}<br/>{{appoint.realPhone}}</td>
                        <td>{{appoint.meetingRoom.name}}</td>
                        <td>{{appoint.appointTime}} <br />{{appoint.appointStart}}:00~{{appoint.appointEnd}}:00 </td>
                        <td>{{appoint.reason}}</td>
                        <td>
                           <button type="button" class="btn btn-danger" @click="cancel(appoint.id)">取消</button>
                        </td>
                    </tr>
                    
                </tbody>
            </table>
        </div>
    </div>
</body>
<script src="${basepath}/js/jquery.min.js"></script>
<script src="${basepath}/js/bootstrap.min.js"></script>
<script src="${basepath }/js/ajaxpage.js"></script>
<script src="${basepath}/js/vue.min.js"></script>
<script>
   
    $.ajax({
        url:"${basepath}/appoint/selfappoint.do",
        data:{
        	id:${islogin.id}
        },
       // async:false,
        type:"post",
        dataType:"json",
        beforeSend: function () {
            $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
        },
        complete: function (XMLHttpRequest,status) {
            $("#pload").remove();
        },
        success:function(data){
        	console.log(data)
            vue.appointList=  data;
        }
    })   
    var vue = new Vue({
        el:"#wrap",
        data:{
            appointList:[]
        },
        methods:{
	        cancel:function(id){
	            if(confirm("是否要取消预约?")){
	                $.ajax({
	                    url:"${basepath}/appoint/cancelAppoint.do",
	                    data:{aid:id},
	                    type:"get",
	                    success:function(data){
	                        alert("取消成功");
	                        window.location.reload();
	                        $("#pload").remove();
	                    }
	                });
	           }
	        }
        }
    });                
</script>

</html>