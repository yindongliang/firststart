//////////AUTOGEN START//////////
package common.answer.bean.dto;

import java.util.List;
import java.io.Serializable;
import java.math.BigDecimal;

public class SearchRecord implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String stock_cd;
    private String record_date;
    private String stock_name;
    private BigDecimal fullup_cnt;
    private BigDecimal liutongguben;
    private BigDecimal yeji;
    private BigDecimal liutonggudongbl;
    private List<String> order_by;
    private String order;
    private int limit;

    public SearchRecord() { }

    public String getStock_cd() {
        return stock_cd;
    }

    public void setStock_cd(String stock_cd) {
        this.stock_cd = stock_cd;
    }

    public String getRecord_date() {
        return record_date;
    }

    public void setRecord_date(String record_date) {
        this.record_date = record_date;
    }

    public String getStock_name() {
        return stock_name;
    }

    public void setStock_name(String stock_name) {
        this.stock_name = stock_name;
    }

    public BigDecimal getFullup_cnt() {
        return fullup_cnt;
    }

    public void setFullup_cnt(BigDecimal fullup_cnt) {
        this.fullup_cnt = fullup_cnt;
    }

    public BigDecimal getLiutongguben() {
        return liutongguben;
    }

    public void setLiutongguben(BigDecimal liutongguben) {
        this.liutongguben = liutongguben;
    }

    public BigDecimal getYeji() {
        return yeji;
    }

    public void setYeji(BigDecimal yeji) {
        this.yeji = yeji;
    }

    public BigDecimal getLiutonggudongbl() {
        return liutonggudongbl;
    }

    public void setLiutonggudongbl(BigDecimal liutonggudongbl) {
        this.liutonggudongbl = liutonggudongbl;
    }

    public List<String> getOrder_by() {
        return order_by;
    }

    public void setOrder_by(List<String> order_by) {
        this.order_by = order_by;
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
//////////AUTOGEN END////////////
}
