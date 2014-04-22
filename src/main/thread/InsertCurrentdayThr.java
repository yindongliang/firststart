package main.thread;

import java.util.List;
import java.util.Map;

import common.answer.logic.Stock2DB;

public class InsertCurrentdayThr extends Thread implements ThreadIf {


	Map<Integer, String> mpcnt;
	int i;
	Stock2DB stock2DB;
	List<String> stock_list;
	public void run() {

		stock2DB.getAlldata(stock_list);
		mpcnt.put(i, "");
	}

	

	@Override
	public void setData(Map<Integer, String> mpcnt, Stock2DB stock2DB,int i,List<String> stock_list) {

		this.stock_list=stock_list;
		this.mpcnt = mpcnt;
		this.stock2DB=stock2DB;
		this.i = i;
	}

}
