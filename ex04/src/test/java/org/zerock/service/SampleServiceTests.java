package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class SampleServiceTests {
	
	@Setter(onMethod_ = @Autowired)
	private SampleService service;
	
	/*
	@Test
	public void testClass() {
		
		log.info(service);	// 결과는 기존 SampleServiceImpl 클래스의 인스턴트 처럼 보임.
							// 그러나 이것은 toString()의 결과이므로 좀 더 세밀하게 파악하려면
		log.info(service.getClass().getName());	// getClass()를 이용해 파악한다.
		// com.sun.proxy.$Proxy20
		// JDK의 다이나믹 프록시(dynamic Proxy)기법 적용
	}
	*/
	@Test
	public void testAdd() throws Exception {
		
		log.info(service.doAdd("123", "456"));
	}
	/*
	@Test
	public void testAddError() throws Exception {
		
		log.info(service.doAdd("123", "ABC"));
	}
	*/
}
