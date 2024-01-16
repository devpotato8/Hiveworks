<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="path" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="collapsed" name="style"/>
	<jsp:param value="data-hover='active'" name="hover"/>
</jsp:include>

<style>
	.modal-info{
		margin-left : 15px;	
	}
	.modal-content {
	    height: 500px;
	}
	#msgContentArea {
	    resize : none;
	    height : 150px;
	}
	.autocomplete-dropdown {
		background-color: lightgray;
	    position: absolute; /* 절대 위치 설정 */
	    top: 15%; /* 부모 요소의 맨 아래에 위치 */
	    left: 20%; /* 부모 요소의 왼쪽 경계에 위치 */
	    z-index: 9999; /* 다른 요소 위에 위치 */
	}
	.autocomplete-dropdown li:hover {
    	background-color: #f2f2f2;
    	cursor: pointer;
    	width:auto;
    	max-width:300px;
	}
	.autocomplete-dropdown-item.selected {
	    background-color: #f2f2f2;
	}
	#msgCategory{
		width:400px;
	}
</style>

<%@ include file="/WEB-INF/views/common/sideBar.jsp"%>

<!-- 쪽지 상세내용 보기 modal -->
<div id="modal_msgView" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal_label_id" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Modal title</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			  				  	
			</div>
			<div class="modal-info mt-3">
				<p><span>보낸사람 : </span><span class="sender"></span></p>
				<p><span>전송시간 : </span><span class="msgtime"></span></p>
				<p><span>첨부파일 : </span><span class="msg_file"></span></p>
				
			</div>
			<div class="modal-body" style="font-weight:bold;">
			
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-soft-primary" id="sendReply" data-bs-toggle="modal" data-bs-target="#sendMsgModal">답장 보내기</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<!-- 쪽지 보내기 modal -->
<div class="modal fade" id="sendMsgModal" tabindex="-1" aria-labelledby="sendMsgModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
    	<div class="modal-content">
      		<div class="modal-header">
      				<select id="msgCategory" class="form-select" aria-label="msgCategory">
					  <option selected>쪽지 카테고리 선택</option>
					  <option value="MCT001">업무연락</option>
					  <option value="MCT002">전체공지</option>
					  <option value="MCT003">일반</option>
					  <option value="MCT004">긴급/중요</option>
					</select>
        			<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>        	
      		</div>
		    <div class="modal-body">
        		<div style="display: flex; align-items: center;" class="mb-3">
        			<p>받는 사람 :</p>&nbsp&nbsp
        			<input id="searchEmp"type="text" class="form-control" name="sendMsgSender" style="width:300px" placeholder="직원명을 검색하세요">
        		</div>

        		<div style="display: flex; align-items: center;" class="mb-3">
        			<p>쪽지 제목 :</p>&nbsp&nbsp
        			<input type="text" class="form-control" name="sendMsgTitle" style="width:300px"> 
        		</div>
        		
				<div class="input-group">
					<span class="input-group-text">쪽지내용</span>
					<textarea id="msgContentArea" class="form-control" aria-label="With textarea"></textarea>
				</div>
				<div id="byteCount" class="text-end mb-3">0 / 1500 byte</div>
				
				<div class="input-group">
					<input type="file" class="form-control" id="msgFileAttach" name="sendmsgFile" aria-label="Upload">
				</div>
		    </div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="sendMsgBtn">전송</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>





