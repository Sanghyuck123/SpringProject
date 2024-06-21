<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>

<script>
$(function(){
	let formObj = $("form");
	$('.submit-btn').on("click", function(e) {
		e.preventDefault();
		let str = "";
		formObj.attr("action", "/board/register").attr("method", "post");
		$('.uploadResult').children().each(function(index,value){
			console.log($(value).data("filename"))
			str +="<input type='hidden' name='attachList["+index+"].filename' value='"+  $(value).data("filename") +"'>"
			str +="<input type='hidden' name='attachList["+index+"].uploadpath' value='"+  $(value).data("path") +"'>"
			str +="<input type='hidden' name='attachList["+index+"].uuid' value='"+  $(value).data("uuid") +"'>"
			str +="<input type='hidden' name='attachList["+index+"].filetype' value='"+  $(value).data("type") +"'>"
		})
		console.log(str);
		formObj.append(str);
		if(isValid()) {
			formObj.submit();
		}
		
	})
	
	function isValid() {
		let baord_name = $('#baord_name').val();
		let baord_content = $('#baord_content').val();
		
		if (baord_name == "") {
			$('baord_name').focus();
			$('#warning1').css('display','block');
			$('#warning1').attr('style','color: crimson');
			return false;
		}
		if (baord_content == "") {
			$('baord_name').focus();
			$('#warning2').css('display','block');
			$('#warning2').attr('style','color: crimson');
			return false;
		} 
		return true;
		
	}
	
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
		let uploadUL = $('.uploadResult');
		
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
	
	$('.uploadResult').on('click', 'li #upload-remove', function() {
		let file = $(this).data("file");
		console.log(file);
		let type = $(this).data("type");
		let jObject = {filename: file, type: type};
		let target = $(this).parent().closest('li').remove();
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

})
</script>

<div id="board_description">
	<h2>게시판 작성 화면 입니다</h2>
</div>
<form action="/board/register" class="signup" method="post">
	<div>
		<input type="text"  id ='baord_name' name="title" class="register-input" placeholder="제목">
	</div>
	<div id='warning1' style="display:none">
			<span>제목을 입력해주세요.</span>
	</div>
	<div>
		<input type="email"  id ='userid' name="writer" value="${auth.userid}">
	</div>
	<div>
		<textarea rows="10" cols="80" id ='baord_content' name="content" class="register-input" placeholder="내용"></textarea>
	</div>
	<div id='warning2' style="display:none">
			<span>내용을 입력해주세요.</span>
	</div>
	<div>
		<button class="submit-btn">작성</button>
		<input type="reset" id="reset" value="reset">
	</div>
	<div>
		<div>
			<label><b>첨부파일</b></label>
		</div>
		<div id="upload-button">
			<input type="file" name="uploadFile" id="uploadFile" class="file-input" multiple />
		</div>
		<div>
			<ul class="uploadResult"></ul>
		</div>
	</div>
	
</form>
<%@ include file="../includes/footer.jsp" %>
