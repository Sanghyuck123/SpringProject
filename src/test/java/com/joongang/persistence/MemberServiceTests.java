package com.joongang.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.joongang.domain.MemberVO;
import com.joongang.service.MemberService;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.joongang.config.RootConfig.class,
		com.joongang.config.SecurityConfig.class})
@Log4j2
public class MemberServiceTests {
	
	@Setter(onMethod_ = @Autowired)
	private MemberService memberService;
	
	@Test
	public void testsighnup() {
		MemberVO vo = new MemberVO("a","b","c","d","e");
		memberService.signup(vo);
	}
	
}
