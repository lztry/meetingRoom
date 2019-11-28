<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/WEB-INF/common/Head.jsp" %>
<!doctype html>
<html lang="ch">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="description" content="左右结构项目，属于大人员的社交工具">
        <meta name="keywords" content="左右结构项目 社交 占座 ">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <meta name="format-detection" content="telephone=no">
        <title>系别维护</title>
        <link href="${basepath}/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${basepath }/css/common.css" />
        <link rel="stylesheet" type="text/css" href="${basepath }/css/slide.css" />
        <link rel="stylesheet" type="text/css" href="${basepath }/css/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="${basepath }/css/flat-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="${basepath }/css/jquery.nouislider.css">
        <script src="${basepath}/js/jquery.min.js"></script>
        <script src="${basepath}/js/vue.min.js"></script>
        <script src="${basepath}/js/jquery.form.js"></script>
        <style>
            @-moz-document url-prefix() { fieldset { display: table-cell; } }
            
        </style>
        <style>
        [v-cloak]{display:none}
        </style>
    </head>

    <body >
        <div id="wrap" v-cloak>
                    <div  class="table-responsive " >
               <button type="button" class="btn btn-success btn-lg" @click="add()" style="margin-left: 15%"><span>添加</span></button>      
       <form id="fm" method="post" action="${basepath }/department/update.do">
        <table class="table table-striped table-bordered" style="width:70%;margin-left: 15%" >
          <thead>
            <tr>
              <th style="width: 30%">编号</th>
              <th style="width: 40%">名称</th>
              <th style="width: 30%">操作</th>
            </tr>
          </thead>
          <tbody>
                    <tr v-for="department in departments" >
                        <td>{{department.id }}</td>
                        <td v-if="selectid!=department.id">{{department.name }}</td>
                        <td  v-else>
                           <input name="name" :value="department.name">
                        </td>
                        <td >
	                        <a v-if="selectid!=department.id" href="javascript:void(0)" class="btn btn-success" @click="selectid=department.id" >编辑</a>
	                         <a v-else href="javascript:void(0)" class="btn btn-success" @click="save()" >保存</a> 
                            <!-- <a href="javascript:void(0)" class="btn btn-danger" @click="del(department.id)">删除</a> -->
                        </td>
                    </tr>
          </tbody>
        </table>
        </form>
        
    
                    </div>
                </div>
         

    </body>
    <script>
        
        $(function() {
            
            var department;
            $.ajax({
                "url":"${basepath}/department/list.do",
                "async":false,
                "dataType":"json",
                "type":"get",
                success:function(data){
                    department=data;
                }
            }); 
            var vue=new Vue({
                el:"#wrap",
                data:{
                    departments:department,
                    selectid:-1  
                },
                watch:{
                	selectid:function(val){
                		if(val!=-1){
                			if(!confirm("修改系别会导致用户的系别和会议室系别改变，是否继续修改？")){
                				this.selectid=-1
                			}
                		}
                	}
                },
                methods:{
                      save:function(){
                            $("#fm").ajaxSubmit({
                                data:{id:vue.selectid},
                                success:function(data){
                                	window.location.reload();
                                    
                                }
                            });
                      },
                      add:function(){
                          var newname = window.prompt("请输入要添加的系名","");           
                          if(newname.trim()!=null&&newname.trim()!="")
                              {
                                $.ajax({
                                    "url":"${basepath}/department/add.do",
                                    "async":false,
                                    "data":{name:newname},
                                    "dataType":"json",
                                    "type":"get",
                                    success:function(data){
                                        window.location.reload();
                                    }
                                });
                              }
                        },
                        del:function(id){
                             if(confirm("是否要删除")){
                                 alert(id);
                                   /*  window.location.href="${basepath}"+"/department/del.do?id="+id; */
                                }
                        }
                      }
                
                
                
            });
        });

        </script>
      

</html>