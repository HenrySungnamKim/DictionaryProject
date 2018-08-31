package bbs;

public class Bbs {
	private int wordsNo;
	private String wordsEng;
	private String wordsKor;
	private String userID;
	private String wordsDate; //String 형태로 날짜데이터를 관리.
	private String wordsContent;
	public int getWordsNo() {
		return wordsNo;
	}
	public void setWordsNo(int wordsNo) {
		this.wordsNo = wordsNo;
	}
	public String getWordsEng() {
		return wordsEng;
	}
	public void setWordsEng(String wordsEng) {
		this.wordsEng = wordsEng;
	}
	public String getWordsKor() {
		return wordsKor;
	}
	public void setWordsKor(String wordsKor) {
		this.wordsKor = wordsKor;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getWordsDate() {
		return wordsDate;
	}
	public void setWordsDate(String wordsDate) {
		this.wordsDate = wordsDate;
	}
	public String getWordsContent() {
		return wordsContent;
	}
	public void setWordsContent(String wordsContent) {
		this.wordsContent = wordsContent;
	}
	public int getWordsAvailable() {
		return wordsAvailable;
	}
	public void setWordsAvailable(int wordsAvailable) {
		this.wordsAvailable = wordsAvailable;
	}
	private int wordsAvailable;
}
