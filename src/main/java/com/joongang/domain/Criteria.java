package com.joongang.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class Criteria {
	private static final int app = 10;
	private int pageNum;
	private int amount;
	
	public Criteria() {
		this(1, app);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
		}
	
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNumb", this.pageNum)
				.queryParam("amount", this.getAmount());
		return builder.toUriString();
	}
}
