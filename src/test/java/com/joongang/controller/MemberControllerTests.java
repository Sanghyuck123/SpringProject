package com.joongang.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j2;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {com.joongang.config.RootConfig.class,
		com.joongang.config.ServletConfig.class,
		com.joongang.config.SecurityConfig.class })
@WebAppConfiguration
@Log4j2
public class MemberControllerTests {
		@Setter(onMethod_= {@Autowired})
		private WebApplicationContext context;
		
		private MockMvc mockMvc;
		
		@Before
		public void setup() {
			mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
		}
		
		@Test
		public void testMember() throws Exception {
			String resultPage =  mockMvc.perform(post("/member/signup")
					.param("userid", "b")
					.param("username", "b")
					.param("userpw", "b")
					.param("location", "b")
					.param("gender", "b")).andReturn().getModelAndView().getViewName();
			log.info(resultPage);
		}

}
