package common.answer.bean.dto;

import java.io.Serializable;
import java.util.List;

public class Keyvalue implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String keyee;
    private String valuee;
    
    private List<String> orderBy;
    private String order;
    private int limit;

    public Keyvalue() { }

    public List<String> getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(List<String> orderBy) {
        this.orderBy = orderBy;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

	public String getKeyee() {
		return keyee;
	}

	public void setKeyee(String keyee) {
		this.keyee = keyee;
	}

	public String getValuee() {
		return valuee;
	}

	public void setValuee(String valuee) {
		this.valuee = valuee;
	}
}
