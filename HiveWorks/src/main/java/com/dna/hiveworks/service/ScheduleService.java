package com.dna.hiveworks.service;

import java.util.List;
import java.util.Map;

import com.dna.hiveworks.model.dto.Employee;
import com.dna.hiveworks.model.dto.Resource;
import com.dna.hiveworks.model.dto.Schedule;

public interface ScheduleService {
	
	
	List<Employee> selectEmployeesList();
	
	
	List<Schedule> selectScheduleAll();
	
	List<Schedule> searchSchedule(Map<String,Object> param);

	int insertSchedule(Schedule schedule, List<Integer> empList);
	
	int updateSchedule(Schedule schdule, List<Integer> empList, int calNo);
	
	int deleteSchedule(int calNo);
	
	

	//resource
	int insertResource(Resource resource);
	
	List<Resource> selectResourceAll();
	
	//reservation 
	List<Schedule> selectReserveAll();
	
	List<Schedule> selectReserveByNo(int empNo);

	List<Schedule> selectReserveByCode(String calCode);
	
	int reserveResource(Schedule schedule, int resourceNo);
	
	//project
	List<Schedule> selectprojectAll();
	
	List<Schedule> selectprojectByEmpNo(int empNo);
	
	Schedule selectprojectByCalNo(int calNo);
	
	
	

}
