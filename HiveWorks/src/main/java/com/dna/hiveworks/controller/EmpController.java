package com.dna.hiveworks.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.catalina.util.URLEncoder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import com.dna.hiveworks.common.ExcelEmployeeListConvert;
import com.dna.hiveworks.common.ExcelRequestManager;
import com.dna.hiveworks.model.dto.Account;
import com.dna.hiveworks.model.dto.Employee;
import com.dna.hiveworks.serviceimpl.EmpServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

/**
 * @author : 김태윤
 * @since : 2023. 12. 28.
 * Description : 직원정보 접근 컨트롤러(rest)
 * 
 * History :
 * - 작성자 : 김태윤, 날짜 : 2023. 12. 28., 설명 : 최초작성
 * 
 */

@Controller
@RequestMapping("/employees")
@RequiredArgsConstructor
public class EmpController {
	
	private final BCryptPasswordEncoder passwordEncoder;
	private final EmpServiceImpl service;
	
	
	@GetMapping("/{empId}")
	public ResponseEntity<Employee> selectEmployeeById(@PathVariable String empId) {
		Employee e = service.selectEmployeeById(empId);
		return ResponseEntity.status(HttpStatus.OK).body(e);
	}
	
	@GetMapping("/employeeList")
	public String selectEmployeesListAll(Model model) {

		
		List<Employee> employees = service.selectEmployeesListAll();
		
		model.addAttribute("employees",employees);
		
		return "employees/employeeList";
	}
	
	
	@GetMapping("/searchEmployees")
	public void searchEmployeesByKeyword(String keyword, HttpServletResponse response) throws IOException {
		
		Map<String,Object> param = new HashMap<>();
		
		param.put("type","emp_no");
		param.put("keyword", keyword);
		
		List<Employee> searchEmployee = service.searchEmployeesByKeyword(param);
		
		String csv="";
		for(int i=0;i<searchEmployee.size();i++) {
			if(i!=0) csv+=",";
			csv+=searchEmployee.get(i).getEmp_no();
		}
		
		response.setContentType("text/csv;charset=utf-8");
		response.getWriter().print(csv);
		
		
	}
	
	@PostMapping("/searchEmployees")
	public @ResponseBody List<Employee> searchEmployeesByKeywordSeach(String keyword){
		
		Map<String,Object> param = new HashMap<>();
		
		param.put("type", "emp_no");
		param.put("keyword", keyword);
		
		List<Employee> searchEmployee = service.searchEmployeesByKeyword(param);
		
		return searchEmployee;
	}
	
	@GetMapping("/enrollEmployee")
	public String enrollEmployee(Model model) {
		
				
		Map<String,List<Map<String,Object>>> data = service.selectDataListForEmployee();
		model.addAttribute("data",data);

		return "employees/enrollEmployee";
	}
	
	@PostMapping("/enrollEmployeeEnd.do")
	public String enrollEmployeeEnd(Model model, Employee emp,
			Account ac,@RequestPart(value="upFile", required = false) MultipartFile upFile, HttpSession session, String email_id,@RequestParam(name="email_form" , required=true) String email_form,
			@RequestParam("creater_pre") String creater) {
		
		String path = session.getServletContext().getRealPath("/resources/upload/profile");
		
		File folder =  new File(path);
		
		if(!folder.exists()) {
			try {
				folder.mkdir();
			}catch(Exception e) {
				e.printStackTrace();
			}

		}

		if(upFile!=null && !upFile.isEmpty()) {
			String oriName = upFile.getOriginalFilename();
			String ext = oriName.substring(oriName.lastIndexOf("."));
			Date today = new Date(System.currentTimeMillis());
			int randomNum = (int)(Math.random()*10000)+1;
			String reName = "HIVEWORKS_"+(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(today))+"_"+randomNum+ext;
			
			try {
				upFile.transferTo(new File(path,reName));
					emp.setEmp_profile_ori_name(oriName);
					emp.setEmp_profile_re_name(reName);
			}catch(IOException e){
				e.printStackTrace();
			}
			
		}

		String empEmail = email_id+"@"+email_form;
		emp.setEmp_email(empEmail);
		
		String encodePassword = passwordEncoder.encode(emp.getEmp_pw());
		
		emp.setEmp_pw(encodePassword);
		
		
		String msg, loc;
		Map<String,Object> empData = new HashMap<>();
		
		empData.put("employee", emp);
		empData.put("account", ac);
		
		
		try {
			int result = service.insertEmployee(empData);
			
			msg="직원 등록 성공";
			loc="employees/employeeList";

		}catch(RuntimeException e) {
			msg="직원 등록 실패";
			loc="employees/enrollEmployee";
			File delFile = new File(path,emp.getEmp_profile_re_name());
			delFile.delete();
		}
		model.addAttribute("msg", msg);
		model.addAttribute("loc", loc);
		
		return "common/msg";
	}
	
