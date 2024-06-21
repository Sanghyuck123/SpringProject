<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="/resources/js/replyService.js" defer></script>
<script>
$(function(){
	getAttachList();
	let pageNum=1;
	getReplyList(pageNum);
	console.log("d" +"${auth.userid}");
	console.log("a" +"${get.writer}");
	const operForm = $("#operForm");
	$("#list_btn").on("click", function(e) {
		operForm.find("#bno").remove();
		operForm.attr("action","/board/list");
		operForm.submit();
	})
	
	$("#modify_btn").on("click", function(e) {
		operForm.attr("action","/board/modify").submit();
	})
	
	$("#reply_btn").on("click", function(e) {
		$("#reply").val("");
		$(".modal").modal('show');
		$("#modalCloseBtn").show();
		$("#modalRegisterBtn").show();
		$("#modalModBtn").hide();
	})
	
	$("#modalCloseBtn").on("click", function(e) {
		$(".modal").modal('hide');
	})
	
	
	$("#modalRegisterBtn").on("click", function(e) {
		
		let reply ={ reply: $("#reply").val(),
				replyer: $("#replyer").val(),
				bno : '<c:out value="${get.bno}"/>'
				};
		
		ReplyService.add(reply,
				function(result) {
				$(".modal").modal("hide");
				getReplyList(pageNum);
				},	
				function (error){
					alert(error);
				})
	})
	
	$(".panel-footer").on("click", 'li a', function(e) {
		e.preventDefault(); 
		pageNum=$(this).attr("href");
		getReplyList(pageNum);
		console.log($(this).attr("href"))
	});
	
	
	/* function getReplyList() {
		let param ={bno : '<c:out value="${get.bno}"/>'};
		ReplyService.getList(param,
			function(list) {
			
			let str = "";
			let replyUL = $('.reply-list');
			let values = Object.values(list);
			
			for (let i = 0; i < values.length; i++) {
				str += '<li>'
					str += '<div>'
						str += '<div>'
							str += '<strong>'+ values[i].replyer+ '</strong>'
							str += '<small>'+ReplyService.displayTime(values[i].regdate)+'</small>'
						str += '</div>'
						str += "<div data-rno='" + values[i].rno + "' data-replyer='" + values[i].replyer + "'>"; 
							str += '<strong id="modify">'+values[i].reply+'</strong>'
							if("${auth.userid}" ===values[i].replyer) {
								str += '<button type="button" id="reply-remove" data-rno="' + values[i].rno + '">'
									str += '<span>X</span>'
								str += '</button>'
							}
						str += '</div>'
					str += '</div>'
				str += '</li>'	
			}
			replyUL.html(str);
			},
			function(error) {
				alert(errors)
			});
	} */
	function getAtList(param, callback, error) {
        $.getJSON("/board/getAttachList/"+param.bno , function(data){
            callback(data);
            console.log(data);
        }).fail(function(xhr, status, er){
        })
        
    }
	
	function getAttachList() {
 		let str = "";
		let attachUL = $('.get-Result');
 		let param ={bno : '<c:out value="${get.bno}"/>'};
 		getAtList(param,
 				function(result) {
					$(result).each(function (i,obj){
						console.log(obj.filename)
						console.log(obj.filetype)
						if (obj.filetype ==true) {
							let fileCallPath = encodeURIComponent(obj.uploadpath + "\\s_" + obj.uuid + "_" + obj.filename);
							str +="<li data-path='" + obj.uploadpath + "'";
							str +="	   data-uuid='" + obj.uuid + "'data-filename='" + obj.filename + "'data-type='" + obj.filetype + "'>";
							str +="    <div>";
							str +='       <span>'+obj.filename+ '</span>'
							str +="    </div>"
							str +="       <img src='/display?filename=" + fileCallPath + "'/>";
							str +="</li>"
						} else {
							let fileCallPath = encodeURIComponent(obj.uploadpath + "\\" + obj.uuid + "_" + obj.filename);
							str +="<li data-path='" + obj.uploadpath + "'";
							str +="	   data-uuid='" + obj.uuid + "'data-filename='" + obj.filename + "'data-type='" + obj.filetype + "'>";
							str +="    <div>";
							str +='       <span>'+obj.filename+ '</span>'
							str +="    </div>"
							str +="       <img src='/resources/img/attach.png'>";
							str +="</li>"
						}
					})
					console.log(str);
			 		attachUL.append(str);	
 				},
			function(error) {
				alert(errors)
			});
	}
	function showImage(fileCallPath){
		$('.bigPictureWrapper').css('display', 'flex').show();
		$('.bigPicture').html('<img src="/display?filename='+fileCallPath+'">').animate({width:'100%', top:'0'}, 600);
	}
	
	$('.get-Result').on('click', 'li ', function() {
		let file = $(this).data("filename");
		let uuid = $(this).data("uuid");
		let uploadpath = $(this).data("path");
		let fileCallPath =  encodeURIComponent(uploadpath + "\\" + uuid + "_" + file);
		if($(this).data("type")) {
			showImage(fileCallPath);
		} else {
			if (fileCallPath.toLowerCase().endsWith('pdf')){
				window.open("/pdfviewer?filename="+fileCallPath);
			} else {
				self.location = "/downloadFile?filename="+fileCallPath;
			}
		}
	})
	
 	$(".bigPictureWrapper").on("click", function(e){
 		$(".bigPictureWrapper").hide()
 		$(".bigPicture").css("top", "15%")
 	})
 	
	 function getReplyList(pageNum) {
		let param ={bno : '<c:out value="${get.bno}"/>',
				page : pageNum};
		
		ReplyService.getListWithPaging(param,
			function(dto) {
			let replyCnt = dto.replyCnt
			console.log(dto);
			
			let str = "";
			let replyUL = $('.reply-list');
			let val = dto.list;
			
			
			for (let i = 0; i < val.length; i++) {
				str += '<li>'
					str += '<div>'
						str += '<div>'
							str += '<strong>'+ val[i].replyer+ '</strong>'
							str += '<small>'+ReplyService.displayTime(val[i].regdate)+'</small>'
						str += '</div>'
						str += "<div data-rno='" + val[i].rno + "' data-replyer='" + val[i].replyer + "'>"; 
							str += '<strong id="modify">'+val[i].reply+'</strong>'
							if("${auth.userid}" ===val[i].replyer) {
								str += '<button type="button" id="reply-remove" data-rno="' + val[i].rno + '">'
									str += '<span>X</span>'
								str += '</button>'
							}
						str += '</div>'
					str += '</div>'
				str += '</li>'	
				}
			replyUL.html(str);
			showReplyPaging(replyCnt)
			},
			function(error) {
				alert(errors)
			});
			
	} 
 	function showReplyPaging(replyCnt) {
 		console.log(pageNum);
		let endNum = Math.ceil(pageNum/10.0) * 10;
		let startNum = endNum -9;
		let prev = (startNum !=1);
		let next = false;
		let str = "";
		let replyPageFooter = $('.panel-footer');
		if (endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt/10.0);
		}
		if (endNum * 10 < replyCnt) {
			next = true;
		}
		str += '<ul class="page_ul-g" id="reply-page">'
		if(prev == true) {
			str += '  <li>'
				str += '     <a href="'+(startNum -1) +'">Prev</a>'
			str += '  </li>'
		}
		for (let i = startNum; i <= endNum; i++) {
	        str += '<li>';
	        str += '<a class="page-link ' + (pageNum == i ? 'active' : '') + '" href="' + i + '">' + i + '</a>';
	        str += '</li>';
	    }
		if(next == true) {
			str += '  <li>'
				str += '     <a href="'+(endNum  +1) +'">Next</a>'
			str += '  </li>'
		}
		replyPageFooter.html(str);
	}  
	
	
	$('.reply-list').on('click', 'li #modify', function() {
		let rno = $(this).parent().data("rno")
		let replyer = $(this).parent().data("replyer")
		let userid ='<c:out value="${auth.userid}"/>'
		if(userid !=replyer) {
			return
		}
		console.log(rno);
		ReplyService.get(rno,
			function(data) {
				console.log(data.rno)
				$("#reply").val(data.reply);
				$("#replyer").val(data.replyer)
				$(".modal").data("rno",data.rno)
				$("#modalModBtn").show();
				
			},	
			function (error){
				alert(error);
		})
		$(".modal").modal('show');
		$("#modalRegisterBtn").hide();
		
	})
	
	$("#modalModBtn").on("click", function(e) {
			let reply ={ reply: $("#reply").val(),
					rno : $(".modal").data("rno")
					};
			console.log(reply)
			ReplyService.modify(reply,
					function(result) {
					$(".modal").modal("hide");
					getReplyList(pageNum);
					alert(result);
					},	
					function (error){
						alert(error);
					})
	})
		
	
	$('.reply-list').on('click', 'li #reply-remove', function() {
		let rno = $(this).data("rno")
		ReplyService.remove(rno,
				function(result) {
				getReplyList(pageNum);
				alert(result)
				},	
				function (error){
					alert(error);
				})
	})
	
	
})
</script>
<h2> 게시글 읽기</h2>
<table class="table">
	<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>수정된 날짜</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>${get.bno}</td>
			<td>${get.title}</td>
			<td>${get.writer}</td>
			<td><fmt:formatDate pattern="YY-MM-dd hh:mm" value="${get.regdate}"/></td>
			<td><fmt:formatDate pattern="YY-MM-dd hh:mm" value="${get.updatedate}"/></td>
		</tr>
	</tbody>
