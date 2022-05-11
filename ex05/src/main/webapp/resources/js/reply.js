/**
 * JavaScript의 모듈화 - 모듈 패턴 사용(JavaScript Source File)
 * 관련 있는 함수들을 하나의 모듈처럼 묶음으로 구성하는 것을 의미
 * Java의 클래스처럼 JavaScript를 이용해 메소드를 가지는 객체 구성.
 * JavaScript의 즉시 실행함수와 '{}'를 이용해 객체 구성.
 * 
 * 즉시 실행함수는 () 안에 함수를 선언하고 바깥쪽에서 실행한다.
 * 함수의 실행 결과가 바깥쪽에 선언된 변수에 할당된다.
 * 
 */
 
console.log("Reply Module.........");
 
var replyService = (function(){
 
	function add(reply, callback, error){	// 파라미터로 callback, error를 함수로 받아옴.
		console.log("add reply...............");

		$.ajax({
			type : 'post',
			url : '/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",	// 데이터 전송 타입
			success : function(result, status, xhr){
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}

	function getList(param, callback, error) {
		// console.log("reply.js getList 실행");
		var bno = param.bno;
		var page = param.page || 1;

		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",	// JSON 형태가 필요하므로 URL 호출시 확장자 .json으로 요구
			function(data) {
				if(callback) {
					// callback(data);	// 댓글 목록만 가져오는 경우
					callback(data.replyCnt, data.list);	// 댓글 수와 목록을 가져오는 경우
				}
			}).fail(function(xhr, status, err) {
				if(error) {
					error();
				}
			});
	}

	function remove(rno, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			success : function(deleteResult, status, xhr) {
				if(callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}

	function update(reply, callback, error) {

		console.log("RNO : " + reply.rno);

		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, er) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		})
	}

	function get(rno, callback, error) {

		$.get("/replies/" + rno + ".json", function(result) {

			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}

	function displayTime(timeValue) {
		
		var today = new Date();

		var gap = today.getTime() - timeValue;

		var dateObj = new Date(timeValue);
		var str = "";

		if(gap < (1000 * 60 * 60 * 24)) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();

			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi,
				':', (ss > 9 ? '' : '0') + ss].join('');
		}
		else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;	// getMonth() is zero-based
			var dd = dateObj.getDate();

			return [yy, '/', (mm > 9 ? '' : '0') + mm, '/',
				(dd > 9 ? '' : '0') + dd].join('');
		}
	}
	;
	return {
		add:add,
		getList:getList,
		remove:remove,
		update:update,
		get:get,
		displayTime:displayTime
	};
})();