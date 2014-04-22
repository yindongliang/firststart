package main;
import org.springframework.context.ApplicationContext;

import common.answer.logic.Stock2DB;
import common.answer.util.Canlendar;

public class InsertCurrentDaydataFromInternet implements WhatIdoIF {
	

	@Override
	public String dojob(ApplicationContext ac, String[] args) {
		String retv = ((Stock2DB) ac.getBean("Stock2DB")).insert2dbFromFile(args[0], Canlendar.getSystemdate(), false,
				args[1],
				args[2]);
		return retv;
	}

}
