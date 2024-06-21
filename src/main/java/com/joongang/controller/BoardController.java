package com.joongang.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.joongang.domain.BoardAttachVO;
import com.joongang.domain.BoardVO;
import com.joongang.domain.Criteria;
import com.joongang.domain.PageDTO;
import com.joongang.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/board/*")
@AllArgsConstructor
@Log4j2
public class BoardController {
	@Setter(onMethod_=@Autowired)
	private BoardService boardService;
	
	@GetMapping("/register")
	public String register() {
		return "/board/register";
	}
	
	
	@PostMapping("/register")
	public String registerSubmit(BoardVO vo, RedirectAttributes rttr) {
		boardService.register(vo);
		rttr.addFlashAttribute("result",vo.getBno());
		return "redirect:/board/list";
	}
	
	@GetMapping("/list")
	public String getList(Criteria criteria ,Model model) {
		List<BoardVO> list = boardService.getList(criteria);
		model.addAttribute("List", list);
		int total = boardService.getTotal(criteria);
		model.addAttribute("pageDTO", new PageDTO(criteria, total));
		log.info(list + "total:" + total + " " + criteria.getListLink());
		return "/board/list";
	}
	
	@GetMapping("/get")
	public String get(Model model, BoardVO vo, Criteria criteria) {
		Long bno = vo.getBno();
		int total = boardService.getTotal(criteria);
		model.addAttribute("pageDTO", new PageDTO(criteria, total));
		model.addAttribute("get", boardService.get(bno));
		return "/board/get";
	}
	
	@GetMapping("/modify")
	public String modify(Model model, BoardVO vo, Criteria criteria) {
		Long bno = vo.getBno();
		int total = boardService.getTotal(criteria);
		model.addAttribute("pageDTO", new PageDTO(criteria, total));
		model.addAttribute("get", boardService.get(bno));
		return "/board/modify";
	}
	
	@PostMapping("/modify")
	public String modifySubmit(BoardVO vo, RedirectAttributes rttr, Criteria criteria) {
		if(boardService.update(vo)) {
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addFlashAttribute("pageNum", criteria.getPageNum());
		rttr.addFlashAttribute("amount", criteria.getAmount());
		return "redirect:/board/list";
	} 
	
	@PostMapping("/remove")
	public String removeSubmit(BoardVO vo, RedirectAttributes rttr, Criteria criteria) {
		Long bno = vo.getBno();
		List<BoardAttachVO> list =  boardService.getAttachList(bno);
		if(boardService.remove(bno)) {
			deleteFiles(list);
			rttr.addFlashAttribute("result", "success");
		}
		/*
		 * rttr.addFlashAttribute("pageNum", criteria.getPageNum());
		 * rttr.addFlashAttribute("amount", criteria.getAmount()); return
		 * "redirect:/board/list";
		 */
		return "redirect:/board/list" + criteria.getListLink();
	}
	
	private void deleteFiles(List<BoardAttachVO> list) {
		if(list == null || list.size() == 0) {
			return;
		}
		for(BoardAttachVO vo : list) {
			try{
				Path file = Paths.get("c:\\upload\\" + vo.getUploadpath() +
			
					"\\" + vo.getUuid() + "_" + vo.getFilename());
			Files.deleteIfExists(file);
			if(Files.probeContentType(file).startsWith("image")) {
				Path thumbNail = Paths.get("c:\\upload\\" + vo.getUploadpath() +
						"\\s_" + vo.getUuid() + "_" + vo.getFilename());
				Files.delete(thumbNail);
				}
			} catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		}
		
	}


	@ResponseBody
	@GetMapping(value="/getAttachList/{bno}", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<BoardAttachVO>> getAttachList(@PathVariable("bno") Long bno) {
		List<BoardAttachVO> list =  boardService.getAttachList(bno);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
}
