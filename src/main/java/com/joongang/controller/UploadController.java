package com.joongang.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.joongang.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j2;
import net.coobird.thumbnailator.Thumbnailator;

@RestController
@Log4j2
public class UploadController {

	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (IOException e ) {
			e.printStackTrace();
		}
		return false;
	}
	
	@PostMapping(value="/uploadFileAjax", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<List<AttachFileDTO>> uploadFileAjax(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";
		
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			String uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name: " +uploadFolderPath);
			attachDTO.setFilename(uploadFileName);
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() +"_" + uploadFileName;
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadpath(uploadFolderPath);
				if (checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				list.add(attachDTO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@GetMapping(value="/display", produces=MediaType.IMAGE_JPEG_VALUE)
	public ResponseEntity<byte[]> getFile(String filename) {
		ResponseEntity<byte[]> result = null;
		File file = new File("c:\\upload\\" + filename);
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value="/pdfviewer", produces="application/pdf")
	public ResponseEntity<byte[]> openPdf(String filename) {
		ResponseEntity<byte[]> result = null;
		File file = new File("c:\\upload\\" + filename);
		try {
			HttpHeaders header = new HttpHeaders();
			header.setContentType(MediaType.APPLICATION_PDF);
			header.setContentDisposition(ContentDisposition.inline().build());
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value = "/downloadFile", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> downloadFile(String filename) {
		log.info("download file: " + filename);
		Resource resource = new FileSystemResource("c:\\upload\\" + filename);
		log.info("resource: " + resource);
		String resourceName = resource.getFilename();
		HttpHeaders headers = new HttpHeaders(); 
		try {
			headers.add(
				"Content-Disposition",  
				"attachment; filename=" + new String(
					resourceName.getBytes("UTF-8"), "ISO-8859-1")
			);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);


	}

	
	@DeleteMapping(value="/deleteFile", consumes="application/json")
	public ResponseEntity<String> remove(@RequestBody Map<String, String> param) throws UnsupportedEncodingException {
		String filename = param.get("filename");
		String type = param.get("type");
		try {
			File file = new File("c:\\upload\\" + URLDecoder.decode(filename, "utf-8"));
			file.delete();
			String original = file.getAbsolutePath().replace("s_", "");
			new File(original).delete();
		} catch (UnsupportedEncodingException e) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
}