	@GetMapping("/searchEmployeeId")
	public @ResponseBody int searchemployeeId(String emp_id){
		
		int value =0;
		Map<String,Object> param = new HashMap<>();
		
		param.put("type","emp_id");
		param.put("keyword",emp_id);
		
		List<Employee> result = service.searchEmployeesByKeyword(param);
		
		if(result.size()>0) {
			value=1;
		}else {
			value=0;
		}
		
		return value;
	}
	
	@PostMapping("/employeeDetail")
	public String employeeDetail(Model model, int emp_no) {
		
		Map<String,Object> value = new HashMap<>();
		
		value = service.selectEmployeeByEmpNo(emp_no);

		model.addAttribute("employee", value.get("employee"));
		model.addAttribute("account",value.get("account"));
		
		return "employees/employeeDetail";
	}
	
	@PostMapping("/updateEmployeeDetail")
	public String updateEmployeeDetail(Model model, int emp_no) {
		Map<String,Object> value = new HashMap<>();
		
		value = service.selectEmployeeByEmpNo(emp_no);
	
		Map<String,List<Map<String,Object>>> data = service.selectDataListForEmployee();
		model.addAttribute("data",data);
		model.addAttribute("employee", value.get("employee"));
		model.addAttribute("account",value.get("account"));
		
		return "employees/updateEmployeeDetail";
	
	}
	
	@PostMapping("/updateEmployeePasswordCheck")
	public String updateEmployeePassword(Model model, int emp_no) {
		
		Map<String,Object> value = new HashMap<>();
		
		value = service.selectEmployeeByEmpNo(emp_no);
	
		Map<String,List<Map<String,Object>>> data = service.selectDataListForEmployee();
		model.addAttribute("data",data);
		model.addAttribute("employee", value.get("employee"));
		
		
		return "employees/updateEmployeePasswordCheck";
	}

	
	@PostMapping("updateEmployeePasswordCheckEnd")
	public @ResponseBody Employee checkEmployeeByIdAndPassword(String empId, String empPassword) {
		
		Map<String,String> empData = new HashMap<>();
		empData.put("empId", empId);
		empData.put("empPassword", empPassword);
		
		Employee employee =service.checkEmployeeByIdAndPassword(empData);
		
		return employee;
	}
	
	@PostMapping("/updateEmployeePasswordWrite")
	public String updateEmployeePasswordWrite(Model model,@RequestParam("empNo") int empNo) {
		
		Map<String,Object> value = new HashMap<>();
		
		value = service.selectEmployeeByEmpNo(empNo);
		
		model.addAttribute("employee",value.get("employee"));
		
		return "employees/updateEmployeePasswordWrite";
	}
	
	
	
	
	@PostMapping("/updatePassword")
	public @ResponseBody int updatePassword(Model model,
			@RequestParam("empId") String empId,
			@RequestParam("empPassword") String empPassword,
			@RequestParam("modifier") int modifier) {
		
		Map<String,Object> IdAndPassword = new HashMap<>();

		String encodePassword = passwordEncoder.encode(empPassword);
		
		IdAndPassword.put("empId", empId);
		IdAndPassword.put("empPassword", encodePassword);
		IdAndPassword.put("modifier", modifier);
		
		int result =service.updatePassword(IdAndPassword);
		
		
		return result;
	}
	
