<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>已读消息</title>
        <link rel="stylesheet" type="text/css" href="${basepath }/css/bootstrap.min.css" />
        <link href="${basepath }/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
        <link href="${basepath }/css/animate.min.css" rel="stylesheet">
        <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet"> 
        <link href="${basepath }/css/plugins/iCheck/custom.css" rel="stylesheet"> 
        <link href="${basepath }/css/plugins/sweetalert/sweetalert2.min.css" rel="stylesheet"> 
       <style>
       html,body{
        font-size: 14px;
       }
       </style>   
</head>
<body>
     
       <div id="wrap" >
         <div class="col-sm-12 animated">
                <div class="mail-box-header">

                    <h2>
                                  已读消息
                </h2>
                    <div class="mail-tools tooltip-demo m-t-md">
                        <div class="btn-group pull-right">
                            <button <c:if test="${page.pages <= 1|| page.pageNo == 1}" >disabled</c:if> class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="上一页" onclick="window.location.href='${basepath}/message/readed.do?pageNo=${page.pageNo-1 }'"><i class="fa fa-arrow-left"></i>
                            </button>
                            <button <c:if test="${page.pages == page.pageNo|| page.pages <= 1}" >disabled</c:if> class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="下一页" onclick="window.location.href='${basepath}/message/readed.do?pageNo=${page.pageNo+1 }'"><i class="fa fa-arrow-right"></i>
                            </button>
                            

                        </div>
                        <button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="刷新消息列表" onclick="window.location.reload();"><i class="fa fa-refresh"></i> 刷新</button>
                        <button id="delMsgBtn" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="删除"><i class="fa fa-trash-o"></i> 删除
                        </button>
                        <button id="delAllMsgBtn" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="全部删除">全部删除
                        </button>

                    </div>
                </div>
                <div class="mail-box">
                  <c:if test="${page.pages==0 }">
                    <h1  align="center"> 暂无消息</h1>
                  </c:if>

                    <table class="table table-hover table-mail">
                        <tbody>
                            <c:forEach items="${messageList }" var="message">
	                            <tr class="read">
	                                <td class="check-mail">
	                                    <input class="i-checks"  type="checkbox" value="${message.id }">
	                                </td>
	                                <td class="mail-ontact">${message.situation}
	                                   <c:if test="${ message.state == 2}">
	                                        <span class="label label-danger pull-right">&nbsp;&nbsp;失败  &nbsp;&nbsp;</span>
	                                   </c:if>
	                                   <c:if test="${ message.state == 1}">
	                                        <span class="label label-primary pull-right">&nbsp;&nbsp;成功  &nbsp;&nbsp;</span>
	                                   </c:if>
	                                </td>
	                                <td class="mail-subject">${message.content}
	                                </td>
	                                <td class="text-right mail-date"><fmt:formatDate value="${message.createTime}" pattern="yyyy年MM月dd日HH点mm分" /></td>
	                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
       
       </div>                
    </body>
    
    <script src="${basepath}/js/jquery.min.js"></script>
    <script src='../js/bootstrap.min.js'></script>
    <script src="${basepath}/js/content.min.js?v=1.0.0"></script>
    <script src="${basepath}/js/plugins/iCheck/icheck.min.js"></script>
    
    <script src="${basepath }/js/plugins/sweetalert/sweetalert2.min.js" ></script>
    <!-- 兼容ie -->
    <script src = "https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"> </script>
    <script type="text/javascript">
      $(document).ready(function(){$(".i-checks").iCheck({checkboxClass:"icheckbox_square-green",radioClass:"iradio_square-green",})});
      $(function(){
    	 $("#delMsgBtn").click(function(){
    		 var checked_array=[];
    		 $('input[type=checkbox]:checked').each(function(i,o){
    		        checked_array.push(o.value);
    		  });
    		 if(checked_array.length == 0)
    			 return;
    		 swal({
                 title: '确定删除',
                 text: '删除后无法恢复，您确定要删除吗？',
                 type: 'warning',
                 showCancelButton: true,
                 focusConfirm: false,
                 allowOutsideClick:false,
                 confirmButtonText: '确定',
                 cancelButtonText:'取消',
                 focusConfirm: false,
             }).then(function(result){
                 if (result.value) {
                	$.ajax({
                		url:"${basepath}/message/delReaded.do",
                		data:{idList:checked_array},
                		type:"post",
                		success:function(data){
                			 swal({
                                 title: '删除成功',
                                 type: 'success',
                                 allowOutsideClick:false,
                                 confirmButtonText: '确定',
                             }).then(function(result){window.location.reload();});
                		}
                	}) 
                 }
             });
    	 });
    	 //全部删除
    	 $("#delAllMsgBtn").click(function(){
    		 swal({
                 title: '全部删除',
                 text: '删除后无法恢复，您确定要全部删除吗？',
                 type: 'warning',
                 showCancelButton: true,
                 focusConfirm: false,
                 allowOutsideClick:false,
                 confirmButtonText: '确定',
                 cancelButtonText:'取消',
                 focusConfirm: false,
             }).then(function(result){
            	 if (result.value) {
                     window.location.href="${basepath}/message/delAllReaded.do";
                  }
             })
    	 });
      });
    </script>     


</html>