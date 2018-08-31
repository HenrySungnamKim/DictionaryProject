package comment;

public class Comment {

	private int commNo; 
	private String userID;
	private String commContent;
	private String commDate;
	private int commAvailable;
	private int wordsNo;
	
	public int getCommNo() {
		return commNo;
	}
	public void setCommNo(int commNo) {
		this.commNo = commNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getCommContent() {
		return commContent;
	}
	public void setCommContent(String commContent) {
		this.commContent = commContent;
	}
	public String getCommDate() {
		return commDate;
	}
	public void setCommDate(String commDate) {
		this.commDate = commDate;
	}

	public int getCommAvailable() {
		return commAvailable;
	}
	public void setCommAvailable(int commAvailable) {
		this.commAvailable = commAvailable;
	}
	public int getWordsNo() {
		return wordsNo;
	}
	public void setWordsNo(int wordsNo) {
		this.wordsNo = wordsNo;
	}
	
	}
