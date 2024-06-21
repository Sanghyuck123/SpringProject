package com.joongang.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.joongang.domain.AuthVO;
import com.joongang.domain.MemberVO;
import com.joongang.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class MemberService {
	@Setter(onMethod_=@Autowired)
	private MemberMapper mapper;

	@Setter(onMethod_=@Autowired)
	private PasswordEncoder pwencoder;
	
	public void signup(MemberVO vo) {
		vo.setUserpw(pwencoder.encode(vo.getUserpw()));
		mapper.insertMember(vo);
	}
	
	public AuthVO authenticate(MemberVO vo) throws Exception{
		MemberVO vo1 = mapper.selectMemberByUserid(vo.getUserid());
		if(vo1 == null) {
			throw new Exception("nonuser");
		}
		if(!pwencoder.matches(vo.getUserpw(), vo1.getUserpw())) {
			throw new Exception("nomatch");
		}
		
		AuthVO authVO = new AuthVO();
		authVO.setUserid(vo1.getUserid());
		authVO.setUsername(vo1.getUsername());
		return authVO;
	}
}
