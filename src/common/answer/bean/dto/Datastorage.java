package common.answer.bean.dto;

import java.io.Serializable;
import java.util.List;

public class Datastorage implements Serializable{

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<Alldata> alldatalist;
    private List<WeekData> weekdatalist;
    private Ften ften;
    private String record_date;
    double[] average_today_nday;
    double[] average_yesterday_nday;

    public double[] getAverage_threedaysago_nday() {
        return average_threedaysago_nday;
    }

    public void setAverage_threedaysago_nday(double[] average_threedaysago_nday) {
        this.average_threedaysago_nday = average_threedaysago_nday;
    }

    public double[] getAverage_today_nday() {
        return average_today_nday;
    }

    public void setAverage_today_nday(double[] average_today_nday) {
        this.average_today_nday = average_today_nday;
    }

    public double[] getAverage_twodaysago_nday() {
        return average_twodaysago_nday;
    }

    public void setAverage_twodaysago_nday(double[] average_twodaysago_nday) {
        this.average_twodaysago_nday = average_twodaysago_nday;
    }

    public double[] getAverage_yesterday_nday() {
        return average_yesterday_nday;
    }

    public void setAverage_yesterday_nday(double[] average_yesterday_nday) {
        this.average_yesterday_nday = average_yesterday_nday;
    }
    double[] average_twodaysago_nday;
    double[] average_threedaysago_nday;
    
    public List<Alldata> getAlldatalist() {
        return alldatalist;
    }

    public void setAlldatalist(List<Alldata> alldatalist) {
        this.alldatalist = alldatalist;
    }

    public Ften getFten() {
        return ften;
    }

    public void setFten(Ften ften) {
        this.ften = ften;
    }

    public List<WeekData> getWeekdatalist() {
        return weekdatalist;
    }

    public void setWeekdatalist(List<WeekData> weekdatalist) {
        this.weekdatalist = weekdatalist;
    }

    public Datastorage() {
    }

	public String getRecord_date() {
		return record_date;
	}

	public void setRecord_date(String record_date) {
		this.record_date = record_date;
	}
}
