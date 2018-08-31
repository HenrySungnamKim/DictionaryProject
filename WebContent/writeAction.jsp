<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> <!--jsp에서 사용할 객체생성 -->
<jsp:setProperty name="bbs" property="wordsNo" />
<jsp:setProperty name="bbs" property="wordsEng" />
<jsp:setProperty name="bbs" property="wordsKor" />
<jsp:setProperty name="bbs" property="wordsContent" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>뇌에 때려박는 단어장 프로젝트</title>
</head>
<body>
	<%
		//null 값이 있는지 검사
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { //로그인이 되어 있지않다면,
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("<location.href='login.jsp'"); //로그인페이지로 이동시킨다.
			script.println("</script>");

		}
		else{
			if (bbs.getWordsEng() == null || bbs.getWordsKor() == null
					|| bbs.getWordsContent() == null ) { //영어, 한국어, 단어내용이 없다면 이전 페이지로 돌려보낸다.
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert(' 입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO(); //3가지 항목을 채워넣었다면, 실제로 데이터베이스에 저장한다.
				int result = bbsDAO.write(bbs.getWordsEng(),bbs.getWordsKor(),userID,bbs.getWordsContent());
				if (result == -1) { //아이디가 중복되는지 확인 (userID는 Primary Key이기 때문.)
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('작성을 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {//새 단어 작성 성공시, 단어장 페이지로 이동시켜준다
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			
			}
		}
	%>
</body>
</html>
