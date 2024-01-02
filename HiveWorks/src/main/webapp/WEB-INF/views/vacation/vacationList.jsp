<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="path" value="${pageContext.request.contextPath}"/>

<%-- <jsp:include page= "/WEB-INF/views/common/header.jsp"/> --%>
<jsp:include page= "/WEB-INF/views/common/header.jsp">
	<jsp:param value="collapsed" name="style"/>
	<jsp:param value="data-hover='active'" name="hover"/>	
</jsp:include>
<%@ include file="/WEB-INF/views/common/sideBar.jsp"%>
	<div class="hk-pg-wrapper">
		<div class="container-xxl">
			<!-- Page Header -->
			<div class="hk-pg-header pg-header-wth-tab pt-7">
				<div class="d-flex">
					<div class="d-flex flex-wrap justify-content-between flex-1">
						<div class="mb-lg-0 mb-2 me-8">
							<h1 class="pg-title">휴가페이지</h1>
						</div>
					</div>
				</div>
			</div>
				<!-- /Page Header -->
		<section>
	        <div class="container">
	            <div class="top-bar">
	                <div class="first-line">
	                    <div>근무관리</div>
	                    <div>휴가관리</div>
	                </div>
	                <div class="second-line">
	                    <div>
	                        <div>근무현황</div>
	                        <div>세부근무현황</div>
	                    </div>
	                    <div>
	                        
	                    </div>
	                </div>
	                <div class="thrid-line">
	                    <div class="day-filter"></div>
	                    <div class="filter-right-part"><div>2023.12.26(화) 오전 08:00</div><button>연차</button></div>
	                </div>
	            </div>
	            <div class="main-container">
	                <p>휴가신청</p>
	                <div class="first-container common-container">
	                    <div></div>
	                    <div></div>
	                    <div></div>
	                    <div></div>
	                </div>
	                <p></p>
	                <div class="second-container common-container">
	                    <div></div>
	                    <div></div>
	                    <div></div>
	                    <div></div>
	                </div>
	            </div>
	        </div>
        
          <!-- 모달 -->
          <div class="modal fade" id="modal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="exampleModalLabel">휴가신청</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- 캘린더 -->
                    <div class="sec_cal">
                        <div class="cal_nav">
                          <a href="javascript:;" class="nav-btn go-prev">prev</a>
                          <div class="year-month"></div>
                          <a href="javascript:;" class="nav-btn go-next">next</a>
                        </div>
                        <div class="cal_wrap">
                          <div class="days">
                            <div class="day">MON</div>
                            <div class="day">TUE</div>
                            <div class="day">WED</div>
                            <div class="day">THU</div>
                            <div class="day">FRI</div>
                            <div class="day">SAT</div>
                            <div class="day">SUN</div>
                          </div>
                          <div class="dates"></div>
                        </div>
                      </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                  <button type="button" class="btn btn-primary">저장</button>
                </div>
              </div>
            </div>
          </div>

    </section>
				
			    
	    </div>
    </div>
