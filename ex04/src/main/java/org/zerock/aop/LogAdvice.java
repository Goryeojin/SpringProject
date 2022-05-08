package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	@Before("execution(* org.zerock.service.SampleService*.*(..))")	// 어떤 위치에 Advice를 적용할 것인지 결정하는 Pointcut임.
	// @Before 내부는 AspectJ의 표현식(expression)이다.
	// execution의 경우 접근제한자와 특정 클래스의 메소드를 지정할 수 있다.
	// 맨 앞 *는 접근제한자, 맨 뒤 *는 클래스의 이름과 메소드를 의미한다.
	public void logBefore() {
		
		log.info("====================");
	}
	
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		
		log.info("str1 : " + str1);
		log.info("str2 : " + str2);
	}
	
	// 지정된 대상이 예외를 발생한 후 동작하며 문제를 찾도록 도와줌.
	@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		
		log.info("Exception...!!!!!!!");
		log.info("exception : " + exception);
	}
	
	// 직접 대상 메소드를 샐힝할 수 있고, 메소드의 실행 전과 실행 후에 처리가 가능하다.
	// ProceedingJoinPoint는 @Around와 같이 결합해 파라미터나 예외 등을 처리할 수 있다.
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		
		// pointcut 설정은 ...SampleService*.*(..)로 지정
		// ProceedingJoinPoint는 AOP의 대상이 되는 Target이나 파라미터 파악, 또는 직접 실행 결정할 수도 있음.
		
		// @Around가 적용되는 메소드의 경우 리턴 타입이 void가 아닌 타입으로 설정. 실행 결과도 직접 반환하는 형태로 작성.
		
		long start = System.currentTimeMillis();
		
		log.info("Target : " + pjp.getTarget());
		log.info("Param : " + Arrays.toString(pjp.getArgs()));
		
		// invoke method
		Object result = null;
		
		try {
			result = pjp.proceed();
		} catch(Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("Time : " + (end - start));
		
		return result;
	}

}
