package main;
import org.springframework.context.ApplicationContext;

import common.answer.logic.Stock2DB;

public class InsertHistorydataFromFile implements WhatIdoIF {
	

	@Override
	public String dojob(ApplicationContext ac, String[] args) {
		String retv = ((Stock2DB) ac.getBean("Stock2DB")).getAlldata(args[0],
				args[1]);
		return retv;
	}

}
