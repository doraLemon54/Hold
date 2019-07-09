package javaBean;

// 자바빈 ,  DTO(Data Transfer Object)
public class SimpleBean {
	private String name;
	private String msg;       // 프로퍼티(property)

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
}
