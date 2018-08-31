<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
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
		int wordsNo=0;
		if (request.getParameter("wordsNo")!=null){ //현재 수정하고자 하는 단어의 번호가 들어왔다면
			wordsNo= Integer.parseInt(request.getParameter("wordsNo"));
		}
		if(wordsNo==0){ //현재 수정하고자 하는 단어의 번호가 들어와있지 않으면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("<location.href='bbs.jsp'");
			script.println("</script>");
		}
		Bbs bbs= new BbsDAO().getBbs(wordsNo);
		if(!userID.equals(bbs.getUserID())){ //수정하고자 하는 단어의 작성자와 사용자가 일치하지않는다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없는 사용자입니다.')");
			script.println("<location.href='bbs.jsp'"); 
			script.println("</script>");
		}
		else{ 
			BbsDAO bbsDAO = new BbsDAO(); //3가지 항목을 채워넣었다면, 실제로 데이터베이스에 저장한다.
			int result = bbsDAO.delete(wordsNo);
			if (result == -1) { //아이디가 중복되는지 확인 (userID는 Primary Key이기 때문.)
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('삭제를 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else {//단어 수정 성공시 단어장 페이지로 이동시켜준다
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href='bbs.jsp'");
				script.println("</script>");
				}		
			
			}
		
	%>
</body>
</html>
