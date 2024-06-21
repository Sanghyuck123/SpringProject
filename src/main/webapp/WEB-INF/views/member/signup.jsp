<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<script src="/resources/js/test.js" defer></script>
<script>
$(function(){
	console.log("abc")
	$(".telnum").keyup(function(){
		if(this.value.length == this.maxLength) {
			$(this).next(".telnum").focus();
			console.log(parseInt($('#firstphonenum').attr('maxlength')));
			if($('#firstphonenum').val().length === parseInt($('#firstphonenum').attr('maxlength'))&&
					$('#secondphonenum').val().length === parseInt($('#secondphonenum').attr('maxlength'))&&
					$('#thirdphonenum').val().length === parseInt($('#thirdphonenum').attr('maxlength'))) {
				$('#send').attr('disabled', false);
				$('#send').attr('style', "background-color: #FFFFFF; color : #0068FF; cursor:pointer;");
			}
		}
	})
	
	
	
	let timer = new Timer();
	$("#send").on("click", function(e){
	 	timer.getToken($("#token"), $("#send"),$("#finished"),$("#timer")); 
	})
	$("#finished").on("click", function(e){
	 	timer.getTimerIntervalConfirm($("#finished"),$("#signup")); 
	})
	
	
	$('#signup').click(function(e){
		e.preventDefault();
		if(isValid()) {
			$('form').submit();
		}
	})
	
	function isValid() {
		let userid = $('#userid').val();
		console.log(userid);
		let username = $('#username').val();
		let userpw = $('#userpw').val();
		let cfuserpw = $('#cfuserpw').val();
		let location = $('#location').val();
		let gender_woman = $('#gender_woman').is(':checked');
		let gender_man = $('#gender_man').is(':checked');
		let gender = $('input[name=gender]').is(":checked");
		console.log(gender);
		let regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
		if (regExp.test(userid) === false) {
			$('userid').focus();
			$('#warning1').css('display','block');
			$('#warning1').attr('style','color: crimson');
			return false;
		}
		if (userpw != cfuserpw) {
			$('#warning2').css('display','block');
			$('#warning2').attr('style','color: crimson');
			return false;
		} if (location == null) {
			$('#warning3').css('display','block');
			$('#warning3').attr('style','color: crimson');
			return false;
		} if (gender === false ) {
			$('#warning4').css('display','block');
			$('#warning4').attr('style','color: crimson');
			return false;
		} else {
			return true
		}
		
	}
	
	
})
</script>
<div class="signup-wrapper">
<form action="/member/signup" class="signup" method="post">
	<div>
		<input type="email"  id ='userid' name="userid" class="signup-input" placeholder="이메일을 입력해주세요">
	</div>
	<div id='warning1' style="display:none">
		<span >이메일이 올바르지 않습니다</span>
	</div>
	<div>
		<input type="text"  id="username" name="username" class="signup-input" placeholder="이름을 입력해주세요">
	</div>
	<div>
	<input type="password"  id="userpw" name="userpw" class="signup-input" placeholder="비밀번호를 입력해주세요">
	</div>
	<div>
	<input type="password"  id="cfuserpw" class="signup-input" placeholder="비밀번호를 다시 입력해주세요">
	</div>
		<div id='warning2' style="display:none">
		<span>비밀번호가 일치하지 않습니다.</span>
	</div>
	<p>
		<input type="text"  id="firstphonenum" class="telnum" maxlength=3> -
		<input type="text"  id="secondphonenum" class="telnum" maxlength=4> -
		<input type="text"  id="thirdphonenum" class="telnum" maxlength=4>
	</p>
	<!-- <div>
		<span id="ranNum">000000</span><button type="button" class="signup-btn" id='cfnum' disabled>인증번호 전송</button>
	</div>
	<div>
		<span id="timer">3:00</span><button type="button" class="signup-btn" id='cfc' disabled>인증완료</button>
	</div> -->
	<div>
		<span id="token">000000</span><button type="button" class="signup-btn" id='send' disabled>인증번호 전송</button>
	</div>
	<div>
		<span id="timer">3:00</span><button type="button" class="signup-btn" id='finished' disabled>인증완료</button>
	</div>
	<div>
		<select id="location" name="location" class="signup-input" >
			<option disabled="disabled" selected="true">지역을 선택하세요</option>
            <option value='서울'>서울</option>
            <option value='부산'>부산</option>
            <option value='대구'>대구</option>
            <option value='인천'>인천</option>
            <option value='광주'>광주</option>
            <option value='대전'>대전</option>
            <option value='울산'>울산</option>
            <option value='강원'>강원</option>
            <option value='경기'>경기</option>
            <option value='경남'>경남</option>
            <option value='경북'>경북</option>
            <option value='전남'>전남</option>
            <option value='전북'>전북</option>
            <option value='제주'>제주</option>
            <option value='충남'>충남</option>
            <option value='충북'>충북</option>
		</select>
	</div>
	<div id='warning3' style="display:none">
		<span>지역을 선택하세요.</span>
	</div>
	<div>
		<input type='radio' id='gender_woman' name="gender" value='female'/>여성
		<input type='radio' id='gender_man' name="gender" value='male'/>남성
	</div>
	<div id='warning4' style="display:none">
		<span>성별을 선택하세요.</span>
	</div>
	<div>
		<input type="submit" id="signup" value="가입하기" disabled>
	</div>
</form>
</div>
<%@ include file="../includes/footer.jsp" %>
