package com.kh.teampro.reply.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.kh.teampro.commons.MyConstants;

@RestController
@RequestMapping("/userReply")
public class UserReplyController {

	@Autowired
	private UserReplyService userReplyService;
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public List<UserReplyVo> getUserReply(int bno) {
		return userReplyService.getUserReply(bno);
	}
	
	@RequestMapping(value = "/insert", method = RequestMethod.POST)
	public String insertUserReply(UserReplyVo userReplyVo) {
		userReplyVo.setReplyer("tester"); // session에 넣을 loginInfo의 값으로 변경해야 함
		
		if (userReplyVo.getRlevel() == 0) { // 새 댓글인 경우
			userReplyService.insertUserNewReply(userReplyVo);
		} else { // 대댓글인 경우
			int maxRseq = 
					userReplyService.getMaxRseq(userReplyVo.getBno(), userReplyVo.getRgroup());
			userReplyVo.setRseq(maxRseq + 1);
//			userReplyService.insertUserReReply(userReplyVo);
		}
		
		System.out.println("vo: " + userReplyVo); 
		
		return MyConstants.SUCCESS_MESSAGE;
	}
	
}