	@PostMapping("updateEmployeeEnd.do")
	public String updateEmployeeEnd (Model model, Employee emp,
			Account ac,@RequestPart(value="upFile", required = false) MultipartFile upFile, HttpSession session, String email_id,
			@RequestParam(name="email_form" , required=true) String email_form, @RequestParam(name="pre_file", required = false) String pre_file) {
		
	
		String path = session.getServletContext().getRealPath("/resources/upload/profile");
		
		File folder =  new File(path);
		
		if(!folder.exists()) {
			try {
				folder.mkdir();
			}catch(Exception e) {
				e.printStackTrace();
			}

		}
		
		//새로운 파일이 있다면
		if(upFile!=null && !upFile.isEmpty()) {
			//이전 파일 삭제
			if(pre_file!=null && pre_file!="") {
				File preFile = new File(path,pre_file);
				preFile.delete();				
			}
			
			//이름 부여
			String oriName = upFile.getOriginalFilename();
			String ext = oriName.substring(oriName.lastIndexOf("."));
			Date today = new Date(System.currentTimeMillis());
			int randomNum = (int)(Math.random()*10000)+1;
			String reName = "HIVEWORKS_"+(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(today))+"_"+randomNum+ext;
			
			try {
				upFile.transferTo(new File(path,reName));
					emp.setEmp_profile_ori_name(oriName);
					emp.setEmp_profile_re_name(reName);
			}catch(IOException e){
				e.printStackTrace();
			}
			
		}

		String empEmail = email_id+"@"+email_form;
		emp.setEmp_email(empEmail);
		
		String msg, loc;
		Map<String,Object> empData = new HashMap<>();
		
		empData.put("employee", emp);
		empData.put("account", ac);
		
		
		try {
			int result = service.updateEmployee(empData);
			
			msg="정보 수정 성공";
			loc="employees/employeeList";

		}catch(RuntimeException e) {
			msg="정보 수정 실패";
			loc="employees/enrollEmployee";
			File delFile = new File(path,emp.getEmp_profile_re_name());
			delFile.delete();
		}
		model.addAttribute("msg", msg);
		model.addAttribute("loc", loc);
		
		return "common/msg";
	}
	
	
	
	
	
	@GetMapping("/deleteEmployee")
	public String deleteEmployee(@RequestParam("emp_no") int emp_no, Model model) {
		
		
		//int empNo = Integer.parseInt(emp_no);
		
		String msg,loc;
		try {
			int result = service.deleteEmployee(emp_no);
			
			msg="퇴사 처리 성공";
			loc="employees/employeeList";

		}catch(RuntimeException e) {
			msg="퇴사 처리 실패";
			loc="employees/employeeList";
		}
		model.addAttribute("msg", msg);
		model.addAttribute("loc", loc);
		
		return "common/msg";
	}
	
	@GetMapping("/manageAuthority")
	public String manageAuthority(Model model) {
		
		List<Employee> employees = service.selectEmployeesListAll();
	
		Map<String, List<Map<String, Object>>> autCodeList = service.selectAuthorityList();
		
		model.addAttribute("employees",employees);
		model.addAttribute("autCodeList", autCodeList);
		
		return "employees/manageAuthority";
	}
	
	@PostMapping("/updateAuthorities")
	public @ResponseBody int updateAuthorities(@RequestBody Map<String, List<String>> data ) {

		int result = service.updateAuthorities(data);
		
		return result;
	
	}

	@GetMapping("/excelEmployeeDownload")
	public View downloadEmployeesAndAccount(Model model) {
		
		Map<String, Object> employeesAndAccounts = service.downloadEmployeesAndAccount();
		
		model.addAttribute("employees", employeesAndAccounts.get("employees"));
		model.addAttribute("accounts", employeesAndAccounts.get("accounts"));
		
		return new ExcelEmployeeListConvert();
	}
	
