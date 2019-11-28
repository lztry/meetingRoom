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
	
		    <div class="input-group" style="margin: 10px auto; width: 500px;">
		      <input type="text" class="form-control" id="searchInput" v-if="searchWay==1" placeholder="请输入用户名" v-model="searchText">
		       <input type="text" class="form-control" id="searchInput" v-if="searchWay==2" placeholder="请输入会议室" v-model="searchText">
		      <div class="input-group-btn">
		        <button style="padding:7px;" type="button" class="btn btn-primary" @click="search()"><span v-if="searchWay==1">检索(按用户名)</span> <span v-else>检索(按会议室)</span></button>
		        <button style="padding:7px;width: 25px;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="btn btn-defult active dropdown-toggle"><span class="caret"></span></button>
		        <ul class="dropdown-menu dropdown-menu-right">
		          <li><a href="javascript:void(0);" @click="searchWay=1">按照用户名检索</a></li>
		          <li role="separator" class="divider"></li>
		          <li><a href="javascript:void(0);" @click="searchWay=2">按照会议室检索</a></li>
		        </ul>
		      </div><!-- /btn-group -->
		    </div><!-- /input-group -->
		  
		<div class="table-responsive ">
			<table class="table table-striped table-condensed" 
				width="100%">
				<thead>
					<tr>
						<th>申请时间</th>
						<th>申请人</th>
						<th>实际使用</th>
						<th>预约会议室</th>
						<th>起止时间</th>
						<th>预约原因</th>
						<th>处理结果</th>
					
					</tr>
				</thead>
				<tbody>
					
					<tr v-for="(appoint,index) in appointList">
						<td>{{appoint.submitTime}}</td>
						<td>{{appoint.user.name}}<br />{{appoint.user.account}} </td>
					    <td>{{appoint.realName}}<br/>{{appoint.realPhone}}</td>
						<td>{{appoint.meetingRoom.name}}</td>
						<td>{{appoint.appointTime}} <br />{{appoint.appointStart}}:00~{{appoint.appointEnd}}:00 </td>
						<td>{{appoint.reason}}</td>
						<td v-if="appoint.state==1">已通过</td>
						<td v-if="appoint.state==2">已驳回<br/></td>
						<td v-if="appoint.state==3">已取消<br/></td>
					</tr>
					
				</tbody>
			</table>
			   <div id="pagelist" class="pagelist" ></div>
               <h1  id="tips" align="center" style="display:none"> </h1>
               


		</div>
	</div>

</body>
<script src="${basepath}/js/jquery.min.js"></script>
<script src="${basepath}/js/bootstrap.min.js"></script>
<script src="${basepath }/js/ajaxpage.js"></script>
<script src="${basepath}/js/vue.min.js"></script>
<script>
	//分页条属性选项
	var pageNo=1;
	var totalPage=0;
    $(function(){
    	  //分页条点击事件
        $('body').on('click','#pagelist>a',function(){
          
            var myPageNo = pageNo;
            switch($(this).attr("id"))
            {
            case "0":
              myPageNo = 1;
              break;
            case "-1":
              myPageNo = totalPage;
              break;
            case "-2":
               myPageNo--; 
               break;
            case "-3":
              myPageNo++;
               break;    
            default:
               myPageNo = $(this).attr("id");
            }
            vue.myPageNo=myPageNo;
       
         }); 
    });
    $.ajax({
        url:"${basepath}/appoint/queryRecord.do",
        type:"get",
        dataType:"json",
        beforeSend: function () {
            $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
        },
        complete: function (XMLHttpRequest,status) {
            $("#pload").remove();
        },
        success:function(data){
            vue.appointList=  data.resultList;
            $("#pagelist").empty();
            pageNo = data.page.pageNo;
            totalPage = data.page.pages;
            if(totalPage != 0){
                $("#pagelist").mypage({
                      pageNo:pageNo,
                      totalPage:data.page.pages
                  }); 
            }
            
        }
    })   
     function query(){
          $("#tips").hide();
          $.ajax({
              url:"${basepath}/appoint/queryRecord.do",
              data:{
                  params:vue.params,
                  pageNo:vue.myPageNo,
                  searchWay:vue.searchWay
              },
              beforeSend: function () {
                  $("body").append('<div id="pload" style="position:fixed;top:30%;z-index:1200;background:url(${basepath }/img/load.gif) top center no-repeat;width:100%;height:340px;margin:auto auto;"></div>');
              },
              complete: function (XMLHttpRequest,status) {
                  $("#pload").remove();
              },
              dataType:"json",
              success:function(data){
            	
            	  if(data.page!=null){
	                  vue.appointList = data.resultList;
	                  $("#pagelist").empty();
	                  pageNo = data.page.pageNo;
	                  totalPage = data.page.pages;
	                  if(totalPage != 0){
	                      $("#pagelist").mypage({
	                            pageNo:pageNo,
	                            totalPage:data.page.pages
	                        }); 
	                  }
	                  else{
	                      $("#tips").show();
	                      $("#tips").html("没有满足条件的预约信息");
	                  }
            	  }
            	  else{
            		  $("#pagelist").empty();
            		  vue.appointList = [];
            		  $("#tips").show();
                      $("#tips").html("没有满足条件的预约信息");
            	  }
              }
          });
      }
	var vue = new Vue({
        el:"#wrap",
        data:{
        	myPageNo:0,
            appointList:[],
            searchWay:1,
            params:"",
            searchText:""
        },
        methods:{
            search:function() {
                this.myPageNo=1;
                totalPage=0;
                this.params=this.searchText;
                query();
            }
        },
        watch:{
            myPageNo:function(val){
                query();
            }
        }
        
	});                
</script>

</html>