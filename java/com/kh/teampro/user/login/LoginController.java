package com.kh.teampro.user.login;

import java.util.UUID;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequestMapping(value = "/loginUser")
public class LoginController {

	@Autowired
	private JavaMailSenderImpl mailSender;
	
	@Autowired
	private UserService userService;
	
	// 로그인 폼 - get요청
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String loginFrom () {
		return "user/login";
	}
	
	// 로그인 처리 - post
//	@RequestMapping(value = "/login", method = RequestMethod.POST)
//	public String loginRun (LoginDto loginDto, HttpSession session,
//			RedirectAttributes rttr) {
//		System.out.println("LoginDto:" + loginDto);
//		UserVo userVo = userService.login(loginDto);
//		String returnPage = "redirect:/board/list";
//		if (userVo != null) {
//			String targetLocation = 
//						(String)session.getAttribute("targetLocation");
//			if(targetLocation != null) {
//				returnPage = "redirect:"+ targetLocation;
//			}
//			session.removeAttribute("targetLocation");
//			session.setAttribute("loginInfo", userVo);
//		} else {
//			rttr.addFlashAttribute("loginResult", "FAIL");
//			returnPage = "redirect:/login";
//		}
//		return returnPage;
//	}
	
	// 로그아웃
//	@RequestMapping(value = "/logout", method = RequestMethod.GET)
//	public String logout(HttpSession session) {
//		session.invalidate();
//		return "redirect:/loginUser/login";
//	}
	
	// 비밀번호 찾기 폼으로 이동 (이메일 연동 임시 비밀번호 생성)
//	@RequestMapping(value="/forgotPassword", method = RequestMethod.GET)
//	public String forgotPassword() {
//		return "/user/forgotPassword";
//	}

	// 임시 비밀번호 생성 (이메일 연동)
//	@RequestMapping(value="/sendPassword", method = RequestMethod.POST)
//	public String sendPassword(String id, String email) {
//		System.out.println("id:" + id);
//		System.out.println("email:" + email);
//		
//		String uuid = UUID.randomUUID().toString();
//		String newPass = uuid.substring(0, uuid.indexOf("-"));
//		System.out.println("newPass:" + newPass);
//		
//		MimeMessagePreparator preparator = new MimeMessagePreparator() {
//			
//			@Override
//			public void prepare(MimeMessage mimeMessage) throws Exception {
//				MimeMessageHelper helper = new MimeMessageHelper(
//						mimeMessage,
//						false, // multipart 여부
//						"utf-8"
//						);
//				
//				helper.setFrom("teamprobusan@gmail.com"); // 보내는이
//				helper.setTo(email); // 받는이
//				helper.setSubject("비밀번호 변경 안내"); // 제목
//				helper.setText("변경된 비밀번호:" + newPass); // 내용
//			}
//		};
//		mailSender.send(preparator);
//		
//		return "redirect:/user/login";
//	}
	
	
}
