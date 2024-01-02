<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<jsp:include page= "/WEB-INF/views/common/header.jsp">
	<jsp:param value="default" name="style"/>
	<jsp:param value="" name="hover"/>
</jsp:include>

<%@ include file="/WEB-INF/views/common/sideBar.jsp"%>

<!-- Main Content -->
<div class="hk-pg-wrapper">
	<div class="container-xxl">
		
	<!-- Page Header -->
	<div class="hk-pg-header pg-header-wth-tab pt-7">
		<div class="d-flex">
			<div class="flex-1">
				<h1 class="pg-title">조직 관리</h1>
				<br>
				<p class="p-lg col-lg-8">조직도로 부서관리를 하거나, 구성원들을 관리할 수 있습니다</p>
			</div>
		</div>
		<ul class="nav nav-line nav-light nav-tabs">
			<li class="nav-item">
				<a class="nav-link active" data-bs-toggle="tab" href="#tab_block_1">
					<span class="nav-link-text">조직도 관리</span>
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" data-bs-toggle="tab" href="#tab_block_2">
					<span class="nav-link-text">구성원 관리</span>
				</a>
			</li>
		</ul>
	</div>
	<!-- /Page Header -->

	<!-- Page Body -->
	<div class="hk-pg-body">
		<div class="tab-content">
			<!-- 조직도관리 -->
			<div class="tab-pane fade show active" id="tab_block_1">
				<div class="row">
					<div class="col-xl-10">
					
						<div class="title-lg fs-5"><span>부서 관리</span></div>
						<p class="mb-4">#</p>
						<input type="text" id="schName" value="" class="mb-4">
	    				<button class="btn btn-primary btn-sm" onclick="deptsearch()">검색</button>

			<!-- 조직도 jstree -->
			<div id="jstree"></div>
		

						<div class="text-end mt-5">
							<button class="btn btn-primary">부서 일괄 등록</button>
						
							<button class="btn btn-primary">변경사항 저장</button>
						</div>
					
					</div>
				</div>	
			</div>
			<!-- /조직도 관리 -->
			
			
			<div class="tab-pane fade" id="tab_block_2">
				<div class="row">
					<div class="col-md-8">
						<div class="title-lg fs-5"><span>Social profile links</span></div>
						<p class="mb-4">Connect your social media accounts for one-click sharing.</p>
						<form>
							<div class="form-group">
								<label class="form-label">Facebook</label>
								<div class="input-group">
									<span class="input-affix-wrapper">
										<span class="input-prefix">
											<span class="avatar avatar-logo avatar-xs">
												<span class="initial-wrap">
													<img src="dist/img/symbol-avatar-17.png" alt="logo">
												</span>
											</span>
										</span>
										<input type="text" class="form-control form-control-lg ps-8" placeholder="Username" value="Hencework">
										<a href="#" class="input-suffix text-muted"><span class="feather-icon"><i data-feather="edit-3"></i></span></a>
									</span>
								</div>
								<small class="form-text text-muted">
									One-click sign in
								</small>
							</div>
							<div class="form-group">
								<label class="form-label">Twitter</label>
								<div class="input-group">
									<span class="input-affix-wrapper">
										<span class="input-prefix">
											<span class="avatar avatar-logo avatar-xs">
												<span class="initial-wrap">
													<img src="dist/img/symbol-avatar-18.png" alt="logo">
												</span>
											</span>
										</span>
										<input type="text" class="form-control form-control-lg ps-8" placeholder="Username">
										<a href="#" class="input-suffix text-muted"><span class="feather-icon"><i data-feather="edit-3"></i></span></a>
									</span>
								</div>
								<small class="form-text text-muted">
									One-click sign in
								</small>
							</div>
							<div class="form-group mb-5">
								<label class="form-label">Linkedin</label>
								<div class="input-group">
									<span class="input-affix-wrapper">
										<span class="input-prefix">
											<span class="avatar avatar-logo avatar-xs">
												<span class="initial-wrap">
													<img src="dist/img/symbol-avatar-19.png" alt="logo">
												</span>
											</span>
										</span>
										<input type="text" class="form-control form-control-lg ps-8" placeholder="Username">
										<a href="#" class="input-suffix text-muted"><span class="feather-icon"><i data-feather="edit-3"></i></span></a>
									</span>
								</div>
								<div class="form-check form-check-sm mt-2">
									<input type="checkbox" class="form-check-input" id="customCheckList4" checked>
									<label class="form-check-label" for="customCheckList4">
										This is a company account
									</label>
								</div>
							</div>
							<div class="form-group">
								<label class="form-label">Connect</label>
								<div class="input-group mb-3">
									<span class="input-affix-wrapper">
										<span class="input-prefix">
											<span class="avatar avatar-logo avatar-xs">
												<span class="initial-wrap">
													<img src="dist/img/symbol-avatar-6.png" alt="logo">
												</span>
											</span>
										</span>
										<input type="text" class="form-control form-control-lg ps-8 pe-15" placeholder="Behance">
										<span class="input-suffix"><button class="btn btn-sm btn-outline-primary">
											connect
										</button></span>
									</span>
								</div>
								<div class="input-group">
									<span class="input-affix-wrapper">
										<span class="input-prefix">
											<span class="avatar avatar-logo avatar-xs">
												<span class="initial-wrap">
													<img src="dist/img/symbol-avatar-5.png" alt="logo">
												</span>
											</span>
										</span>
										<input type="text" class="form-control form-control-lg ps-8 pe-15" placeholder="Dribbble">
										<span class="input-suffix"><button class="btn btn-sm btn-outline-primary">
											connect
										</button></span>
									</span>
								</div>
							</div>
						</form>
						<div class="text-end mt-6">
							<button class="btn btn-primary btn-rounded">
								Save changes
							</button>
						</div>
					</div>
				</div>	
			</div>
			</div>
		</div>
	</div>
	<!-- /Page Body -->		