	@PostMapping("/excelEmployeeUpload")
	public String uploadEmployeesAndAccount(
			Employee employee,
			Account account,
	        HttpServletRequest request,
	        HttpSession session,
	        final MultipartHttpServletRequest multiRequest,
	        Model model) throws Exception {
	 
	//LoginVO loginVO = loginService.getLoginInfo();
	 
	
	String msg,loc;
	String path = session.getServletContext().getRealPath("/resources/upload");
	try{
	    
	    ExcelRequestManager em = new ExcelRequestManager();
	    final Map<String, MultipartFile> files = multiRequest.getFileMap();
	    List<HashMap<String,String>> enrollEmployeesList =null;
	    
	    
	    enrollEmployeesList = em.parseExcelSpringMultiPart(files,"employees", 0, "", path);
	    Map<String,Object> empData = new HashMap<>();
	    List<Employee> employees = new ArrayList<>();
	    List<Account> accounts = new ArrayList<>();
	    for(int i = 0; i < enrollEmployeesList.size(); i++){
	    	employee = new Employee();
	    	account = new Account();
			/*addHeader(sheet1,
					List.of("사원번호","아이디","이름","주민번호","입사일","퇴사일","사내전화","핸드폰번호"
							,"이메일","부서명","직위","직무","근로상태","근로형태","근무유형","권한","우편번호","주소","상세주소","메모","계좌번호","은행","소유주"));*/
	    	
	    	
			/*
			 * String strDate = "2024-01-22"; // 변환하려는 날짜 문자열
			 * 
			 * // String 값을 java.util.Date 형으로 변환 SimpleDateFormat format = new
			 * SimpleDateFormat("yyyy-MM-dd"); Date utilDate = format.parse(strDate);
			 * 
			 * // java.util.Date 값을 java.sql.Date 형으로 변환 java.sql.Date sqlDate = new
			 * java.sql.Date(utilDate.getTime());
			 * 
			 */	    	
	    	
	    	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	    	Date utilHiredDate = format.parse(enrollEmployeesList.get(i).get("cell_5"));
	    	java.sql.Date sqlHiredDate = new java.sql.Date(utilHiredDate.getTime());
	    	
	    	
	    	//employee.setEmp_no(Integer.parseInt(enrollEmployeesList.get(i).get("cell_0")==null?enrollEmployeesList.get(i).get("cell_0"):"0"));
	    	employee.setEmp_id(enrollEmployeesList.get(i).get("cell_1"));
	    	
	    	String encodePassword = passwordEncoder.encode(enrollEmployeesList.get(i).get("cell_2"));
	    	employee.setEmp_pw(encodePassword);
	    	employee.setEmp_name(enrollEmployeesList.get(i).get("cell_3"));
	    	employee.setEmp_resident_no(enrollEmployeesList.get(i).get("cell_4"));
	    	employee.setEmp_hired_date(sqlHiredDate);
	    	employee.setEmp_phone(enrollEmployeesList.get(i).get("cell_6"));
	    	employee.setEmp_cellphone(enrollEmployeesList.get(i).get("cell_7"));
	    	employee.setEmp_email(enrollEmployeesList.get(i).get("cell_8"));
	    	
	    	employee.setDept_code(enrollEmployeesList.get(i).get("cell_9").toUpperCase());
	    	employee.setJob_code(enrollEmployeesList.get(i).get("cell_10").toUpperCase());
	    	employee.setPosition_code(enrollEmployeesList.get(i).get("cell_11").toUpperCase());
	    	employee.setWork_status(enrollEmployeesList.get(i).get("cell_12").toUpperCase());
	    	employee.setWork_pattern(enrollEmployeesList.get(i).get("cell_13").toUpperCase());
	    	employee.setWork_type_code(enrollEmployeesList.get(i).get("cell_14").toUpperCase());
	    	employee.setAut_code(enrollEmployeesList.get(i).get("cell_15").toUpperCase());
	    	employee.setEmp_postcode(enrollEmployeesList.get(i).get("cell_16"));
	    	employee.setEmp_address(enrollEmployeesList.get(i).get("cell_17"));
	    	employee.setEmp_address_detail(enrollEmployeesList.get(i).get("cell_18"));
	    	employee.setEmp_memo(enrollEmployeesList.get(i).get("cell_19"));
  	
	    	account.setAc_no(enrollEmployeesList.get(i).get("cell_20"));
	    	account.setAc_bank(enrollEmployeesList.get(i).get("cell_21"));
	    	account.setAc_name(enrollEmployeesList.get(i).get("cell_22"));
	    	
	    	employees.add(employee);
	    	accounts.add(account);
	    	
			/*
			 * searchVO.setResv_program_type(apply.get(i).get("cell_0"));
			 * searchVO.setResv_program(apply.get(i).get("cell_1"));
			 * searchVO.setResv_biz_name(apply.get(i).get("cell_2"));
			 * searchVO.setResv_biz_owner(apply.get(i).get("cell_3"));
			 * searchVO.setResv_postno(apply.get(i).get("cell_4").replaceAll(",", ""));
			 * searchVO.setResv_adrs1(apply.get(i).get("cell_5").replaceAll(",", ""));
			 * searchVO.setResv_adrs2(apply.get(i).get("cell_6").replaceAll(",", ""));
			 * searchVO.setResv_biz_tel(apply.get(i).get("cell_7"));
			 * searchVO.setResv_name(apply.get(i).get("cell_8"));
			 * searchVO.setResv_birth(apply.get(i).get("cell_9"));
			 * searchVO.setResv_gender(apply.get(i).get("cell_10"));
			 * searchVO.setResv_tel(apply.get(i).get("cell_11"));
			 * searchVO.setResv_email(apply.get(i).get("cell_12"));
			 * searchVO.setResv_depositor(apply.get(i).get("cell_13"));
			 * searchVO.setResv_refund(apply.get(i).get("cell_14"));
			 * searchVO.setResv_state(stateType.getMain_code());
			 * 
			 * searchVO.setSite_code(loginService.getSiteCode());
			 * searchVO.setCret_id(loginVO.getId());
			 * searchVO.setCret_ip(request.getRemoteAddr()); searchVO.setResv_gubun("L");
			 */
	                                     
	       // reserveService.insertReserveVO(searchVO);
	    }
	    
	    empData.put("employees",employees);
	    empData.put("accounts",accounts);

	    int result = service.insertEmployeeByExcel(empData);
	    
	    msg="정보 수정 성공";
		loc="employees/employeeList";
	    
	 
	}catch(Exception e){
	    msg="정보 수정 실패";
		loc="employees/employeeList";
	    }
	 
		model.addAttribute("msg", msg);
		model.addAttribute("loc", loc);
		
		return "common/msg";
	}
	
	
	@GetMapping("/sampleDownload")
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        
		// 서버에 저장된 파일의 경로
		String realPath = request.getServletContext().getRealPath("/resources/upload/excelformat/");
		
