package org.zerock.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebConfig extends
	AbstractAnnotationConfigDispatcherServletInitializer {
	// web.xml을 대신하는 클래스

	@Override
	protected Class<?>[] getRootConfigClasses() {	// 'root-context.xml' 대신하는 클래스
		return new Class[] {RootConfig.class};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return null;
	}

	@Override
	protected String[] getServletMappings() {
		return null;
	}

}
