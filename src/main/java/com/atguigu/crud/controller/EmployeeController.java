package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工CRUD请求
 * @author lvzhou
 * @date 2021/7/17 - 13:29
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 单个批量二合一
     * 批量删除：1-2-3
     * 单个删除：1
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {    //批量删除
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            //组装id的集合
            for (String str_id : str_ids) {
                del_ids.add(Integer.parseInt(str_id));
            }
            employeeService.deleteBatch(del_ids);
        } else {    //单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    /**
     * 单个删除
     * @param id
     * @return
     */
//    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("id") Integer id) {
        employeeService.deleteEmp(id);
        return Msg.success();
    }

    /**
     * 如果直接发送ajax=PUT形式的请求
     * 封装的数据
     * Employee[empId=1014, empName=null, gender=null, email=null, dId=null]
     * 问题：
     * 在浏览器中可以看到请求体中有数据，但是Employee却对象封装不上；但是可以封装上empid，而再delete请求中，只需要id值即可，所以ajax直接发送delete请求无影响
     * 导致sql语句为：update tbl_emp where emp_id = 1014; 这是一个错误的sql语句！
     * 原因：
     * Tomcat中进行的操作：
     *    1、将请求体中的数据，封装一个map。
     *    2、request.getParameter("empName")就会从这个map中取值。
     *    3、SpringMVC封装POJO对象的时候。
     *          会把POJO中每个属性的值，底层是 request.getParamter("empName") 获取;
     * AJAX发送PUT请求引发的血案：
     * 		PUT请求，请求体中的数据，request.getParameter("empName")拿不到
     * 		Tomcat一看是PUT请求不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
     *
     * 源码：org.apache.catalina.connector.Request--parseParameters() (3111);
     *     protected String parseBodyMethods = "POST";  //只有'POST'请求才进行解析，否则不解析直接返回，而我们的请求为'PUT'，所以没法进行后续的解析操作
     *     if( !getConnector().isParseBodyMethod(getMethod()) ) {
     *         success = true;
     *     return;
     *     }
     *
     * 解决方案；
     * 我们要能支持ajax可以直接发送PUT之类的请求还要封装请求体中的数据
     *    1、在web.xml中配置上HttpPutFormContentFilter过滤器；
     *    2、他的作用；可以把"PUT"或"PATCH"请求中 请求体中的数据解析包装成一个map。（可以看HttpPutFormContentFilter中的doFilterInternal()方法）
     *    3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中（即2中的map）取数据
     *
     * 员工更新方法
     * @param employee
     * @return
     */
    @RequestMapping(value = "emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee, HttpServletRequest request) { //因为请求中有占位符empId,和employee对象的中用户名属性一致，所以也会进行自动封装
        System.out.println(request.getParameter("gender")); //若没有配置HttpPutFormContentFilter前是获取不到gender属性的值的，配置HttpPutFormContentFilter之后就可以获取到
        System.out.println("将要更新的员工数据为：" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据员工id查询员工信息
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) { //@PathVariable 从路径中获取占位符的值（不写也可以，也会根据id值自动封装）
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkuser(@RequestParam("empName") String empName) { //@RequestParam 获取请求参数中的值
        //先判定用户名是否是合法的表达式（ajax校验）
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg","ajax-用户名可以是2-5位中文或者6-16位英文和数字的组合");
        }

        //数据库用户名重复校验（ajax用户名重复校验-主要是为了实时校验）
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 员工保存
     * 1、支持
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result) { //@Valid 代表封装对象的时候要进行JSR303校验，BindingResult封装校验结果
        if (result.hasErrors()) {
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * @ResponseBody需要正常工作，需要导入jackson包 负责将对象转换为json对象
     * @param pn
     * @param model
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model) {
        //这不是一个分页查询
        //引入PageHelper分页插件
        //在查询之前只需要调用，传入页码以及每页的大下
        PageHelper.startPage(pn,5);
        //startPage紧跟着这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model) {
        //这不是一个分页查询
        //引入PageHelper分页插件
        //在查询之前只需要调用，传入页码以及每页的大下
        PageHelper.startPage(pn,5);
        //startPage紧跟着这个查询就是分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);

        return "list";
    }

}
