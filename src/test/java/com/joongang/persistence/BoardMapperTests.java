package com.joongang.persistence;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.joongang.domain.BoardVO;
import com.joongang.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.joongang.config.RootConfig.class,
		com.joongang.config.SecurityConfig.class})
@Log4j2
public class BoardMapperTests {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Test
	public void testInsertBoard() {
		String title = "ddd";
		String content = "d";
		String writer = "d";
		
		BoardVO vo= new BoardVO(title, content, writer);
		boardMapper.insertBoard(vo);
	}
	
}
