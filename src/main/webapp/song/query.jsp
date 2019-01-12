<%--
  Created by IntelliJ IDEA.
  User: sunny
  Date: 2019/1/11
  Time: 21:55
  To change this template use File | Settings | File Templates.
--%>
<%@page pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>音乐查询</title>
    <jsp:include page="/resources/layout/_css.jsp"/>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="${ctx}/resources/css/bootstrap-table/bootstrap-table.min.css"/>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                音乐查询
            </div>
            <div class="ibox-content">
                <table id="table">

                </table>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="/resources/layout/_script.jsp"/>
<script src="${ctx}/resources/js/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${ctx}/resources/js/bootstrap-table/locale/bootstrap-table-zh-CN.js"></script>
<script>
    //初始化表格,动态从服务器加载数据
    $('#table').bootstrapTable({
        //获取数据的Servlet地址
        url:'${ctx}/SongServlet?state=listAll',
        columns: [{
            checkbox:true
        }, {
            title: '序号',
            formatter:function(value,row,index){
                //return index+1; //序号正序排序从1开始
                var pageSize = $('#table').bootstrapTable('getOptions').pageSize;//通过表的#id 可以得到每页多少条
                var pageNumber = $('#table').bootstrapTable('getOptions').pageNumber;//通过表的#id 可以得到当前第几页
                return pageSize * (pageNumber - 1) + index + 1;    //返回每条的序号： 每页条数 * （当前页 - 1 ）+ 序号
            }
        }, {
            field: 'song_id',
            title: 'id'
        }, {
            field: 'song_name',
            title: '歌曲名字'
        }, {
            field: 'song_singer',
            title: '歌手'
        }, {
            field: 'type_name',
            title: '歌曲类型'
        },{
            field: 'song_size',
            title: '文件大小'
        },{
            field: 'song_url',
            title: '文件地址'
        },{
            field: 'song_format',
            title: '歌曲格式'
        },{
            field: 'song_clicks',
            title: '点击次数'
        },{
            field: 'song_download',
            title: '下载次数'
        },{
            field: 'song_uptime',
            title: '上传时间'
        },{
            field: 'vip',
            title: 'vip等级'
        },{
            field: 'caozuo',
            title: '操作',
            formatter:function(v1,v2,v3){
                return ['<a class="fa fa-play" href="javascript:void(0)" title="listen">',
                    '<i class="page-list"></i>',
                    '</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
                    '<a class="fa fa-download" href="javascript:void(0)" title="download">',
                    '<i class="dropdown-menu"></i>',
                    '</a>'].join('');
            },
            events:'caocuoEvents'
        }],
        pagination:true,//启动分页
        pageSize:5,//每页显示的记录数
        pageList:[5,10,15,20,25,30],//记录数可选列表
        search:true,//是否启用查询
        showRefresh:true,//显示刷新按钮
        showColumns:true,//显示下拉框勾选要显示的列
        clickToSelect:true,
        sidePagination:'server',//表示服务端请求
        queryParamsType:'',

        onLoadSuccess: function(){  //加载成功时执行
            layer.msg("加载成功");
        },
        onLoadError: function(){  //加载失败时执行
            layer.msg("加载数据失败", {time : 1500, icon : 2});
        }
    });
    window.caocuoEvents = {
        'click .update': function (e, value, row) {
            layer.open({
                type: 2,
                area: ['800px', '500px'],
                content: '${ctx}/SongServlet?state=selectById&songId=' + row['song_id'] //这里content是一个URL，如果你不想让iframe出现滚动条，你还可以content: ['http://sentsin.com', 'no']
            });
        },
        'click .remove': function (e, value, row) {
            if(confirm('是否删除')){
                $.post('${ctx}/SongServlet?state=deleteById&songId=' + row['song_id'],function(r){
                    $('#table').bootstrapTable('refresh');
                });
            }
        }
    };
</script>
</html>