package com.kh.teampro.reply.accommodation;

import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.kh.teampro.commons.MyConstants;
import com.kh.teampro.user.info.UserVo;

@RestController
@RequestMapping("/reply")
public class AccomReplyController {

	@Autowired
	private AccomReplyService accomReplyService;
	
	// 댓글 목록
	@RequestMapping(value = "/accomList", method = RequestMethod.GET)
	public List<AccomReplyVo> getAccomReplyList(int bno){
		List<AccomReplyVo> list = accomReplyService.getAccomReplyList(bno);
		return list;
	}
	
	// 댓글 추가
	@RequestMapping(value = "/accomInsert", method = RequestMethod.POST)
	public String accomReplyInsert(AccomReplyVo accomReplyVo,
		HttpSession session) throws Exception{
//		UserVo userVo = (UserVo)session.getAttribute(null); // 저장된 아이디 가져오기(수정필요)
//		foodReplyVo.setReplyer(userVo.getUserid()); // (수정필요)
		accomReplyVo.setReplyer("tester"); // 닉네임 : test00 (임시 set)
		accomReplyVo.setUserid("testuser"); // 아이디 : test00 (임시 set)
		if(accomReplyVo.getRlevel() == 0) {
			accomReplyService.insertAccomNewReply(accomReplyVo);
		} else {
			int bno = accomReplyVo.getBno();
			int rgroup = accomReplyService.getRgroup(accomReplyVo.getRno());
			accomReplyVo.setRgroup(rgroup);
			int maxRseq = accomReplyService.getMaxRseq(bno, accomReplyVo.getRgroup());
			accomReplyVo.setRseq(maxRseq + 1); // 다음에 달릴 댓글(해당 댓글) = 기존 순번(seq) + 1
			accomReplyService.insertAccomReReply(accomReplyVo);
		}
		return MyConstants.SUCCESS_MESSAGE;
	}
	
	 // 댓글 수정
	@RequestMapping(value = "/accomUpdate", method = RequestMethod.PATCH)
	public String updateAccomReply(@RequestBody AccomReplyVo accomReplyVo) {
		accomReplyVo.setReplyer("tester"); // 닉네임 : test00 (임시 set)
		accomReplyService.updateAccomReply(accomReplyVo);
		return MyConstants.SUCCESS_MESSAGE;
	}
	
	//  대댓글이 있는 댓글인지 확인
	@RequestMapping(value = "/checkChildAccomReply/{rno}", method = RequestMethod.GET)
	public boolean hasChildAccomReply(@PathVariable String rno) { // 비동기 방식일때는 pathVariable이 String/Vo/map 등의 타입이어야 함. int 타입은 오류발생
		boolean hasChildAccomReply = accomReplyService.hasChildAccomReply(Integer.valueOf(rno));
		return hasChildAccomReply;
	}
	
	// 댓글 삭제
	@RequestMapping(value = "/accomDelete", method = RequestMethod.PATCH)
	public String delete(@RequestBody String rno) {
		accomReplyService.deleteAccomReply(Integer.valueOf(rno)); // 비동기 방식일때는 pathVariable이 String/Vo/map 등의 타입이어야 함. int 타입은 오류발생
		return MyConstants.SUCCESS_MESSAGE;
	}
}
