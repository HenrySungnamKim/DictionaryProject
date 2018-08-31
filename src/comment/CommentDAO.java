package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO {

	private Connection conn;
	private ResultSet rs;

	public CommentDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			// bbs데이터베이스에 접속하는 3306포트(=내컴퓨터의 mysql포트)
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.cj.jdbc.Driver"); // Driver는 매개체역할 Library
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);// 데이터베이스에 접속하는부분
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			rs = pstmt.executeQuery();// rs에 실제로 실행한 뒤에 나올 결과를 저장.
			if (rs.next()) // 결과값이 있는 경우.
			{
				return rs.getString(1); // 현재 시간을 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}

	public int getNext(int wordsNo) {//다음 댓글번호를 받는메서드
		String SQL = "SELECT CommNo FROM comment WHERE wordsNo=? ORDER BY commNo DESC"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, wordsNo);
			rs = pstmt.executeQuery();// rs에 실제로 실행한 뒤에 나올 결과를 저장.
			if (rs.next()) // 결과값이 있는 경우.
			{
				return rs.getInt(1) + 1; // 이전값에서 1 추가된 숫자반환
			}
			return 1; // 첫번째 게시물인 경우. 현재위치를 반환한다
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류. 번호로는 적당하지않은 음수를 반환해서 데이터베이스 오류임을 알게한다.
	}

	public int write(String userID, String commContent, int wordsNo) {
		String SQL = "INSERT INTO comment values (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, getNext(wordsNo));
			pstmt.setString(2, userID);
			pstmt.setString(3, commContent);
			pstmt.setString(4, getDate());
			pstmt.setInt(5, 1); // comment Availabe; 처음 작성시에 댓글이 보이도록 1을 지정.
			pstmt.setInt(6, wordsNo);

			//rs = pstmt.executeQuery();INSERT문에서는 executeQuery사용하지않음.
			return pstmt.executeUpdate();// 성공하면 0이상의 값을 반환한다.

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류.
		}
	
	public ArrayList<Comment> getList(int commPageNumber, int wordsNo){ //데이터베이스의 값들을 불러와 저장하는 객체생성 메서드. JSP페이지에서 사용하기위해
		String SQL = "SELECT * FROM comment WHERE commNo < ? AND commAvailable=1 AND wordsNo=? ORDER BY commNo DESC LIMIT 10 "; //10개까지의 댓글을 표시
		ArrayList<Comment> commList= new ArrayList<Comment>(); //Comment클래스의 인스턴스를 보관하는 cmmList를 담는 객체 생성.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, getNext(wordsNo) - (commPageNumber -1) * 10 );
			pstmt.setInt(2, wordsNo);  
			rs=pstmt.executeQuery(); //select문은 결과값이표시되므로 executeQuery사용.
			while (rs.next()) // 결과값이 있는 경우.
			{
				Comment comm = new Comment(); //Bbs클래스의 객체생성.
				comm.setCommNo(rs.getInt(1));
				comm.setUserID(rs.getString(2));
				comm.setCommContent(rs.getString(3));
				comm.setCommDate(rs.getString(4));
				comm.setCommAvailable(rs.getInt(5));
				comm.setWordsNo(rs.getInt(6));
				commList.add(comm); //list array 객체에 해당 내용을 담는다.
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return commList;
	}
	public boolean nextPage(int commPageNumber, int wordsNo) { //페이징 처리
		String SQL = "SELECT * FROM comment WHERE commNo < ? AND commAvailable=1 AND wordsNo=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, getNext(wordsNo) - (commPageNumber -1) * 10 );
			pstmt.setInt(2, wordsNo);
			rs=pstmt.executeQuery(); //select문은 결과값이표시되므로 executeQuery사용.
			if (rs.next()) {
				return true; //결과값이 있다면 true반환.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public Comment getComment(int commNo, int wordsNo) { //댓글 내용을 불러오는 함수 
		String SQL = "SELECT * FROM comment WHERE commNo=? AND wordsNo=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, commNo);
			pstmt.setInt(2, wordsNo);
			rs=pstmt.executeQuery(); //select문은 결과값이표시되므로 executeQuery사용.
			if (rs.next()) {
				Comment comm = new Comment();
				comm.setCommNo(rs.getInt(1));
				comm.setUserID(rs.getString(2));
				comm.setCommContent(rs.getString(3));
				comm.setCommDate(rs.getString(4));
				comm.setCommAvailable(rs.getInt(5));
				return comm; 
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null; //해당 댓글이 존재하지 않는 경우
	}
	public int update(int commNo,String commContent, int wordsNo) {
		String SQL = "UPDATE comment SET commContent=? WHERE commNo=? AND wordsNo=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setString(1, commContent);
			pstmt.setInt(2, commNo);
			pstmt.setInt(3, wordsNo);
			

			return pstmt.executeUpdate();// 성공하면 0이상의 값을 반환한다.

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류.
	}
	public int delete(int commNo, int wordsNo) {
		String SQL = "UPDATE comment SET commAvailable=0 WHERE commNo=? AND wordsNo=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // SQL문장을 실행 준비단계로 만들어준다.
			pstmt.setInt(1, commNo);
			pstmt.setInt(2, wordsNo);

			return pstmt.executeUpdate();// 성공하면 0이상의 값을 반환한다.

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류.
		
	}
}
