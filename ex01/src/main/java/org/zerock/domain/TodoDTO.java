package org.zerock.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class TodoDTO {
	
	private String title;
	
	// @DateTimeFormat을 이용해 문자열로 들어온 데이터를 날짜 타입으로 변환하기
	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date dueDate;

}
