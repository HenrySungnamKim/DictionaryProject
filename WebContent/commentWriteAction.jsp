<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="comment.CommentDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="comm" class="comment.Comment" scope="page" />
<jsp:setProperty name="comm" property="commNo" />
<jsp:setProperty name="comm" property="commContent" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>뇌에 때려박는 단어장 프로젝트</title>
</head>
<body>
	<%
		String userID = null;
		int wordsNo = 0;
		if (request.getParameter("wordsNo") != null) { //현재 수정하고자 하는 단어의 번호가 들어왔다면
			wordsNo = Integer.parseInt(request.getParameter("wordsNo"));
		}
		if (wordsNo == 0) { //현재 수정하고자 하는 단어의 번호가 들어와있지 않으면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("<location.href='bbs.jsp'");
			script.println("</script>");
		}
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		if (userID == null) { //로그인이 되어 있지않다면,
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
			script.println("<location.href='login.jsp'"); //로그인페이지로 이동시킨다.
			script.println("</script>");

		} else {//로그인이 되어있고,
			if (comm.getCommContent() == null) { //댓글의 내용이 없다면,
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert(' 댓글에 내용이 없습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				CommentDAO cmmDAO = new CommentDAO(); //내용이 존재하면, 실제로 데이터베이스에 저장한다.
				int result = cmmDAO.write(userID, comm.getCommContent(), wordsNo);

				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글이 작성되었습니다.')");
				script.println("location.href='view.jsp?wordsNo="+wordsNo+"'");
				script.println("</script>");

			}
		}
	%>
</body>
</html>
