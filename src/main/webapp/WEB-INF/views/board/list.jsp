<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script>
$(function(){
	$(".get").on('click',function(e){
		e.preventDefault(); 
		let form = $('<form></form>');
		form.attr('method', 'get');
		form.attr('action', '/board/get');
		form.append("<input type='hidden' name='bno' value='" + $(this).attr("href") +"'>");
		form.append("<input type='hidden' name='pageNum' value='${pageDTO.criteria.pageNum}'>");
		form.append("<input type='hidden' name='amount' value='${pageDTO.criteria.amount}'>");
		form.appendTo('body')
		form.submit();  	
	})
	let result = '<c:out value="${result}"/>';
	if(result !='')  {
		if (result =='success') {
			result = "처리가 완료되었습니다."
			alert(result);
		} else {
			result += "번 글이 등록되었습니다."
			alert(result);
		}
	}
	
	/* let actionForm = $("#actionForm");
	$(".page-item a").on("click", function(e) {
	e.preventDefault(); 
	actionForm.find("input[name='pageNum']")
		.val($(this).attr("href"));
	actionForm.submit();
	}); */
	
	let list = new Array();
	<c:forEach items="${List}" var="board">
		list.push(<c:out value="${board.bno}"/>);
	</c:forEach>
	$.getJSON("/replies/cnt", {list: list}, function(data){
		let keys = Object.keys(data);
		$(keys).each(function(i,bno){
			let replyCnt = data[bno];
			let text = $("a[name="+bno+"]").text().trim() + "[" + replyCnt + "]";
			$("a[name="+bno+"]").text(text)
		})
	})
	
	$(".page-item a").on("click", function(e) {
		e.preventDefault(); 
		let pageForm = $('<form></form>');
		pageForm.attr('method', 'get');
		pageForm.attr('action', '/board/list');
		pageForm.append("<input type='hidden' name='pageNum' value='" + $(this).attr("href") +"'>");
		pageForm.append("<input type='hidden' name='amount' value='${pageDTO.criteria.amount}'>");
		pageForm.appendTo('body')
		pageForm.submit();
	});
	console.log("${pageDTO.prev}" +"D" + "${pageDTO.next}")

})
</script>
<table class="table">
	<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>첨부파일</th>
			<th>작성일</th>
		</tr>
	</thead>
	<c:forEach var="item" items="${List}" varStatus="status">
		<tr>
			<td>${item.bno}</td>
			<td>
				<a class="get" href='<c:out value="${item.bno}"/>' name='<c:out value="${item.bno}"/>'>
					<c:out value="${item.title}"/>
				</a>
			</td>
			<td>${item.writer}</td>
			<td></td>
			<td>
				<c:choose>
					<c:when test="${item.regdate} == ${item.updatedate}">
						<fmt:formatDate pattern="YY-MM-dd hh:mm" value="${item.regdate}"/>
					</c:when>
					<c:otherwise>
						<fmt:formatDate pattern="YY-MM-dd hh:mm" value="${item.updatedate}"/>
					</c:otherwise>
				</c:choose>
			 </td>
		</tr>
	</c:forEach>
</table>
<div>
	<ul class="page_ul">
		<c:if test="${pageDTO.prev}">
			<li class="page-item prev">
				<a href="${pageDTO.startPage-1}">Prev</a>
			</li>
		</c:if>
		<c:forEach var="num" begin="${pageDTO.startPage }" end="${pageDTO.endPage }">
            <li class="page-item ${pageDTO.criteria.pageNum == num ? 'active':''}">
                <a class="page_a" href="${num }">${num }</a>
            </li>
        </c:forEach>
        <c:if test="${pageDTO.next}">
			<li class="page-item next">
				<a href="${pageDTO.endPage+1}">Next</a>
			</li>
		</c:if>
	</ul>
</div>
<%-- <form id='actionForm' action="/board/list" method='get'>
	<input type='hidden' name='pageNum' value='${pageDTO.criteria.pageNum}'>
	<input type='hidden' name='amount' value='${pageDTO.criteria.amount}'>
</form> --%>
<form action="/board/register" class="login_form" method="get">
		<div class="form_write_button">
			<input id="write_button" type="submit" value="글쓰기"/>
		</div>
</form>
<%@ include file="../includes/footer.jsp" %>
