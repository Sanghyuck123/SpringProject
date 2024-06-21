package com.joongang.mapper;

import java.util.List;

import com.joongang.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insertAttach(BoardAttachVO vo);
	public List<BoardAttachVO> getAttachList(Long bno);
	public void deleteALL(Long bno);
	public void delete(String uuid);
	public List<BoardAttachVO> getOldfiles (String uploadpath);
}