<!-- Main Content -->
<div class="hk-pg-wrapper pb-0">
	<!-- Page Body -->
	<div class="hk-pg-body py-0">
		<div class="fmapp-wrap">
		<!--MSG Sidebar -->
			<nav class="fmapp-sidebar">
				<div data-simplebar class="nicescroll-bar">
					<div class="menu-content-wrap">
						<div class="btn btn-primary btn-rounded btn-block btn-file mb-4">
							<input type="button" class="sendMsgBtn" data-bs-toggle="modal" data-bs-target="#sendMsgModal">
							쪽지보내기
						</div>
						<div class="menu-group">
							<ul class="nav nav-light navbar-nav flex-column">
								<li class="nav-item active">
									<a class="nav-link" href="${path}/messageview">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="hard-drive"></i></span></span>
										<span class="nav-link-text">받은 쪽지함</span>
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" href="javascript:void(0);">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="send"></i></span></span>
										<span class="nav-link-text">보낸 쪽지함</span>
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" href="javascript:void(0);">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="star"></i></span></span>
										<span class="nav-link-text">별표 쪽지함</span>
									</a>
								</li>
								<li class="nav-item">
									<a class="nav-link" href="javascript:void(0);">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="trash-2"></i></span></span>
										<span class="nav-link-text">휴지통</span>
									</a>
								</li>
							</ul>
						</div>
						<div class="separator separator-light"></div>
						<div class="menu-group">
							<div class="nav-header">
								<span>쪽지 첨부파일</span>
							</div>
							<br>
							<ul class="nav nav-light navbar-nav flex-column">
								<li class="nav-item">
									<a class="nav-link" href="javascript:void(0);">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="image"></i></span></span>
										<span class="nav-link-text">사진 파일</span>
									</a>
								</li>
								
								<li class="nav-item">
									<a class="nav-link" href="javascript:void(0);">
										<span class="nav-icon-wrap"><span class="feather-icon"><i data-feather="file-text"></i></span></span>
										<span class="nav-link-text">문서 파일</span>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- <div class="fmapp-storage">
					<p class="p-sm">Storage is 85% full. 78.5 GB of 1 TB used. You can buy more space.</p>
					<div class="progress-lb-wrap my-2">
						<label class="progress-label text-uppercase fs-8 fw-medium">78.5 GB of 1 TB</label>
						<div class="progress progress-bar-rounded progress-bar-xs">
							<div class="progress-bar bg-danger w-85" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
						</div>
					</div>
					<a href="#" class="fs-7"><u>Buy Storage</u></a>
				</div> -->
				<!--Sidebar Fixnav-->
				<!-- <div class="fmapp-fixednav">
					<div class="hk-toolbar">
						<ul class="nav nav-light">
							<li class="nav-item nav-link">
								<a class="btn btn-icon btn-flush-dark btn-rounded flush-soft-hover" data-bs-toggle="tooltip" data-bs-placement="top" title="" data-bs-original-title="Settings" href="#"><span class="icon"><span class="feather-icon"><i data-feather="settings"></i></span></span></a>
							</li>
							<li class="nav-item nav-link">
								<a href="#" class="btn btn-icon btn-rounded btn-flush-dark flush-soft-hover" data-bs-toggle="tooltip" data-bs-placement="top" title="" data-bs-original-title="Archive"><span class="icon"><span class="feather-icon"><i data-feather="archive"></i></span></span></a>
							</li>
							<li class="nav-item nav-link">
								<a href="#" class="btn btn-icon btn-rounded btn-flush-dark flush-soft-hover" data-bs-toggle="tooltip" data-bs-placement="top" title="" data-bs-original-title="Help"><span class="icon"><span class="feather-icon"><i data-feather="book"></i></span></span></a>
							</li>
						</ul>
					</div>
				</div> -->
				<!--/ Sidebar Fixnav-->
			</nav>
			<!--/ MSG Sidebar END-->
			
			<!-- MSG Header Line -->
			<div class="fmapp-content">
				<div class="fmapp-detail-wrap">
					<header class="fm-header">
						
							<h4>${loginEmp.emp_name}님의 쪽지함</h4>
						<div class="fm-options-wrap">	
							<a class="btn btn-icon btn-flush-dark flush-soft-hover dropdown-toggle no-caret active ms-lg-0 d-sm-inline-block d-none" href="#" data-bs-toggle="dropdown"><span class="icon"><span class="feather-icon"><i data-feather="list"></i></span></span></a>
							<div class="dropdown-menu dropdown-menu-end">
								<a class="dropdown-item" href="${path}/messageview"><span class="feather-icon dropdown-icon"><i data-feather="list"></i></span><span>목록으로 보기</span></a>
								<a class="dropdown-item active" href="${path}/msgFileView"><span class="feather-icon dropdown-icon"><i data-feather="grid"></i></span><span>첨부파일만 보기</span></a>
							</div>
							<a class="btn btn-icon btn-flush-dark btn-rounded flush-soft-hover hk-navbar-togglable d-lg-inline-block d-none" href="#" data-bs-toggle="tooltip" data-bs-placement="top" title="" data-bs-original-title="Collapse">
								<span class="icon">
									<span class="feather-icon"><i data-feather="chevron-up"></i></span>
									<span class="feather-icon d-none"><i data-feather="chevron-down"></i></span>
								</span>
							</a>
						</div>
						<div class="hk-sidebar-togglable"></div>
					</header>
			<!--/ MSG Header Line END-->
			
<script>

