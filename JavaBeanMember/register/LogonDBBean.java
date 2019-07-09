// DAO(Data Access Object)

package JavaBeanMember.register;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LogonDBBean {

	// 싱글톤 : 객체 생성을 1번만 수행
	private static LogonDBBean instance = new LogonDBBean();

	public static LogonDBBean getInstance() {
		return instance;
	}

	// 회원 가입
	public int insertMember(LogonDataBean logon) {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";

		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, "scott", "tiger");

			String sql = "insert into member values(?,?,?,?,?,?,?,sysdate)";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, logon.getId());
			pstmt.setString(2, logon.getPasswd());
			pstmt.setString(3, logon.getName());
			pstmt.setString(4, logon.getJumin1());
			pstmt.setString(5, logon.getJumin2());
			pstmt.setString(6, logon.getEmail());
			pstmt.setString(7, logon.getBlog());

			result = pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (Exception e) {
				}
			}
		}

		return result;
	}

	// 회원 목록
	public List<LogonDataBean> selectMember() {
		List<LogonDataBean> list = new ArrayList<LogonDataBean>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";

		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, "scott", "tiger");

			String sql = "select * from member";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				// DB에서 가져온 데이터를 저장하기 위한 기억공간을 생성
				LogonDataBean logon = new LogonDataBean();
//				 logon.id="toto"; 접근 안됨  
				logon.setId(rs.getString("id"));
				logon.setPasswd(rs.getString("passwd"));
				logon.setName(rs.getString("name"));
				logon.setJumin1(rs.getString("jumin1"));
				logon.setJumin2(rs.getString("jumin2"));
				logon.setEmail(rs.getString("email"));
				logon.setBlog(rs.getString("blog"));
				logon.setReg_date(rs.getTimestamp("reg_date"));

				list.add(logon);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (Exception e) {
				}
			}
		}
		return list;
	}

	// 회원정보 수정 폼 : 1명의 정보를 검색
	public LogonDataBean updateForm(String id) {

		LogonDataBean logon = new LogonDataBean();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, "scott", "tiger");

			String sql = "select * from member where id=?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				logon.setId(rs.getString("id"));
				logon.setPasswd(rs.getString("passwd"));
				logon.setName(rs.getString("name"));
				logon.setJumin1(rs.getString("jumin1"));
				logon.setJumin2(rs.getString("jumin2"));
				logon.setEmail(rs.getString("email"));
				logon.setBlog(rs.getString("blog"));
				logon.setReg_date(rs.getTimestamp("reg_date"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (Exception e) {
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (Exception e) {
				}
			}
		}

		return logon;
	}
	public void update(LogonDataBean logon){
	}
}
