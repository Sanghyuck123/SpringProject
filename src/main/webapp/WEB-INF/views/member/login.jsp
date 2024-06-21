<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script>
$(function(){
	 $('#login_button').click(function(e){
		e.preventDefault();
	 	if(isValid()) {
			$('form').submit();
		}
	})
	
	function isValid() {
		let userid = $('#userid').val();
		let userpw = $('#userpw').val();
		
		if (userid == "") {
			$('userid').focus();
			$('#warning1').css('display','block');
			$('#warning1').attr('style','color: crimson');
			return false;
		}
		if (userpw == "") {
			$('#warning2').css('display','block');
			$('#warning2').attr('style','color: crimson');
			return false;
		} 
		return true;
		
	}
	 
	let error = '${error}';
	if (error ==="") {
		return true;
	}
	if (error === "nonuser") {
		$("#userid").focus();
	} else {
		$("#userpw").focus();
	}
	let msg = (error ==="nonuser") ? "존재하지 않는 Email입니다" :"비밀번호가 일치하지 않습니다";
	alert(msg);
})
</script>
<div class="login-wrapper">
	<form action="/member/login" class="login_form" method="post">
		<div class="form_id">
			<input type="email" class="login-e" id="userid" name="userid" placeholder="E-mail을 입력하세요" value="${memberVO.userid}"/>
			<div id='warning1' style="display:none">
				<span>아이디를 입력해주세요.</span>
			</div>
		</div>
		<div class="form_pw">
			<input type="password" class="login-e" id="userpw" name="userpw" placeholder="비밀번호를 입력하세요"/>
			<div id='warning2' style="display:none">
				<span>비밀번호를 입력해주세요.</span>
			</div>
		</div>
		<div class="form_login_button">
			<input class="login-e" id="login_button" type="submit" value="login"/>
		</div>
	</form>
</div>

<%@ include file="../includes/footer.jsp" %>