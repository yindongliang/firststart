/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package common.answer.bean.dto;

import java.io.Serializable;

/**
 *
 * @author doyin
 */
public class Ztgs implements Serializable{
    
     /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String record_date;
     private Integer ztgs;

    public String getRecord_date() {
        return record_date;
    }

    public void setRecord_date(String record_date) {
        this.record_date = record_date;
    }

    public Integer getZtgs() {
        return ztgs;
    }

    public void setZtgs(Integer ztgs) {
        this.ztgs = ztgs;
    }
     
    
}
