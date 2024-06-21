package com.joongang.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class MemberVO {
	private String userid;
	private String username;
	private String userpw;
	private String location;
	private String gender;
	private Timestamp regdate;
	private Timestamp updatedate;
	
	public MemberVO() {
		
	}
	public MemberVO (String userid, String username, String userpw, String location, String gender) {
		this.userid = userid;
		this.username = username;
		this.userpw = userpw;
		this.location = location;
		this.gender = gender;
	}
}
