package org.zerock.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class SampleDTOList {
	
	// SampleDTO 객체를 여러 개를 처리하기 위해  SampleDTO의 리스트를 포함하는 클래스 설계
	private List<SampleDTO> list;
	
	public SampleDTOList() {
		list = new ArrayList<>();
	}

}
