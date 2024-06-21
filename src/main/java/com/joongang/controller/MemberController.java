package com.joongang.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.joongang.domain.AuthVO;
import com.joongang.domain.MemberVO;
import com.joongang.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/member/*")
@AllArgsConstructor
@Log4j2
public class MemberController {
	private MemberService memberService;
	@GetMapping("/signup")
	public String signupForm(Model model) {
		return "/member/signup";
	}
	
	@PostMapping("/signup")
	public String signupSubmit(MemberVO vo,HttpSession session) {
		String userpw = vo.getUserpw();
		memberService.signup(vo);
		 try {
			vo.setUserpw(userpw);
	        AuthVO vo1 = memberService.authenticate(vo);
	        session.setAttribute("auth", vo1);
	        } catch (Exception e) {
	        }
		return "redirect:/";
	}
	
	@GetMapping("/login")
	public String loginForm(Model model) {
		return "/member/login";
	}
	
	@PostMapping("/login")
	public String loginSubmit(MemberVO vo, HttpSession session,
			RedirectAttributes rttr) {
		 try {
	        AuthVO vo1 = memberService.authenticate(vo);
	        session.setAttribute("auth", vo1);
	        String s = (String)session.getAttribute("userURI");
	        if(s != null) {
	        	return "redirect:"+s;
	        }
	        } catch (Exception e) {
	        	log.info(e.getMessage());
	        	rttr.addFlashAttribute("error",e.getMessage());
	        	return "redirect:/member/login";
	        }
		return "redirect:/";
	}
	
	@GetMapping("/logout")
	public String logoutForm(Model model, HttpSession session, RedirectAttributes rttr) {
		session.removeAttribute("auth");
		rttr.addFlashAttribute("msg", "logout");
	
		return "redirect:/";
	}
}
