package com.joongang.mapper;

import com.joongang.domain.MemberVO;

public interface MemberMapper {
	public void insertMember(MemberVO vo);
	public MemberVO selectMemberByUserid(String userid);
}
