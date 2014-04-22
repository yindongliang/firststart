package main;
import org.springframework.context.ApplicationContext;

import common.answer.logic.Stock2DB;


public class UpdateF10dataFromFile implements WhatIdoIF {
	
	@Override
	public String dojob(ApplicationContext ac, String[] args) {
		 String retv = ((Stock2DB) ac.getBean("Stock2DB")).insertf10FromFile(
				 args[0],
				 args[1],
				 args[2],
				 args[3]);
		return retv;
	}

}
