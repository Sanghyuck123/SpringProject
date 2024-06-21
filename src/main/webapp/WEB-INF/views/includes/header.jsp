<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<link href="/resources/css/headfoot.css" rel="stylesheet" type="text/css">
<link href="/resources/css/main.css" rel="stylesheet" type="text/css">
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
</script>
<title>Insert title here</title>

</head>
<body>
	<div>
		<div class="one">
  			<h1>Spring project</h1>
		</div>
		<nav class="menu">
			<a href="/board/list"><span id="menu-item">게시판</span></a>
			<a href="/member/signup"><span id="menu-item">회원가입</span></a>
			<c:choose>
				<c:when test="${not empty auth}">
					<a href="/member/logout"><span id="menu-item">로그아웃</span></a>
					<div>
						<span id="menu-username">${auth.username}님 접속중</span>
					</div>
				</c:when>
				<c:otherwise>
					<a href="/member/login"><span id="menu-item">로그인</span></a>
				</c:otherwise>
			</c:choose>
		</nav>
	</div>