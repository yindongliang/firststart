package main;
import java.util.List;

import main.thread.InsertCurrentdayThr;
import main.thread.ThreadListener;

import org.springframework.context.ApplicationContext;

import common.answer.logic.Stock2DB;

public class InsertCurrentDaydataFromInternet implements WhatIdoIF {
	

	@Override
	public String dojob(ApplicationContext ac, String[] args) throws NumberFormatException, InstantiationException, IllegalAccessException {
		Stock2DB stock2DB=((Stock2DB) ac.getBean("Stock2DB"));
		List<String> ls_shsz =stock2DB.getStockList(args[0], args[1]);
		ThreadListener.listenThreads(Integer.parseInt(args[2]), ls_shsz, InsertCurrentdayThr.class, stock2DB);
		
		return "done";
	}

}
