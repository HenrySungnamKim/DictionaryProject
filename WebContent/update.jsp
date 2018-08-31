<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name ="viewport" content="width=device-width, initial-scale=1">
<title>뇌에 때려박는 단어장 프로젝트</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/Custom.css">
</head>
<body>
	<% 
		String userID=null;
		if  (session.getAttribute("userID")!=null){ //세션이 존재한다
			userID = (String) session.getAttribute("userID"); //그 값을 userID에 저장한다. 
		}
		if (userID==null){ //로그인이 안된 상태
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("<location.href='login.jsp'"); 
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
		Bbs bbs= new BbsDAO().getBbs(wordsNo); //세션관리
		if(!userID.equals(bbs.getUserID())){ //수정하고자 하는 단어의 작성자와 사용자가 일치하지않는다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없는 사용자입니다.')");
			script.println("<location.href='bbs.jsp'"); 
			script.println("</script>");
		}
	%>
	<nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">뇌에때려박는영단어 </a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">처음화면</a></li>
                <li class="active"><a href="bbs.jsp">내 단어장</a></li>
            </ul>
         <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">접속관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
       </div>
    </nav>
    <div class="container">
        <div class="row">
            <form method="post" action="updateAction.jsp?wordsNo=<%=wordsNo%>"> <!--update내용을 처리하는 updateAction.jsp가따로있으며, wordsNo를 보내준다.  -->
                <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
                <!--table-striped는 짝수 홀수를 번갈아나오게해서 보다 보기좋게 만들어준다. solid #dddddd는 회색빛깔이 돌게 만든다 -->
                    <thead><!--table head  -->
                        <tr><!--table row  -->
                            <th colspan="3" style="background-color:#eeeeee; text-align:center;">단어 수정</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="text" class="form-control" placeholder="English" name="wordsEng" maxlength="50" value="<%= bbs.getWordsEng()%>"></td>
                        </tr>
                        <tr>
                            <td><input type="text" class="form-control" placeholder="한국어 뜻" name="wordsKor" maxlength="50" value="<%= bbs.getWordsKor()%>"></td>
                        </tr>
                        <tr>
                            <td><textarea class="form-control" placeholder="단어 내용" name="wordsContent" maxlength="2048" style="height:350px"><%= bbs.getWordsContent()%></textarea></td>
                        </tr>
                    </tbody>
                </table>
                    <input type ="submit" class="btn btn-primary pull-right" value="수정하기">
            </form>
        </div>
       </div>  	
       <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
