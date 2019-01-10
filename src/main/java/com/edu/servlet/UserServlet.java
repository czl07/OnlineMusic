package com.edu.servlet;

import com.edu.bean.UserBean;
import com.edu.bean.UserDisplayBean;
import com.edu.service.UserService;
import com.edu.service.impl.UserServiceImpl;
import com.edu.util.ExcelUtil;
import com.github.pagehelper.PageHelper;
import com.google.gson.Gson;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * @Author: 王仁洪
 * @Date: 2019/1/10 10:02
 */
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserServiceImpl();
    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    public void service(ServletRequest request, ServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        String state = request.getParameter("state");

        System.out.println(state);

        if ("listAll".equals(state)){
            this.listAll(request,response);
        }else if ("addToExcel".equals(state)){
            this.addToExcel(request,response);
        }else if ("addFromExcel".equals(state)){
            this.addFromExcel(request,response);
        }else if ("upload".equals(state)){
            this.upload(request,response);
        }
    }

    private void upload(ServletRequest request, ServletResponse response) {

    }

    private void addFromExcel(ServletRequest request, ServletResponse response) {
        //得到上传路径的硬盘路径
        String dir = request.getServletContext().getRealPath("/");
        String userPath = request.getParameter("userPath");

        String path = dir + userPath;

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //读取文件
        InputStream inputStream = null;
        try {
            inputStream = new FileInputStream(path);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        //sheet文件名
        String sheetName = "Sheet1";
        //将excel中的数据读取到String数组中
        String[][] values = new String[0][];

        try {
            values = ExcelUtil.getValuesFromExcel(inputStream,sheetName);
        } catch (Exception e) {
            e.printStackTrace();
        }

        //将String数组中的数据封装到实体类
        boolean insert = false;
        for(int i=1;i<values.length;i++) {
            UserBean userBean = new UserBean();

            userBean.setUser_name(values[i][0]);
            userBean.setUser_password(values[i][1]);
            if(null!=values[i][2]) {
                userBean.setVip_id(Integer.parseInt(values[i][2]));
            }
            if (null!=values[i][3]){
                try {
                    userBean.setUser_birthday(dateFormat.parse(values[i][3] + " 00:00:00"));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            userBean.setUser_gender(values[i][4]);

            if (null!=values[i][5]){
                userBean.setType_id(Integer.parseInt(values[i][5]));
            }

            userService.insert(userBean);
        }


        try {
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void addToExcel(ServletRequest request, ServletResponse response) throws IOException {
        //获取数据
        List<UserDisplayBean> list = userService.selectAll();

        //excel标题
        String[] title = {"用户id","用户名","用户密码","vip等级","生日","性别","喜欢的歌曲类型"};

        //sheet文件名
        String sheetName = "用户";

        //将数据库中数据存到String数组中
        String[][] values = new String[list.size()][7];
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        for(int i=0;i<list.size();i++) {
            values[i][0] = list.get(i).getUser_id().toString();
            values[i][1] = list.get(i).getUser_name();
            values[i][2] = list.get(i).getUser_password();
            values[i][3] = list.get(i).getVip();
            values[i][4] = simpleDateFormat.format(list.get(i).getUser_birthday());
            values[i][5] = list.get(i).getUser_gender();
            values[i][6] = list.get(i).getType_name();
        }
        FileOutputStream fileOutputStream = new FileOutputStream("D:/用户.xls");
        HSSFWorkbook workbook = ExcelUtil.getHSSFWorkbook(sheetName, title, values);
        workbook.write(fileOutputStream);
        fileOutputStream.close();
    }

    private void listAll(ServletRequest request, ServletResponse response) {
        response.setCharacterEncoding("utf-8");
        PrintWriter printWriter = null;
        try {
            printWriter = response.getWriter();
        } catch (IOException e) {
            e.printStackTrace();
        }
        int pageSize = Integer.parseInt(request.getParameter("pageSize"));
        int pageNumber = Integer.parseInt(request.getParameter("pageNumber"));

        PageHelper.startPage(pageNumber, pageSize);
        List<UserDisplayBean> users = userService.selectAll();

        //这里用了Gson来实现将List这个对象的集合转换成字符串
        Gson gson = new Gson();
        //将记录转换成json字符串
        String songJson = gson.toJson(users);
        String json = "{\"total\":" + users.size() + ",\"rows\":" + songJson + "}";

        printWriter.write(json);
    }
}