</div>


	<!-- jQuery -->
    <script src="${path}/resources/vendors/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap Core JS -->
   	<script src="${path}/resources/vendors/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

    <!-- FeatherIcons JS -->
    <script src="${path}/resources/js/feather.min.js"></script>

    <!-- Fancy Dropdown JS -->
    <script src="${path}/resources/js/dropdown-bootstrap-extended.js"></script>

	<!-- Simplebar JS -->
	<script src="${path}/resources/vendors/simplebar/dist/simplebar.min.js"></script>

	<!-- Init JS -->
	<script src="${path}/resources/js/init.js"></script>
	<script src="${path}/resources/js/chips-init.js"></script>
	<script src="${path}/resources/js/dashboard-data.js"></script>
	
	
	<!-- jstree -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.16/jstree.min.js" integrity="sha512-ekwRoEshEqHU64D4luhOv/WNmhml94P8X5LnZd9FNOiOfSKgkY12cDFz3ZC6Ws+7wjMPQ4bPf94d+zZ3cOjlig==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.16/themes/default/style.min.css" integrity="sha512-A5OJVuNqxRragmJeYTW19bnw9M2WyxoshScX/rGTgZYj5hRXuqwZ+1AVn2d6wYTZPzPXxDeAGlae0XwTQdXjQA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" />

<script>
       
function deptsearch() {
    $('#jstree').jstree(true).search($("#schName").val());
}

$.jstree.defaults.core.themes.variant = "large";


function getJson(){
	$.ajax({
		type:'get',
		url:'/deptlist',
		dataType:'JSON',
		success: function(data){
			var deptlist = new Array();
			$.each(data, function(idx, item){
				deptlist[idx]={id:item.deptCode, parent:item.deptUpstair, text:item.deptName};
			});
			
			$('#jstree').jstree({
				'core':{
					'data':deptlist
				},
				'plugins':['types','search','contextmenu','dnd'],
				'types':{
					'default':{
						'icon':'fa-solid fa-book-open-reader'
					}
				},
				'check_callback': true		
			})
			
		},
		error:function(data){
			alert("에러");
		}
	});
}

$(document).ready(function(){
	getJson();
});

</script>
	