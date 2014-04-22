package main;
import org.springframework.context.ApplicationContext;

import common.answer.logic.Stock2DB;

public class Createweekdata implements WhatIdoIF {
	

	@Override
	public String dojob(ApplicationContext ac, String[] args) {
		// TODO Auto-generated method stub
	     String retv;
		 if ("mutiweek".equals(args[0])) {
             retv = ((Stock2DB) ac.getBean("Stock2DB")).generateWeekData(false,args[1],
            		 args[2]);
         } else {
             retv = ((Stock2DB) ac.getBean("Stock2DB")).generateWeekData(true,args[1],
            		 args[2]);
         }
		 
		return retv;
	}

}
