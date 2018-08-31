<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment" %>
<%@ page import="java.util.ArrayList" %>
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
		int commPageNumber=1;
	
		int wordsNo=0;
		if  (session.getAttribute("userID")!=null){ //세션이 존재한다
			userID = (String) session.getAttribute("userID"); //그 값을 userID에 저장한다. 
		}
		
		if(request.getParameter("commPageNumber")!=null){
			commPageNumber = Integer.parseInt(request.getParameter("commPageNumber"));
		}
		if (request.getParameter("wordsNo")!=null){ //로컬변수 wordsNo에 값이 존재하면
			wordsNo=Integer.parseInt(request.getParameter("wordsNo"));//데이터베이스에서 값을 가져와 로컬변수wordsNo에저장.
		}
		if (wordsNo==0){ //로컬변수 wordsNo가 0이면 
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("<location.href='bbs.jsp'"); //단어장페이지로 이동시킨다.
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(wordsNo); //BbsDAO클래스의 getBbs메서드 작동. 글내용을 담는다.
		
		
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
            <%
            	if(userID==null){//회원가입이 되어있지않다면 로그인/회원가입 메뉴를 표시하게한다.
            
        	%>
       		<ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    </ul>
                </li>
            </ul>               
        	<%
            	} else {//회원가입이 되어있으면 로그아웃메뉴를 표시하게한다.
          	%>
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
          	<%
          	}
            %>
       </div>
    </nav>
    <div class="container">
    	<div class="row">
    		<!-- <form method="post" action="writeAction.jsp"> ...삭제되 부분 -->
    			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
    			<!--table-striped는 짝수 홀수를 번갈아나오게해서 보다 보기좋게 만들어준다. solid #dddddd는 회색빛깔이 돌게 만든다 -->
    				<thead><!--table head  -->
    					<tr><!--table row  -->
    						<th colspan="4" style="background-color:#eeeeee; text-align:center;">세부 내용</th>
    					</tr>
					</thead>
    				<tbody>
    					<tr>
							<td style="width: 20%;">English </td>
							<td colspan="2"><%= bbs.getWordsEng().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td style="width: 20%;">한국어 </td>
							<td colspan="2"><%= bbs.getWordsKor().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td style="width: 20%;">작성자 </td>
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<td style="width: 20%;">작성시간 </td>
							<td colspan="2"><%= bbs.getWordsDate().substring(0,11) + bbs.getWordsDate().substring(11,13) +"시" + bbs.getWordsDate().substring(14,16) +" 분" %></td>
						</tr>
						<tr>
							<td>내용</td><!--replaceAll()메소드로 특수문자, 공백을 웹 용으로 처리한다.  -->
							<td colspan="2" style="min-height:250px; text-align:left;"><%=bbs.getWordsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
						</tr>
					</tbody>
    			</table>
    			<!-- 여기부터 댓글 -->
    			<%
    				if (userID!=null){ //로그인 된 상태라면, 댓글 작성 행을 보여준다.
    						
   				%>	
   				
   				<div class="container">
    				<div class="row">
    					<form method="post" action="commentWriteAction.jsp?wordsNo=<%= wordsNo %>">
    						<table class="table table-striped" style="text-align:center; border:1px solid #eeeeee">
   								<thead>
	    						</thead>
								<tbody>
   									<tr>
 										<td style="width: 20%;">댓글달기 </td>
										<td><input type="text" class="form-control" placeholder="댓글을 달아보세요" name="commContent" maxlength="300"></td>
					   					<td><input type ="submit" class="btn btn-primary pull-right" value="댓글 저장"></td>
		   							</tr>
   								</tbody>
   								</table>
   						</form>
			    	</div>
			   	</div>
			   	<%
    				}
    			%>	
    			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
    			<thead><!--table head  -->
    				<tr>
    					<th colspan="4" style="background-color:#eeeeee; text-align:center;">댓글보기</th>
    				</tr>
    				<tr><!--table row  -->
    					<th style="text-align:center;">번호</th>
    					<th style="text-align:center;">댓글</th>
    					<th style="text-align:center;">작성자</th>
    					<th style="text-align:center;">작성시간</th>
    				</tr>
   				</thead>
    			<tbody>
    				<% 
    					CommentDAO commDAO = new CommentDAO();
    				
    					ArrayList<Comment> commList = commDAO.getList(commPageNumber, wordsNo);
    					for(int i = 0; i<commList.size(); i++){
					%>
					<tr>
				 		<td><%= commList.get(i).getCommNo() %></td> 
				 		<td><%= commList.get(i).getCommContent() %></td>
				 		<td><%= commList.get(i).getUserID() %></td>
					 	<td><%= commList.get(i).getCommDate().substring(0,11) + commList.get(i).getCommDate().substring(11,13) +"시" + commList.get(i).getCommDate().substring(14,16) +" 분" %></td>
    				</tr>
    				<%	
    					}
   					%>
    			</tbody>	
    		</table>
    				<a href="bbs.jsp" class="btn btn-primary">단어목록으로 이동</a>
    				<%
    					if (userID!=null&&userID.equals(bbs.getUserID())){ //글작성자와 동일한사람이면 단어수정, 삭제 버튼을 보이게한다.
    						
    				%>	
    						<a href="update.jsp?wordsNo=<%= wordsNo %>" class="btn btn-primary">단어 수정</a>
    						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?wordsNo=<%= wordsNo %>" class="btn btn-primary">단어 삭제</a>
    				<%
    					}
    				%>
    	</div>
   	</div>
  	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