$(document).ready(function() {
    $(".msgTitle, .msgContent").click(function() {
        var msg_no = $(this).closest('tr').find('.msg_no').text();
        var msg_title = $(this).closest('tr').find('.msgTitle').text();
        var msg_content = $(this).closest('tr').find('.msgContent').text();
        var msg_date = $(this).closest('tr').find('.msg_date').text();
        var msg_sender = $(this).closest('tr').find('.msg_sender').text();
        var msg_receiver = $(this).closest('tr').find('.msg_receiver').text();
        var msg_file = $(this).closest('tr').find('.msgFile').text();
        // 필요한 modal위치에 세팅
        $("#modal_msgView").find(".modal-title").text(msg_title);
        $("#modal_msgView").find(".modal-body").text(msg_content);
        $("#modal_msgView").find(".sender").text(msg_sender);
        $("#modal_msgView").find(".receiver").text(msg_receiver);
        $("#modal_msgView").find(".msgtime").text(msg_date);
        $("#modal_msgView").find(".msg_file").text(msg_file);
        //모달 보여주기
        $("#modal_msgView").modal('show');
        
        //답장 모달에도 값 넣어주기
        $("#sendMsgModal").find("")
        
    });
    
});
$('#msgContentArea').on('input', function() {
    var len = encodeURI($(this).val()).split(/%..|./).length - 1;
    $('#byteCount').text(len + ' / 1500 byte');

    if (len > 500) {
        $(this).val($(this).val().substring(0, $(this).val().length - 1));
    }
});


<!-- 직원 검색창 자동완성 결과 ajax -->
var empNo;
var isLeader;
var empId;
$(document).ready(function(){
    var ajaxRequest = false;
    var currentSelection = -1;
    var maxSelection = 0;  // 초기값을 0으로 설정합니다.
	
    $('#searchEmp').keyup(function(e){
        var searchText = $(this).val();

        // 방향키나 엔터키가 눌린 경우에는 검색을 수행하지 않습니다.
        if (e.which === 38 || e.which === 40 || e.which === 13) {
            return;
        }

        // 입력창 비워주기
        $('.autocomplete-dropdown').remove();
        currentSelection = -1;  // 검색 결과가 바뀔 때마다 선택 항목을 초기화합니다.

        // 입력창이 비어있지 않을 때만 ajax요청
        if(searchText !== '' && !ajaxRequest){
            ajaxRequest=true;
            $.ajax({
                type:'GET',
                url:'/searchEmp',
                data:{ name : searchText },
                dataType:'JSON',
                success: function(response){
                    ajaxRequest=false;
                    var searchResult= $('<ul class="autocomplete-dropdown">');
                    maxSelection = response.length;  // 검색 결과의 개수를 저장합니다.

                    $.each(response, function(index, employee){
                        listItem = $('<li class="autocomplete-dropdown-item">'+ employee.dept_name +' '+ employee.emp_name + ' ' + employee.position_name + '</li>');
                        listItem.data('empName', employee.emp_name); // 직원 이름만 저장
                        listItem.data('deptName', employee.dept_name);  // 직원 부서 저장
                        listItem.data('deptCode', employee.dept_code);  // 직원 부서 코드 저장
                        listItem.data('empNo', employee.emp_no);  // 직원 번호 저장
                        listItem.data('isLeader', employee.dept_leader); //조직장여부 저장
                        listItem.data('empId',employee.emp_id); // 직원 아이디 저장
                        
                        listItem.click(function() {
                            $('#searchEmp').val($(this).data('empName'));  // 클릭 시 직원 이름만 입력창에 반영
                            empNo=$(this).data('empNo');
                            empId=$(this).data('empId');
                            isLeader=$(this).data('isLeader');
                            $(this).remove(); // 선택한 항목 제거
                            if ($('.autocomplete-dropdown').children().length == 0) { // 모든 항목이 제거되었으면 dropdown도 제거
                                $('.autocomplete-dropdown').remove();
                            }
                        });

                        searchResult.append(listItem);
                    });

                    $('#searchEmp').after(searchResult);
                },
                error: function(){
                    ajaxRequest=false;
                    alert("직원 검색 실패. 관리자에게 문의하세요.")
                }
            });
        }
    });

    // 방향키와 엔터키 처리
    $('#searchEmp').keydown(function(e) {
        switch(e.which) {
            case 38: // 위쪽 방향키
                $('.autocomplete-dropdown-item').removeClass('selected');
                if (currentSelection > 0) {
                    currentSelection--;
                }
                $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').addClass('selected');
                break;
            case 40: // 아래쪽 방향키
                $('.autocomplete-dropdown-item').removeClass('selected');
                if (currentSelection < maxSelection - 1) {
                    currentSelection++;
                }
                $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').addClass('selected');
                break;
            case 13: // 엔터키
                if (currentSelection > -1) {
                	var text = $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').data('empName');
                	empNo = $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').data('empNo');
                	isLeader = $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').data('isLeader');
                	empId = $('.autocomplete-dropdown-item:eq(' + currentSelection + ')').data('empId');
                    $('#searchEmp').val(text);
                    $('.autocomplete-dropdown').remove();  // 선택 후에는 목록을 제거합니다.
                }
                currentSelection = -1;
                break;
        }
    });
	//검색결과 외부에 다른 곳을 클릭하면 검색결과창 사라지게
    $(document).click(function(e) {
        if (!$(e.target).closest('#searchEmp, .autocomplete-dropdown').length) {
            $('.autocomplete-dropdown').remove();
        }
    });
});


</script>

			
	