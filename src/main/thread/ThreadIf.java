package main.thread;

import java.util.List;
import java.util.Map;

import common.answer.logic.Stock2DB;

public interface ThreadIf {
	
	public void setData( Map<Integer, String> mpcnt, Stock2DB stock2DB,int i,List<String> stock_list);
	
	public void start();
}
