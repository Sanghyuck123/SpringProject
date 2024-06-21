package com.joongang.mapper;

import java.util.List;

import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;

public interface BoardMapper {
	public void insertBoard(BoardVO vo);
	public List<BoardVO> getList();
	public BoardVO get(Long bno);
	public int update(BoardVO vo);
	public int delete(Long bno);
	public int getTotalCount(Criteria criteria);
	public List<BoardVO> getListWithPaging(Criteria criteria);
}
