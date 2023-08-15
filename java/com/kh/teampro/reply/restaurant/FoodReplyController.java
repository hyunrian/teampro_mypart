package com.kh.teampro.reply.restaurant;

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
public class FoodReplyController {

	@Autowired
	private FoodReplyService foodReplyService;
	
	// 댓글 목록
	@RequestMapping(value = "/restList", method = RequestMethod.GET)
	public List<FoodReplyVo> getFoodReplylist(int bno){
		List<FoodReplyVo> list = foodReplyService.getFoodReplyList(bno);
		return list;
	}
	
	// 댓글 추가
	@RequestMapping(value = "/restInsert", method = RequestMethod.POST)
	public String foodReplyInsert(FoodReplyVo foodReplyVo,
		HttpSession session) throws Exception{
//		UserVo userVo = (UserVo)session.getAttribute(null); // 저장된 아이디 가져오기(수정필요)
//		foodReplyVo.setReplyer(userVo.getUserid()); // (수정필요)
		foodReplyVo.setReplyer("writer00"); // 닉네임 : test00 (임시 set)
		foodReplyVo.setUserid("userId00"); // 아이디 : test00 (임시 set)
		if(foodReplyVo.getRlevel() == 0) {
			foodReplyService.insertRestNewReply(foodReplyVo);
		} else {
			int bno = foodReplyVo.getBno();
			int rgroup = foodReplyService.getRgroup(foodReplyVo.getRno());
			foodReplyVo.setRgroup(rgroup);
			int maxRseq = foodReplyService.getMaxRseq(bno, foodReplyVo.getRgroup());
			foodReplyVo.setRseq(maxRseq + 1); // 다음에 달릴 댓글(해당 댓글) = 기존 순번(seq) + 1
			foodReplyService.insertRestReReply(foodReplyVo);
		}
		return MyConstants.SUCCESS_MESSAGE;
	}
	
	 // 댓글 수정
	@RequestMapping(value = "/restUpdate", method = RequestMethod.PATCH)
	public String foodReplyUpdate(@RequestBody FoodReplyVo foodReplyVo) {
		foodReplyVo.setReplyer("writer00"); // 닉네임 : test00 (임시 set)
		foodReplyService.updateRestReply(foodReplyVo);
		return MyConstants.SUCCESS_MESSAGE;
	}
	
	//  대댓글이 있는 댓글인지 확인
	@RequestMapping(value = "/checkChildRestReply/{rno}", method = RequestMethod.GET)
	public boolean hasChildRestReply(@PathVariable String rno) { // 비동기 방식일때는 pathVariable이 String/Vo/map 등의 타입이어야 함. int 타입은 오류발생
		boolean hasChildRestReply = foodReplyService.hasChildRestReply(Integer.valueOf(rno));
		return hasChildRestReply;
	}
	
	// 댓글 삭제
	@RequestMapping(value = "/restDelete", method = RequestMethod.PATCH)
	public String delete(@RequestBody String rno) {
		foodReplyService.foodReplyDelete(Integer.valueOf(rno)); // 비동기 방식일때는 pathVariable이 String/Vo/map 등의 타입이어야 함. int 타입은 오류발생
		return MyConstants.SUCCESS_MESSAGE;
	}
}
