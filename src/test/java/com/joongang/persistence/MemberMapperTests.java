package com.joongang.persistence;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.joongang.domain.MemberVO;
import com.joongang.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.joongang.config.RootConfig.class})
@Log4j2
public class MemberMapperTests {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper memberMapper;
	
	@Test
	public void testInsertMember() {
		String userid = "ddd";
		String username = "d";
		String userpw = "d";
		String location = "d";
		String gender = "d";
		
		List<MemberVO> list = new ArrayList<MemberVO>();
		MemberVO vo= new MemberVO(userid, username, userpw, location, gender);
		 list.add(vo);
		 for (MemberVO item : list) {
			 memberMapper.insertMember(item);
		 }
	}
}
