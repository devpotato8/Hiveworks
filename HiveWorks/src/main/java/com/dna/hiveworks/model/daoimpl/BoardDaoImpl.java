package com.dna.hiveworks.model.daoimpl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.dna.hiveworks.model.dao.BoardDao;
import com.dna.hiveworks.model.dto.board.Board;
import com.dna.hiveworks.model.dto.board.Survey;
import com.dna.hiveworks.model.dto.board.Uploadfile;

import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
public class BoardDaoImpl implements BoardDao{
	
	@Override
	public Board selectBoardByNo(SqlSession session, int boardNo) {
		return session.selectOne("board.selectBoardByNo",boardNo);
	}
	@Override
	public List<Board> selectAllBoard(SqlSession session,String boardType) {
	    return session.selectList("board.selectAllBoard",boardType);
	}
	@Override
	public int insertBoard(SqlSession session, Board b) {
		return session.insert("board.insertBoard",b);
	}
	@Override
	public int boardUpdate(SqlSession session,Board b) {
		return session.update("board.boardUpdate",b);
	}
	@Override
	public int boardDelete(SqlSession session, int boardNo) {
		return session.delete("board.boardDelete",boardNo);
	}
	@Override
	public int insertUploadfile(SqlSession session, Uploadfile uploadfile) {
		log.debug("Inserting upload file: {}", uploadfile);
		return session.insert("board.insertUploadfile",uploadfile);
	}
	
	@Override
	public int updateBoardCount(SqlSession session, int boardNo) {
	    return session.update("board.updateBoardCount", boardNo);
	}
	
}