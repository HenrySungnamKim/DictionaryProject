<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name ="viewport" content="width=device-width, initial-scale=1">
<title>뇌에 때려박는 단어장 프로젝트</title>
<link rel="stylesheet" href="css/Custom.css" />
<link rel="stylesheet" href="css/bootstrap.css">
</head>
<body>
	<% 
		String userID=null;
		if  (session.getAttribute("userID")!=null){ //세션이 존재한다
			userID = (String) session.getAttribute("userID"); //그 값을 userID에 저장한다. 
		}
		int pageNumber=1; //기본 페이지
		if(request.getParameter("pageNumber")!=null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
    		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
    		<!--table-striped는 짝수 홀수를 번갈아나오게해서 보다 보기좋게 만들어준다. solid #dddddd는 회색빛깔이 돌게 만든다 -->
    			<thead><!--table head  -->
    				<tr><!--table row  -->
    					<th style="background-color:#eeeeee; text-align:center;">번호</th>
    					<th style="background-color:#eeeeee; text-align:center;">English</th>
    					<th style="background-color:#eeeeee; text-align:center;">Korean</th>
    					<th style="background-color:#eeeeee; text-align:center;">작성자</th>
    					<th style="background-color:#eeeeee; text-align:center;">작성시간</th>
    				</tr>
   				</thead>
    			<tbody>
    				<% 
    					BbsDAO bbsDAO = new BbsDAO();
    				
    					ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
    					for(int i = 0; i<list.size(); i++){
					%>
					<tr><!-- 단어장 페이지에 목록을 표시하고, view.jsp페이지로 이동시켜주는 href -->
				 		<td><%=list.get(i).getWordsNo() %></td> 
				 		<td><a href="view.jsp?wordsNo=<%= list.get(i).getWordsNo() %>"><%=list.get(i).getWordsEng().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
				 		<td><a href="view.jsp?wordsNo=<%= list.get(i).getWordsNo() %>"><%=list.get(i).getWordsKor().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></a></td>
				 		<td><%= list.get(i).getUserID() %></td>
					 	<td><%= list.get(i).getWordsDate().substring(0,11) + list.get(i).getWordsDate().substring(11,13) +"시" + list.get(i).getWordsDate().substring(14,16) +" 분" %></td>
    				</tr>
    				<%	
    					}
   					%>
    			</tbody>	
    		</table>
    			<%  
    				if(pageNumber!=1){
    			%>	
    				<a href="bbs.jsp?pageNumber=<%=pageNumber -1 %>" class="btn btn-success btn-arraw-left">이전</a>
    			<% 
    				}	
    				if(bbsDAO.nextPage(pageNumber+1)){
    			%>	
   					<a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
    			<% 	
    				}
    			%>
    		<a href="write.jsp" class="btn btn-primary pull-right">새 단어 작성</a>
    	</div>
   	</div>
  	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
