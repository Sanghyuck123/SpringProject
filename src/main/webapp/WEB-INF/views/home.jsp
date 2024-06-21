<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./includes/header.jsp" %>
<script>
$(function(){
	let msg = '${msg}'
	if (msg ==="") {
		return;
	}
	let txt;
	if (msg ==="logout") {
		txt="로그아웃 되었습니다.";
	}
	alert(txt);
})
</script>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>

<%@ include file="./includes/footer.jsp" %>