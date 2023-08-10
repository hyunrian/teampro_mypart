package com.kh.teampro.reply.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserReplyDao {

	private static final String NAMESPACE = "com.kh.teampro.UserReplyMapper.";
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<UserReplyVo> getUserReply(int bno) {
		if (getReplycnt(bno) != 0)
			return sqlSession.selectList(NAMESPACE + "getUserReply", bno);
		else return null;
	}
	
	public void insertUserNewReply(UserReplyVo userReplyVo) {
		sqlSession.insert(NAMESPACE + "insertUserNewReply", userReplyVo);
	}
	
	public void insertUserReReply(UserReplyVo userReplyVo) {
		sqlSession.insert(NAMESPACE + "insertUserReReply", userReplyVo);
	}
	
	public int getMaxRseq(int bno, int rgroup) {
		Map<String, Integer> map = new HashMap<>();
		map.put("bno", bno);
		map.put("rgroup", rgroup);
		return sqlSession.selectOne(NAMESPACE + "getMaxRseq", map);
	}
	
	public int getReplycnt(int bno) {
		return sqlSession.selectOne(NAMESPACE + "getReplycnt", bno);
	}
}