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
                    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                </form>
                
                <!-- Modal -->
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label>Reply</label>
                                    <input class="form-control" name="reply" value="New Reply!!">
                                </div>
                                <div class="form-group">
                                    <label>Replyer</label>
                                    <input class="form-control" name="replyer" value="replyer">
                                </div>
                                <div class="form-group">
                                    <label>Reply Date</label>
                                    <input class="form-control" name="replyDate" value="">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                                <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                                <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <!-- /.modal -->
                
                <script type="text/javascript" src="/resources/js/reply.js"></script>

                <script type="text/javascript">

                    // 댓글 목록 이벤트 처리

                    $(document).ready(function(){

                        var bnoValue = '<c:out value="${board.bno}"/>';
                        console.log(bnoValue);
                        var replyUL = $(".chat");

                        showList(1);

                        function showList(page){
                            console.log("showList실행");
                            replyService.getList({bno:bnoValue, page:page||1}, function(list) {
                                console.log("getList 실행?");
                                var str = "";
                                console.log(list);
                                if(list == null || list.length==0) {
                                    replyUL.html("");
                                    console.log("list가 널입니까");
                                    return;
                                }
                                console.log("ㄴ 여기오자나");
                                for(var i=0, len = list.length || 0; i<len; i++) {
                                    console.log("반복문왜안도냐?");
                                    str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
                                    str += "<div><div class='header'><strong class='primary-font'>"
                                        + list[i].replyer + "</strong>";
                                    str += "<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate)
                                        + "</small></div>";
                                    str += "<p>" + list[i].reply + "</p></div></li>";    
                                }
                                console.log(str);
                                replyUL.html(str);
                            }); // end function
                        }; // end showList

                        var modal = $('.modal');
                        var modalInputReply = modal.find("input[name='reply']");
                        var modalInputReplyer = modal.find("input[name='replyer']");
                        var modalInputReplyDate = modal.find("input[name='replyDate']");

                        var modalModBtn = $("#modalModBtn");
                        var modalRemoveBtn = $("#modalRemoveBtn");
                        var modalRegisterBtn = $("#modalRegisterBtn");

                        $("#addReplyBtn").on("click", function(e){

                            modal.find("input").val("");
                            modalInputReplyDate.closest("div").hide();
                            modal.find("button[id !='modalCloseBtn']").hide();

                            modalRegisterBtn.show();

                            $(".modal").modal("show");
                        });

                        modalRegisterBtn.on("click", function(e){

                            var reply = {
                                reply : modalInputReply.val(),
                                replyer : modalInputReplyer.val(),
                                bno : bnoValue
                            };
                            replyService.add(reply, function(result) {
                                
                                alert(result);

                                modal.find("input").val("");
                                modal.modal("hide");

                                showList(1);
                            });
                        });
                        // 동적 생성 요소 이벤트 위임(delegation)
                        $(".chat").on("click", "li", function(e){

                            var rno = $(this).data("rno");

                            replyService.get(rno, function(reply){
                                modalInputReply.val(reply.reply);
                                modalInputReplyer.val(reply.replyer);
                                modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
                                modal.data("rno", reply.rno);   //data-rno 저장

                                modal.find("button[id != 'modalCloseBtn']").hide();
                                modalModBtn.show();
                                modalRemoveBtn.show();

                                $(".modal").modal("show");
                            })
                        })

                        modalModBtn.on("click", function(e){

                            var reply = {rno:modal.data("rno"), reply:modalInputReply.val()};

                            replyService.update(reply, function(result){

                                alert(result);
                                modal.modal("hide");
                                showList(1);
                            });
                        });

                        modalRemoveBtn.on("click", function(e){

                            var rno = modal.data("rno");

                            replyService.remove(rno, function(result){

                                alert(result);
                                modal.modal("hide");
                                showList(1);
                            })
                        })




                    });

                    console.log("=========");
                    console.log("JS TEST");

                    // var bnoValue = '<c:out value="${board.bno}"/>';
                    
                    // for replyService add test
                    // replyService.add(
                    //     {reply:"JS Test", replyer:"tester", bno:bnoValue}
                    //     ,
                    //     function(result){
                    //         alert("RESULT : " + result);
                    //     }
                    // );

                    // reply List Test
                    /*
                    replyService.getList({bno:bnoValue, page:1}, function(list){

                        for(var i=0, len = list.length||0; i < len; i++){
                            console.log(len);
                            console.log(list[i]);
                        }
                    });
                    */

                    // reply remove Test
                    // replyService.remove(12, function(count) {

                    //     console.log(count);

                    //     if(count === "success") {
                    //         alert("REMOVED");
                    //     }
                    // }, function(err) {
                    //     alert('ERROR...');
                    // });

                    // reply modify
                    // replyService.update({
                    //     rno : 13,
                    //     bno : bnoValue,
                    //     reply : "Modified Reply.....",
                    // }, function(result) {
                    //     alert("수정 완료...");
                    // })

                    // 특정 번호 댓글 get
                    // replyService.get(10, function(data){
                    //     console.log(data);
                    // });
                        
                    $(document).ready(function(){
                        console.log(replyService);
                    });

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

<div class="row">
    <div class="col-lg-12">
        <!-- /.panel -->
        <div class="panel panel-default">
            <!-- <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
            </div> -->

            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i>Reply
                <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
            </div>

            <!-- /.panel-heading -->
            <div class="panel-body">

                <ul class="chat">
                    <!-- start reply -->
                    <li class="left clearfix" data-rno="12">
                        <div>
                            <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2018-01-01 13:13</small>
                            </div>
                            <p>Good job!</p>
                        </div>
                    </li>
                    <!-- end reply -->
                </ul>
                <!-- /. end ul -->
            </div>
            <!-- /.panel .chat-panel -->
        </div>
    </div>
    <!-- ./ end row -->
</div>

<%@ include file="../includes/footer.jsp" %>