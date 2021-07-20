package com.atguigu.crud.test;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.DepartmentExample;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * @author lvzhou
 * @date 2021/7/17 - 10:55
 * 推荐Spring的项目就可以使用Spring的单元测试，就可以自动给注入我们需要的组件
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 * 3、直接autowired要使用的组件即可
 */

@RunWith(SpringJUnit4ClassRunner.class) //指定使用Spring的单元测试块
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD() {
        //1、创建SpringIOC容器
//        ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        //2、从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);

        //1、插入几个部门
//        departmentMapper.insertSelective(new Department(null, "开发部门"));
//        departmentMapper.insertSelective(new Department(null, "测试部门"));

        //2、生成员工数据，测试员工插入
//        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@atguigu.com", 1));

        //3、批量插入多个员工；批量，使用可以执行批量操作的sqlSession。
//        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class); //能进行批量操作的sqlSession
//        for (int i = 0; i < 1000; i++) {
//            String uid = UUID.randomUUID().toString().substring(0,5) + "" + i;
//            mapper.insertSelective(new Employee(null,uid,"M",uid+"@atguigu.com",1));
//        }
    }
}
