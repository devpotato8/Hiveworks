package com.dna.hiveworks.model.daoimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.dna.hiveworks.model.dao.MsgDao;
import com.dna.hiveworks.model.dto.Message;

@Repository
public class MsgDaoImpl implements MsgDao {

	@Override
	public List<Message> msgList(SqlSession session, int empNo) {
		return session.selectList("message.msgList",empNo);
	}
	
	@Override
	public List<String> sharedEmp(SqlSession session, Map<String,String> msgSharedEmps) {
		return session.selectList("message.sharedEmp",msgSharedEmps);
	}

	@Override
	public int starMark(SqlSession session, int msgNo) {
		return session.update("message.starMark",msgNo);
	}

	@Override
	public int starUnmark(SqlSession session, int msgNo) {
		return session.update("message.starUnmark",msgNo);
	}

	@Override
	public List<String> receiverNames(SqlSession session, List<Integer> empNos) {
		return session.selectList("message.receiverNames",empNos);
	}

	@Override
	public String categoryName(SqlSession session, String cateNo) {
		return session.selectOne("message.categoryName",cateNo);
	}

	@Override
	public int sendMsg(SqlSession session, Map<String, Object> params) {
		return session.insert("message.sendMsg",params);
	}

	@Override
	public int readMsg(SqlSession session, Map<String, Integer> params) {
		return session.update("message.readMsg",params);
	}

	@Override
	public int starChekedBtn(SqlSession session, Map<String, Integer> params) {
		System.out.println(params);
		return session.update("message.starChekedBtn",params);
	}

	@Override
	public int trashChekedBtn(SqlSession session, Map<String, Integer> params) {
		System.out.println(params);
		return session.update("message.trashChekedBtn",params);
	}

	@Override
	public int starUnchekedBtn(SqlSession session, Map<String, Integer> params) {
		return session.update("message.starUnchekedBtn",params);
	}

	
	
	

	
	
	

	
	
	

}