<script>        
        // div 클릭 시 모달 열기
        const openModal = () =>
            $("#modal").modal("show");

        const elements = document.querySelectorAll(".common-container>div");
        elements.forEach(function(element) {
            element.addEventListener("click", openModal);
        });
        
        $(document).ready(function() {
            calendarInit();
        });
        /*
            달력 렌더링 할 때 필요한 정보 목록 
        
            현재 월(초기값 : 현재 시간)
            금월 마지막일 날짜와 요일
            전월 마지막일 날짜와 요일
        */
        
        function calendarInit() {
        
            // 날짜 정보 가져오기
            var date = new Date(); // 현재 날짜(로컬 기준) 가져오기
            var utc = date.getTime() + (date.getTimezoneOffset() * 60 * 1000); // uct 표준시 도출
            var kstGap = 9 * 60 * 60 * 1000; // 한국 kst 기준시간 더하기
            var today = new Date(utc + kstGap); // 한국 시간으로 date 객체 만들기(오늘)
          
            var thisMonth = new Date(today.getFullYear(), today.getMonth(), today.getDate());
            // 달력에서 표기하는 날짜 객체
          
            
            var currentYear = thisMonth.getFullYear(); // 달력에서 표기하는 연
            var currentMonth = thisMonth.getMonth(); // 달력에서 표기하는 월
            var currentDate = thisMonth.getDate(); // 달력에서 표기하는 일
        
            // kst 기준 현재시간
            // console.log(thisMonth);
        
            // 캘린더 렌더링
            renderCalender(thisMonth);
        
            function renderCalender(thisMonth) {
        
                // 렌더링을 위한 데이터 정리
                currentYear = thisMonth.getFullYear();
                currentMonth = thisMonth.getMonth();
                currentDate = thisMonth.getDate();
        
                // 이전 달의 마지막 날 날짜와 요일 구하기
                var startDay = new Date(currentYear, currentMonth, 0);
                var prevDate = startDay.getDate();
                var prevDay = startDay.getDay();
        
                // 이번 달의 마지막날 날짜와 요일 구하기
                var endDay = new Date(currentYear, currentMonth + 1, 0);
                var nextDate = endDay.getDate();
                var nextDay = endDay.getDay();

                // console.log(prevDate, prevDay, nextDate, nextDay);
        
                // 현재 월 표기
                $('.year-month').text(currentYear + '.' + (currentMonth + 1));
        
                // 렌더링 html 요소 생성
                calendar = document.querySelector('.dates')
                calendar.innerHTML = '';
                
                // 지난달
                for (var i = prevDate - prevDay + 1; i <= prevDate; i++) {
                    calendar.innerHTML = calendar.innerHTML + '<div class="day prev disable">' + i + '</div>'
                }
                // 이번달
                for (var i = 1; i <= nextDate; i++) {
                    calendar.innerHTML = calendar.innerHTML + '<div class="day current">' + i + '</div>'
                }
                // 다음달
                for (var i = 1; i <= (7 - nextDay == 7 ? 0 : 7 - nextDay); i++) {
                    calendar.innerHTML = calendar.innerHTML + '<div class="day next disable">' + i + '</div>'
                }
        
                // 오늘 날짜 표기
                if (today.getMonth() == currentMonth) {
                    todayDate = today.getDate();
                    var currentMonthDate = document.querySelectorAll('.dates .current');
                    currentMonthDate[todayDate -1].classList.add('today');
                }
            }
        
            // 이전달로 이동
            $('.go-prev').on('click', function() {
                thisMonth = new Date(currentYear, currentMonth - 1, 1);
                renderCalender(thisMonth);
            });
        
            // 다음달로 이동
            $('.go-next').on('click', function() {
                thisMonth = new Date(currentYear, currentMonth + 1, 1);
                renderCalender(thisMonth); 
            });
        }
    </script>
    <style>
        .container{
            width: 100%;
            height: 100%;
            width: 90%;
            margin: auto;
        }
        
        .top-bar>div{
            display: flex;
            margin-bottom: 10px;
        }
        .first-line{
            font-size: 28px;
        }
        .first-line>div{
            margin-right: 20px;
        }
        .second-line{
            font-size: 18px;
            display: flex;
            justify-content: space-between;
        }
        .second-line>div{
            display: flex;
        }
        .second-line>div>div{
            margin-right: 10px;
        }
        .thrid-line{
            display: flex;
            justify-content: space-between;
        }
        .thrid-line>div{
            display: flex;
        }
        .day-filter>button{
            margin-right: 5px;
        }
        .filter-right-part>button{
            margin: 0 10px;
        }
        .main-container{
            display: flex;
            flex-direction: column;
        }
        .common-container{
            height: 200px;
            display: flex;
            justify-content: space-between;
        }
        .common-container>div{
            box-shadow: rgba(3, 22, 187, 0.16) 0px 1px 4px;
            border-radius: 5px;
            height: 100%;
            width: 23%;
            cursor: pointer;
        }
        .common-container>div:hover{
            scale: 1.02;
            transition: all 0.5s;
        }
        .main-container>p{
            font-size: 28px;
        }
        /* section calendar */

	.sec_cal {
	    width: 360px;
	    margin: 0 auto;
	    font-family: "NotoSansR";
	}
	
	.sec_cal .cal_nav {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    font-weight: 700;
	    font-size: 48px;
	    line-height: 78px;
	}
	
	.sec_cal .cal_nav .year-month {
	    width: 300px;
	    text-align: center;
	    line-height: 1;
	}
	
	.sec_cal .cal_nav .nav {
	    display: flex;
	    border: 1px solid #333333;
	    border-radius: 5px;
	}
	
	.sec_cal .cal_nav .go-prev,
	.sec_cal .cal_nav .go-next {
	    display: block;
	    width: 50px;
	    height: 78px;
	    font-size: 0;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	}
	
	.sec_cal .cal_nav .go-prev::before,
	.sec_cal .cal_nav .go-next::before {
	    content: "";
	    display: block;
	    width: 20px;
	    height: 20px;
	    border: 3px solid #000;
	    border-width: 3px 3px 0 0;
	    transition: border 0.1s;
	}
	
	.sec_cal .cal_nav .go-prev:hover::before,
	.sec_cal .cal_nav .go-next:hover::before {
	    border-color: #ed2a61;
	}
	
	.sec_cal .cal_nav .go-prev::before {
	    transform: rotate(-135deg);
	}
	
	.sec_cal .cal_nav .go-next::before {
	    transform: rotate(45deg);
	}
	
	.sec_cal .cal_wrap {
	    padding-top: 40px;
	    position: relative;
	    margin: 0 auto;
	}
	
	.sec_cal .cal_wrap .days {
	    display: flex;
	    margin-bottom: 20px;
	    padding-bottom: 20px;
	    border-bottom: 1px solid #ddd;
	}
	
	.sec_cal .cal_wrap::after {
	    top: 368px;
	}
	
	.sec_cal .cal_wrap .day {
	    display:flex;
	    align-items: center;
	    justify-content: center;
	    width: calc(100% / 7);
	    text-align: left;
	    color: #999;
	    font-size: 12px;
	    text-align: center;
	    border-radius:5px
	}
	
	.current.today {background: rgb(242 242 242);}
	
	.sec_cal .cal_wrap .dates {
	    display: flex;
	    flex-flow: wrap;
	    height: 290px;
	}
	
	.sec_cal .cal_wrap .day:nth-child(7n -1) {
	    color: #3c6ffa;
	}
	
	.sec_cal .cal_wrap .day:nth-child(7n) {
	    color: #ed2a61;
	}
	
	.sec_cal .cal_wrap .day.disable {
	    color: #ddd;
	}
</style>
<%@ include file="/WEB-INF/views/common/footer.jsp"%>