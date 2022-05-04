<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../includes/header.jsp"%>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Register</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Read Page</div>
            <!-- /.panel-heading -->
            <div class="panel-body">

                <div class="form-group">
                    <label>Bno</label> <input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly>
                </div>

                <div class="form-group">
                    <label>Title</label> <input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly>
                </div>

                <div class="form-group">
                    <label>Text area</label>
                    <textarea class="form-control" name="content" rows="3" readonly="readonly"><c:out value="${board.content}"/>
                    </textarea>
                </div>

                <div class="form-group">
                    <label>Writer</label> <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly>
                </div>
                <button data-oper='modify' class="btn btn-default">Modify</button>
                <button data-oper='list' class="btn btn-info">List</button>

                <form id="operForm" action="/board/modify" method="get">
                    <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
                    <input type="hidden" id="pageNum" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                    <input type="hidden" id="amount" name="amount" value='<c:out value="${cri.amount}"/>'>
                </form>

                <script type="text/javascript">
                    $(document).ready(function(){

                        var operForm = $("#operForm");

                        $("button[data-oper='modify']").on('click', function(e){

                            operForm.attr("action", "/board/modify").submit();
                        });

                        $("button[data-oper='list']").on('click', function(e){

                            // 불필요한 bno 값 제거(input 태그 제거로)
                            operForm.find("#bno").remove();
                            operForm.attr("action", "/board/list");
                            operForm.submit();
                        });
                    });
                </script>
            </div>
            <!-- end panel-body -->
        </div>
        <!-- end panel-body -->
    </div>
    <!-- end panel -->
</div>
<!-- /.row -->

<%@ include file="../includes/footer.jsp" %>