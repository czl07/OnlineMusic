<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: sunny
  Date: 2019/1/8
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>歌曲信息修改</title>
    <jsp:include page="/resources/layout/_css.jsp"/>
    <link rel="stylesheet" href="${ctx}/resources/css/datapicker/bootstrap-datepicker.css">
</head>
<body style="padding-top: 40px">
<div class="wrapper wrapper-content">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <form  class="form-horizontal" method="post">
                        <c:forEach var="selectById" items="${selectById }">
                            <input type="hidden" name="song_id" value="<c:out value="${selectById.song_id }" />" />

                            <div class="form-group">
                                <label class="col-sm-2 control-label">歌曲名字</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_name" value="<c:out value="${selectById.song_name}"/>"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">歌手</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_singer" value="<c:out value="${selectById.song_singer}"/>">
                                </div>
                            </div>

                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <input type="hidden" class="form-control"  name="typeIdOld" value="<c:out value="${userBean.type_id}"/>">
                                <label class="col-sm-2 control-label">歌曲类型</label>
                                <div class="col-sm-10">
                                    <c:forEach var="songtypeBean" items="${songtypeBeanList }">
                                        <label class="radio-inline">
                                            <input type="radio" name="type_id" value="<c:out value="${songtypeBean.type_id }" />"/>
                                            <c:out value="${songtypeBean.type_name }" />
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">文件大小</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_size" value="<c:out value="${selectById.song_size}"/>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">文件地址</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_url" value="<c:out value="${selectById.song_url}"/>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">文件格式</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_format" value="<c:out value="${selectById.song_format}"/>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">点击次数</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_clicks" value="<c:out value="${selectById.song_clicks}"/>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">下载次数</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_download" value="<c:out value="${selectById.song_download}"/>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-2 control-label">上传时间</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control"  name="song_uptime" value="<c:out value="${selectById.song_uptime}"/>">
                                </div>
                            </div>

                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <input type="hidden" class="form-control"  name="vipIdOld" value="<c:out value="${userBean.vip_id}"/>">
                                <label class="col-sm-2 control-label">vip等级</label>
                                <div class="col-sm-10">
                                    <c:forEach var="vipBean" items="${vipBeanList }">
                                        <label class="radio-inline">
                                            <input type="radio" name="vip_id" value="<c:out value="${vipBean.vip_id }" />"/>
                                            <c:out value="${vipBean.vip }" />
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>

                        </c:forEach>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-2">
                                <div class="btn btn-primary" onclick="save()">保存内容</div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="/resources/layout/_script.jsp"/>
<script src="${ctx}/resources/js/datapicker/bootstrap-datepicker.js"></script>
<script src="${ctx}/resources/js/datapicker/bootstrap-datepicker.zh-CN.min.js"></script>
<script>

    //datepicker:
    $('[name=song_uptime]').datepicker({
        format: "yyyy-mm-dd",
        language: "zh-CN",
        orientation: "top left",
        autoclose: true,
        todayHighlight: true
    });

    function save(){
        $.post('${ctx}/SongServlet?state=updateById',$('form').serialize(),function (r) {
            parent.$('#table').bootstrapTable('refresh');
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            parent.layer.close(index); //再执行关闭
            layer.msg(r.message);
        });
    }
</script>
</html>
