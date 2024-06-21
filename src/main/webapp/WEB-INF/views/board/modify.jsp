<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<script>
$(function(){
	let regex = new RegExp("(.*)\.(exe|zip|alz)$");
	let maxSize = 5*1024*1024;
	function checkExtension(filename, fileSize) {
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과")
			return false;
		}
		if (regex.test(filename)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.")
			return false;
		}
		return true;
	}
	
	$("#uploadFile").on("change", function(e){
		let formData = new FormData();
		let inputFile = $("#uploadFile");
		let files = inputFile[0].files;
		for (let i = 0; i < files.length; i++) {
			if(!checkExtension(files[i].name, files[i].uuid)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		$.ajax({
			type: 'post',
			url:'/uploadFileAjax',
			processData: false,
			contentType: false,
			data: formData,
			success: function(result) {
				 showUploadResult(result); 
			}
		})
	})
	
	function showUploadResult(result) {
		if(!result || result.length == 0) {return;}
		let str = "";
		let uploadUL = $('.get-Result');
		
		/* for (let i = 0; i < result.length; i++) {
			 str += '<li>'
				str += '<div>'
						str += '<span>'+ result[i].filename+ '</span>'
						str += '<img src="/resources/img/attach.png">'
				str += '</div>'
			str += '</li>'	
		} */
		$(result).each(function (i,obj){
			if (obj.image) {
				let fileCallPath = encodeURIComponent(obj.uploadpath + "\\s_" + obj.uuid + "_" + obj.filename);
				str +="<li data-path='" + obj.uploadpath + "'";
				str +="	   data-uuid='" + obj.uuid + "'data-filename='" + obj.filename + "'data-type='" + obj.image + "'>";
				str +="    <div>";
				str += '<span>'+obj.filename+ '</span>'
				str +="         <button id='upload-remove' type='button' data-file=\'" + fileCallPath + "\'";
				str +="             data-type='image'>";
				str +="         	<span>X</span>";
				str +='         </button><br>'
				str +="         <img src='/display?filename=" + fileCallPath + "'/>";
				str +="    </div>"
				str +="</li>"
			} else {
				let fileCallPath = encodeURIComponent(obj.uploadpath + "\\" + obj.uuid + "_" + obj.filename);
				str +="<li data-path='" + obj.uploadpath + "'";
				str +="	   data-uuid='" + obj.uuid + "'data-filename='" + obj.filename + "'data-type='" + obj.image + "'>";
				str +="    <div>";
				str +='    <span>'+obj.filename+ '</span>'
				str +="         <button id='upload-remove' type='button' data-file=\'" + fileCallPath + "\'";
				str +="             data-type='image'>";
				str +="         <span>X</span>";
				str +='         </button><br>'
				str +="         <img src='/resources/img/attach.png'>";
				str +="    </div>"
				str +="</li>"
			}
		})
		uploadUL.append(str);  
	}
	
	getAttachList()
	let formObj = $("form");
	$('button').on("click", function(e) {
		e.preventDefault();
		let operation = $(this).data("oper");
		console.log(operation);
		if(operation ==='remove') {
			formObj.attr("action", "/board/remove");
		} else if(operation ==='list') {
			let pageNumTag = $("input[name='pageNum']").clone();
			let amountTag = $("input[name='amount']").clone();
			formObj.empty();
			formObj.attr("action", "/board/list").attr("method", "get");
			formObj.append(pageNumTag);
			formObj.append(amountTag);
		} else if(operation ==='modify') {
			let str = "";
			$('.get-Result').children().each(function(index,value){
				console.log($(value).data("filename"))
				str +="<input type='hidden' name='attachList["+index+"].filename' value='"+  $(value).data("filename") +"'>"
				str +="<input type='hidden' name='attachList["+index+"].uploadpath' value='"+  $(value).data("path") +"'>"
				str +="<input type='hidden' name='attachList["+index+"].uuid' value='"+  $(value).data("uuid") +"'>"
				str +="<input type='hidden' name='attachList["+index+"].filetype' value='"+  $(value).data("type") +"'>"
			})
			console.log(str);
			formObj.append(str);
		}
		formObj.submit();
	})
	
	
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
							str +="         <button id='upload-remove' type='button' data-file=\'" + fileCallPath + "\'";
							str +="             data-type='image'>";
							str +="         	<span>X</span>";
							str +='         </button><br>'
							str +="       <img src='/display?filename=" + fileCallPath + "'/>";
							str +="    </div>"
							str +="</li>"
						} else {
							let fileCallPath = encodeURIComponent(obj.uploadpath + "\\" + obj.uuid + "_" + obj.filename);
							str +="<li data-path='" + obj.uploadpath + "'";
							str +="	   data-uuid='" + obj.uuid + "'data-filename='" + obj.filename + "'data-type='" + obj.filetype + "'>";
							str +="    <div>";
							str +='       <span>'+obj.filename+ '</span>'
							str +="         <button id='upload-remove' type='button' data-file=\'" + fileCallPath + "\'";
							str +="             data-type='image'>";
							str +="         	<span>X</span>";
							str +='         </button><br>'
							str +="       <img src='/resources/img/attach.png'>";
							str +="    </div>"
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
	
	$('.get-Result').on('click', 'li #upload-remove', function() {
		let file = $(this).data("file");
		let type = $(this).data("type");
		let jObject = {filename: file, type: type};
		mod(jObject);
		let target = $(this).parent().closest('li').remove();
	})
	function mod(jObject){
		$('#modbtn').on('click', function(){
			$.ajax({
	            type:"delete",
	            url:"/deleteFile",
	            data : JSON.stringify(jObject),
	            contentType: "application/json; charset=utf-8",
	            success:function(result){
	                alert(result);
	                target.remove();
	            }
	        })
		})
	}
	
	
})
</script>
<h2> 게시글 수정화면 입니다.</h2>
<form id="operForm" action="/board/modify" method="post">
	<input type='hidden' name='pageNum' value='${pageDTO.criteria.pageNum}'>
	<input type='hidden' name='amount' value='${pageDTO.criteria.amount}'>
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
			<td><input name="bno" value='<c:out value="${get.bno}"/>' readonly="readonly"></td>
			<td><input name="title" value='<c:out value="${get.title}"/>'></td>
			<td><input name="writer" value='<c:out value="${get.writer}"/>' readonly="readonly"></td>
			<td><fmt:formatDate pattern="YY-MM-dd hh:mm" value="${get.regdate}"/></td>
			<td><fmt:formatDate pattern="YY-MM-dd hh:mm" value="${get.updatedate}"/></td>
		</tr>
	</tbody>
</table>
<div>
	<textarea rows="10" cols="80" name="content">${get.content}</textarea>
</div>
<div>
	<div>
		<label><b>첨부파일</b></label>
	</div>
	<div id="upload-button">
		<input type="file" name="uploadFile" id="uploadFile" class="file-input" multiple />
	</div>
	<div>
		<ul class="get-Result"></ul>
	</div>
</div>
<div class="modify_botton">
	<button class="read_button" data-oper="modify" id="modbtn">수정</button>
	<button class="read_button" data-oper="remove">삭제</button>
	<button class="read_button" data-oper="list">목록</button>
</div>
</form>
<%@ include file="../includes/footer.jsp" %>