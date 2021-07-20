<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>员工列表</title>
    <%
        //equest.getContextPath()项目路径，以斜线开始不以斜线结束
        pageContext.setAttribute("APP_PATH",request.getContextPath());  ///ssm_crud
    %>
    <!-- web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
            http://localhost:3306/crud
     -->
    <link rel="stylesheet" type="text/css" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <!-- 如果要使⽤Bootstrap的js插件，必须先调⼊jQuery -->
    <script src="${APP_PATH}/static/js/jquery-3.4.1.js" type="text/javascript" charset="UTF-8"></script>
    <!-- 包括所有bootstrap的js插件或者可以根据需要使⽤的js插件调⽤　-->
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js" type="text/javascript" charset="UTF-8"></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel2">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>    <!-- 存放提示信息的地方 -->
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 搭建页面显示 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <div class="h1 text-center">SSM-CRUD</div>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all"/>
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <!-- 显示分页信息 -->
    <div class="row">
        <!-- 分页信息 -->
        <div class="col-md-6" id="page_info_area"></div>
        <!-- 分页条信息 -->
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
    <script type="text/javascript">
        //设置一个全局变量，记录总页码数、当前页码
        var totalPageRecord,currentPage;

        //1、页面加载完成以后，直接发送一个ajax请求，要到分页数据
        $(function () {
            //页面一进来，就来到第一页 首页
            to_page(1);
        });

        function to_page(pn) {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result) {
                    // console.log(result);
                    //1、解析并显示员工数据
                    build_emps_table(result);
                    //2、解析并显示分页信息
                    build_page_info(result);
                    //3、解析显示分页条信息
                    build_page_nav(result);
                }
            });
        }

        function build_emps_table(result) {
            //清空table表格  ajax请求页面无刷新，所以每次获取到数据后都是在原有的基础上append，之前的数据还在；在做所有数据逻辑之前都需要把之前的数据清空(可以删除这一句看效果)
            // 使用empty()删除节点
            $("#emps_table tbody").empty();
            //刷新table表格的同时，让多选框-未选择
            $("#check_all").prop("checked",false);

            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) { //index索引，item返回对象
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                /**
                    <button class="btn btn-primary btn-sm">
                    <span class="glyphicon glyphicon-pencil"></span>
                        编辑
                    </button>
                 */
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn") //edit_btn 自定义标识
                                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                //为编辑按钮添加一个自定义的属性，来表示当前员工id，方便update操作时现根据id查找该员工的信息
                editBtn.attr("edit-id",item.empId);

                var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn") //delete_btn 自定义标识
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                //为删除按钮自定义的属性来表示当前删除的员工id
                deleteBtn.attr("del-id",item.empId);

                var btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);

                //链式操作可以成功的原因：append方法执行完成以后还是返回原来的元素
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
            })
        }

        //解析显示分页信息
        function build_page_info(result) {
            $("#page_info_area").empty();

            $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，" +
                "总"+result.extend.pageInfo.pages+"页，总共"+result.extend.pageInfo.total+"条记录。")
            totalPageRecord = result.extend.pageInfo.pages;
            currentPage = result.extend.pageInfo.pageNum;
        }

        //解析显示分页条，点击分页能去下一页...
        function build_page_nav(result) {
            $("#page_nav_area").empty();

            var ul = $("<ul></ul>").addClass("pagination");

            //构建元素
            var firstPgaeLi = $("<li></li>").append($("<a></a>").append("首页"));
            var prePgaeLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //如果没有上一页
            if (result.extend.pageInfo.hasPreviousPage == false) {
                //这是形式上禁用无法点击，但点击后的效果仍然在
                firstPgaeLi.addClass("disabled");
                prePgaeLi.addClass("disabled");
            } else {    //如果禁用了，就不绑定单击事件了
                //为元素添加点击翻页事件
                firstPgaeLi.click(function () {
                    to_page(1);
                });
                prePgaeLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum-1);
                });
            }

            var nextPgaeLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPgaeLi = $("<li></li>").append($("<a></a>").append("末页"));
            //如果没有下一页
            if (result.extend.pageInfo.hasNextPage == false) {
                nextPgaeLi.addClass("disabled");
                lastPgaeLi.addClass("disabled");
            } else {
                nextPgaeLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum+1);
                });
                lastPgaeLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                });
            }

            //添加首页和前一页的提示
            ul.append(firstPgaeLi).append(prePgaeLi);
            //页码号 1 2 3 遍历给ul中添加页码提示
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
               var numLi = $("<li></li>").append($("<a></a>").append(item));
               if (result.extend.pageInfo.pageNum == item) {
                   numLi.addClass("active");
               }
               //给每一个页码绑定单击事件，进行页码选择
               numLi.click(function () {
                  to_page(item);
               });
               ul.append(numLi);
            });
            //添加下一页和末页提示
            ul.append(nextPgaeLi).append(lastPgaeLi);

            //把ul加入到nav
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo("#page_nav_area");
        }

        //清空表单样式及内容
        function reset_fomr(ele) {
            $(ele)[0].reset();
            //清空表单样式 清空当前元素的校验状态，否则会保留之前的校验状态
            //清空表单颜色样式显示
            $(ele).find("*").removeClass("has-success has-error");
            //清空提示信息说明
            $(ele).find(".help-block").text("");
        }

        //点击新增按钮弹出模态框
        $("#emp_add_modal_btn").click(function () {
            // 问题：ajax请求页面不刷新，则在进行员工添加后继续添加依旧会出现之前的数据，而这些数据之前已经进行了校验，不会再发送ajax请求
            // (例如 用户名重复校验，因为只有在文本框内容变化的是否才会触发单击事件)，所以再次保存还可以保存进去，但此时的用户名重复了，需要表单重置！！！
            // 解决：每次点击弹出模态框，我们可以清除表单数据（表单重置（包括表单的数据和表单的样式））,这样就不会保留上次的保存结果
            // $("#empAddModel form")[0].reset();  //只有dom对象才有reset()方法，所以需要[0]
            reset_fomr("#empAddModel form");

            //发送ajax请求，查出部门信息，显示在下拉列表中
            getDepts("#empAddModel select");
            //弹出模块框
            $("#empAddModel").modal({
                backdrop:"static",
            })
        });

        //查出所有的部门信息并显示在下拉列表中
        function getDepts(ele) {
            //清空之前下拉本列表的值
            $(ele).empty();

            $.ajax({
                url: "${APP_PATH}/depts",
                type: "GET",
                success:function(result) {
                    // console.log(result);
                    //显示部门信息在下拉列表中
                    //"extend":{"depts":[{"deptId":1,"deptName":"开发部门"},{"deptId":2,"deptName":"测试部门"}]}
                    $.each(result.extend.depts,function () {    //遍历，可以传参index,item 也可以不传参用this表示当前对象
                        var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        optionEle.appendTo(ele);  //"#empAddModel select" 表示id为"empAddModel"模态框中的下拉列表下
                    });
                }
            });
        };

        //校验表单数据
        function validate_add_form () {
            //1、拿到要校验的的数据，使用正则表达式（前端校验）
            var empName = $("#empName_add_input").val();
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;    <!-- 仅jsp中正则表达式的开头和结尾需要 / -->
            if (!regName.test(empName)) {
                // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                show_validate_msg("#empName_add_input","error","jquery-用户名可以是2-5位中文或者6-16位英文和数字的组合");
                return false;
            } else {
                show_validate_msg("#empName_add_input","success","");
            }

            //bug修复：在校验表单中 用户名 数据之前，ajax校验了用户名重复校验，但此时进行的用户名校验用覆盖之前用户名重复的结果
            //所以还需检查ajax-va属性值，在通过jquery用户名校验后，还原ajax用户名重复的校验结果
            // alert(this);
            if ($("#emp_save_btn").attr("ajax-va") == "error") {
                // alert("错误！");
                show_validate_msg("#empName_add_input","error","用户名不可用");   //页面保存时错误信息也消失了，所以在保存时再设置一次错误信息
                return false;
            }

            //2、校验邮箱信息
            var email = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                // alert("邮箱格式不正确");
                show_validate_msg("#email_add_input","error","jquery-邮箱格式不正确");
                // $("#email_add_input").parent().addClass("has-error");
                // $("#email_add_input").next("span").text("邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#email_add_input","success","");
                // $("#email_add_input").parent().addClass("has-success");
                // $("#email_add_input").next("span").text("");
            }

            return true;
        }

        //显示校验结果的提示信息
        function show_validate_msg(ele,status,msg) {
            //清空当前元素的校验状态，否则会保留之前的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if ("success"==status) {
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            } else if ("error"==status) {
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //校验用户名是否可用
        $("#empName_add_input").change(function () {
            //发送ajax请求校验用户名是否可用
            var empName = this.value;   //this.value 表示当前输出框的只
            $.ajax({
                url:"${APP_PATH}/checkuser",
                data:"empName="+empName,
                type:"POST",
                success:function (result) {
                    if (result.code == 100) {
                        show_validate_msg("#empName_add_input","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-va","success");
                    } else {
                        show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va","error");
                    }
                }
            });
        });

        //点击保存，保存员工的方法
        $("#emp_save_btn").click(function () {
            //1、模态框中填写的表单数据提交给服务器进行保存
            //1.1、先对要提交给服务器的数据进行jquery前端校验(不安全，所以还需要后端校验)
            if (!validate_add_form()) {
                return false;
            }

            //1.2、判断之前的ajax用户名校验是否成功，如果成功继续走...
            if ($(this).attr("ajax-va") == "error") {
                // alert("错误！");
                //show_validate_msg("#empName_add_input","error","用户名不可用");   //页面保存时错误信息也消失了，所以在保存时再设置一次错误信息
                return false;
            }

            //2、发送ajax请求保存员工
            //alert($("#empAddModel form").serialize());  //empName=tomcat&email=tomcat@qq.com&gender=M&dId=1
            $.ajax({
                url:"${APP_PATH}/emp",
                type:"POST",
                data: $("#empAddModel form").serialize(),    //serialize()表单序列化
                success:function (result) {
                    // alert(result.msg);
                    //员工保存成功；
                    if (result.code == 100) {
                        //1、关闭模态框
                        $("#empAddModel").modal('hide');
                        //2、来到最后一页，显示最好保存的数据
                        //发送ajax请求显示最后一页数据即可，解决：分页插件总会把大于总页码的数据 查询到最后一页的数据
                        to_page(totalPageRecord+1);
                    } else {
                        //显示失败信息
                        // console.log(result);
                        //有哪个字段的错误信息就显示哪个字段的
                        if (undefined != result.extend.errorFields.email) {
                            //显示邮箱错误信息
                            show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                        }
                        if (undefined != result.extend.errorFields.empName) {
                            //显示员工名字错误信息
                            show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                        }
                    }

                }
            });
        });

        //原则：如果是后来创建的按钮（例如经过ajax查询员工后，给每个员工创建的修改、删除按钮）就需要使用on()方法来绑定事件【on()方法可以为后来添加的元素绑定事件】
        //如果是在页面加载时就创建的元素，可以直接绑定事件(例如给新建按钮绑定click()事件，就可以直接绑定)

        //给 编辑 按钮绑定单击事件
        //问题：我们是在创建按钮之前就绑定了click，所以绑定不上
        //解决方法：1）可以在创建按钮的时候绑定 2）使用.live()代替.click 可以为后来添加的元素绑定事件
        //jquery新版本没有live()方法，使用on()代替
        $(document).on("click",".edit_btn",function () {    //为【$(document)】整个文档中，给【.edit_btn】class为edit_btn元素的click事件绑定
            // alert("edit");
            //1、查出部门信息，并显示部门列表
            getDepts("#empUpdateModel select");
            //2、查出员工信息，显示员工信息
            getEmp($(this).attr("edit-id"));
            //3、把员工的id传递给模态框的更新按钮
            $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
            //弹出模块框
            $("#empUpdateModel").modal({
                backdrop:"static",
            })
        });

        function getEmp(id) {
            $.ajax({
                url:"${APP_PATH}/emp/"+id,
                type:"GET",
                success:function (result) {
                    // console.log(result);
                    var empData = result.extend.emp;
                    $("#empName_update_static").text(empData.empName);
                    $("#email_update_input").val(empData.email);
                    $("#empUpdateModel input[name=gender]").val([empData.gender]);
                    $("#empUpdateModel select").val([empData.dId]);
                }
            });
        };

        //点击更新，更新员工信息
        $("#emp_update_btn").click(function () {
            //验证邮箱是否合法
            //1、校验邮箱信息
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                show_validate_msg("#email_update_input","error","jquery-邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#email_update_input","success","");
            }

            //2、发送ajax请求保存更新的员工数据
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
                type:"PUT",
                //员工表单数据序列化，序列化结果为：参数1=值1&参数2=值2；例如 email=aaaaa%40163.comaaa&gender=M&dId=1
                data:$("#empUpdateModel form").serialize(),   //设置为put请求
                // type:"POST",
                // data:$("#empUpdateModel form").serialize() + "&_method=PUT",   //设置为put请求
                success:function (result) {
                    // alert(result.msg);
                    //1、关闭对话框
                    $("#empUpdateModel").modal('hide');
                    //2、回到页面
                    to_page(currentPage);
                }
            });
        });

        //单个删除
        $(document).on("click",".delete_btn",function () {
            //1、确认删除对话框
            var empName = $(this).parents("tr").find("td:eq(2)").text();    //当前按钮的父标签中的第三个<td>标签的值
            // alert($(this).parents("tr").find("td:eq(1)").text());
            var empId = $(this).attr("del-id")
            if (confirm("确认删除【"+empName+"】吗？")) {
                //2、确认，发送ajax请求删除即可
                $.ajax({
                    url:"${APP_PATH}/emp/"+empId,
                    type:"DELETE",
                    success:function (result) {
                        //alert(result.msg);
                        //回到本页
                        to_page(currentPage);
                    }
                })
            }
        });

        //点击复选框-完成全选/全不选功能
        $("#check_all").click(function () {
            //attr获取ckecked是unddfined;
            //我们这些dom元素的属性使用prop来获取；attr获取自定义属性的值；
            //使用prop修改和读取dom原生属性的值
            // alert($(this).prop("checked"));
            $(".check_item").prop("checked",$(this).prop("checked"));
        });
        //当表单中所有的员工被选中，则全选框也被选中
        $(document).on("click",".check_item",function () {
            //判断当前选择的元素是否是5个（5为当前页显示的员工个数）
            var flag =  $(".check_item:checked").length == $(".check_item").length;
            $("#check_all").prop("checked",flag);   //checked=true或者checked=checked都可以实现选中
        });

        //点击全部删除，就批量删除
        $("#emp_delete_all_btn").click(function () {
            var empNames = "";    //拼接要批量删除的员工姓名
            var del_idstr = "";     //拼接要批量删除的员工id
            //遍历每一个被选中的元素
            $.each($(".check_item:checked"),function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
                del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
            });
            //去除empNames和del_idstr最后的'，'和'-'
            empNames = empNames.substring(0,empNames.length-1);
            del_idstr = del_idstr.substring(0,del_idstr.length-1);
            if (confirm("确认删除【"+empNames+"】吗？")) {
                //发送ajax请求删除
                $.ajax({
                    url:"${APP_PATH}/emp/"+del_idstr,
                    type:"DELETE",
                    success:function (result) {
                        alert(result.msg);
                        //回到当前页面
                        //在回到当前页前，使全选框-未选中
                        $("#check_all").prop("checked",false);
                        to_page(currentPage);
                    }
                });
            }
        });

    </script>
</div>
</body>
</html>