        String fileName = "upload_excel_format.xlsx";
		File sample = new File(realPath+fileName);

        try (FileInputStream fileInputStream = new FileInputStream(sample);
             OutputStream output = response.getOutputStream()) {
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            URLEncoder encoder = new URLEncoder();
            response.setHeader("Content-Disposition", "attachment; filename=" +  encoder.encode(fileName, StandardCharsets.UTF_8));

            byte[] buffer = new byte[1024];
            int b;

            while ((b = fileInputStream.read(buffer)) != -1) {
                output.write(buffer, 0, b);
            }

            output.flush();
        }
    }
	
	@GetMapping("/employeeListBasis")
	public String selectEmployeeListOfBasis(Model model) {
		
		List<Employee> employees = service.selectEmployeesListAll();
		
		model.addAttribute("employees",employees);
		
		return "employees/employeeListBasis";
	}
	
	
	@GetMapping("/employeeDetailBasis")
	public String selectEmployeeDetailOfBasis(Model model, int emp_no) {
		
		Map<String,Object> value = new HashMap<>();
		
		value = service.selectEmployeeByEmpNo(emp_no);

		model.addAttribute("employee", value.get("employee"));
		model.addAttribute("account",value.get("account"));
		
		return "employees/employeeDetailBasis";
		
	}
	
	
}