</table>
<div>
	<textarea rows="10" cols="80" readonly="readonly">${get.content}</textarea>
</div>
<div>
	<div>
		<label><b>첨부파일</b></label>
	</div>
	<div>
		<ul class="get-Result"></ul>
	</div>
</div>
<div class="read_botton">
	<button class="read_button" id="list_btn">목록</button>
	<c:if test="${auth.userid eq get.writer}">
	<button class="read_button" id="modify_btn">수정</button>
	</c:if>
	<form id="operForm" action="/board/modify" method="get">
		<input type='hidden' id='bno' name='bno' value='<c:out value="${get.bno}"/>'>
		<input type='hidden' name='pageNum' value='${pageDTO.criteria.pageNum}'>
		<input type='hidden' name='amount' value='${pageDTO.criteria.amount}'>
	</form>
</div>
<div class="reply">
	<c:if test="${not empty auth}">
		<button class="reply_button" id="reply_btn" >댓글작성</button>
	</c:if>
</div>
<div>
	<h3>댓글 목록</h3>
</div>
<ul class="reply-list"></ul>
<div class="panel-footer"></div>
<div class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">REPLY MODAL</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" id="reply" name='reply'> 
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" id="replyer" name='replyer' value="${auth.userid}" readonly="readonly"> 
				</div>
			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				<button id='modalCloseBtn' type="button" class="btn btn-info">Close</button>
			</div>
		</div>
	</div>
</div>

<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

<%@ include file="../includes/footer.jsp" %>