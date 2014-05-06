package main;
import helper.HttpHelper;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.AbstractApplicationContext;

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientNetworkConfig;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.core.IMap;

import common.answer.bean.dto.Keyvalue;
import common.answer.logic.Stock2DB;


public class PutNewestDataIntoMemory implements WhatIdoIF {
	
	@Override
	public String dojob(ApplicationContext ac, String[] args) throws UnsupportedEncodingException {
		Stock2DB st = (Stock2DB) ac.getBean("Stock2DB");
		List<Keyvalue> kvlst = st.getKeyvalue();
		ClientConfig clientConfig= new ClientConfig();
		ClientNetworkConfig clientnetworkConfig = new ClientNetworkConfig();
		String appinfo="";
		for (Keyvalue kv : kvlst) {
			if ("mmaddress".equals(kv.getKeyee())) {
				clientnetworkConfig.addAddress(kv.getValuee());
				clientnetworkConfig.setConnectionAttemptLimit(4);
			}else if (args[0].equals(kv.getKeyee())) {

				/*
				 * ulr for invoke logic app e.g.
				 * http://127.0.0.1:6182/xxx
				 */
				appinfo=(kv.getValuee());
			} 
		}
		clientConfig.setNetworkConfig(clientnetworkConfig);
		
		HazelcastInstance client = HazelcastClient
				.newHazelcastClient(clientConfig);
		
		IMap<?, ?> map = client.getMap("stockers");
		map.clear();

		st.setDataintoMem(map);
		client.shutdown();
		
//		HttpHelper httpHelper = new HttpHelper();
		
//		JSONObject tempjson = JSONObject.fromObject(args[2]);
		
//		String forwardid = URLEncoder.encode(tempjson.toString(),"UTF-8");
//		String[] strarr= appinfo.split(",");
		// initiate web project,make data get involved into web application from hazelcast
//		httpHelper.sendRequest(args[1]+forwardid, strarr);
		AbstractApplicationContext acc = (AbstractApplicationContext) ac;
		acc.registerShutdownHook();
		return "done";
	}

}
