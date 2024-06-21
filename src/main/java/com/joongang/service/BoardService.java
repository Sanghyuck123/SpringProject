package com.joongang.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.mapper.BoardAttachMapper;
import com.joongang.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class BoardService {
	@Setter(onMethod_=@Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper bamapper;
	
	@Transactional
	public void register(BoardVO vo) {
		mapper.insertBoard(vo);
		
		List<BoardAttachVO> list = vo.getAttachList();
		if  (list == null || list.isEmpty()) {
			return;
		}
		
		for (BoardAttachVO attach : list) {
			attach.setBno(vo.getBno());
			bamapper.insertAttach(attach);
		}
		
	}
	
	public List<BoardAttachVO> getAttachList(Long bno) {
		return bamapper.getAttachList(bno);
	}
	
	public List<BoardVO> getList(Criteria criteria) {
		return mapper.getListWithPaging(criteria);
//		return mapper.getList();
	}
	
	public BoardVO get(Long bno) {
		return mapper.get(bno);
	}
	
	public boolean update(BoardVO vo) {
		return mapper.update(vo) == 1;
	}
	
	public boolean delete(Long bno) {
		return mapper.delete(bno) == 1;
	}
	
	public int getTotal(Criteria criteria) {
		return mapper.getTotalCount(criteria);
	}
	
	public boolean modify(BoardVO vo) {
		log.info("modfiy...."+ vo);
		bamapper.deleteALL(vo.getBno());
		boolean modifyResult = mapper.update(vo) == 1;
		List<BoardAttachVO> list = vo.getAttachList();
		if(modifyResult && list != null) {
			for (BoardAttachVO bavo : list) {
				bavo.setBno(vo.getBno());
				bamapper.insertAttach(bavo);
			}
		}
		return modifyResult;
	}
	
	@Transactional
	public boolean remove(Long bno) {
		bamapper.deleteALL(bno);
		return mapper.delete(bno) == 1;
	}
}
