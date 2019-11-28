<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<!DOCTYPE html>
<html>
<!-- Mirrored from www.zi-han.net/theme/hplus/empty_page.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 20 Jan 2016 14:19:52 GMT -->
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息</title>
    <link href="${basepath }/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="${basepath }/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">

    <link href="${basepath }/css/animate.min.css" rel="stylesheet">
    <link href="${basepath }/css/style.min862f.css?v=4.1.0" rel="stylesheet">

</head>

<body class="gray-bg">
    <div class="row wrapper border-bottom white-bg page-heading">
        <div class="col-sm-4">
            <h2>个人中心</h2>
        </div>
    </div>

    <div class="wrapper wrapper-content">
        <div class="row">
            <div class="col-md-offset-1 col-md-9">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                     	 个人资料
                    </div>
                    <div class="ibox-content">
                    	 <form method="post" class="form-horizontal" id="personForm">
                            <div class="form-group">
                                <label class="col-sm-2 control-label">工号</label>

                                <div class="col-sm-9">
                                    <input type="text" class="form-control" disabled="disabled" value="${islogin.account }">
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">系别</label>

                                <div class="col-sm-9">
                                    <input type="text" class="form-control"  value="${islogin.department }" disabled="disabled">
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                             <div class="form-group">
                                <label class="col-sm-2 control-label">姓名</label>

                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="realname" name="realname" value="${islogin.name }">
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                             <div class="form-group">
                                <label class="col-sm-2 control-label">联系方式</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="phone" name = "phone" value="${islogin.phone }">
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <div class="col-sm-4 col-sm-offset-2">
                                    <button class="btn btn-primary" type="submit">保存</button>
                                 </div>
                            </div>
                        </form>
                   
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${basepath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basepath }/js/bootstrap.min.js?v=3.3.6"></script>
    <script src="${basepath }/js/content.min.js?v=1.0.0"></script>
    <script src="${basepath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basepath }/js/plugins/validate/additional-methods.js" ></script>
    <script type="text/javascript">
    $.validator.setDefaults({
        highlight: function(e) {
            $(e).closest(".form-group").removeClass("has-success").addClass("has-error")
        },
        success: function(e) {
            e.closest(".form-group").removeClass("has-error").addClass("has-success")
        },
        errorElement: "span",
        errorPlacement: function(e, r) {
            e.appendTo(r.is(":radio") || r.is(":checkbox") ? r.parent().parent().parent() : r.parent())
        },
        errorClass: "help-block m-b-none",
        validClass: "help-block m-b-none"
    })
    $().ready(function() {
        var e = "<i class='fa fa-times-circle'></i> ";
        $("#personForm").validate({
        	onfocusout:false,
            rules: {
                realname: "required",
                phone: {
                	 required: !0,
                     isMobile : true 
                },
            },
            messages: {
            	realname: e + "请输入您的名字",
                phone: {
                     required: e + "请输入您的手机号",
                     isMobile : e + "手机号格式不对哟"
                },
            }
        })
    });
    </script>
</body>


</html>
