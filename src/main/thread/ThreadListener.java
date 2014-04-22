package main.thread;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import common.answer.logic.Stock2DB;

public class ThreadListener {
	
	
	public static void listenThreads(int threadcount,List<String> stocklist,Class clazz,Stock2DB stock2DB) throws InstantiationException, IllegalAccessException{
		
		Map<Integer, String> mpcnt = new HashMap<Integer, String>();
		int t = stocklist.size() / threadcount;

		for (int i = 0; i < threadcount; i++) {
			ThreadIf threadif=(ThreadIf) clazz.newInstance();
			if (i == threadcount - 1) {
				
				threadif.setData(mpcnt,stock2DB, i,stocklist.subList(i * t,
						stocklist.size()));
				

			} else {
				threadif.setData(mpcnt,stock2DB, i,stocklist.subList(i * t, (i + 1) * t));
				


			}
			threadif.start();
		}
		
		while (true) {
			boolean continueflg=false;
			for(int i=0;i<threadcount;i++){
				if(mpcnt.get(i)==null){
					continueflg=true;
					try {
						Thread.sleep(1);
						break;
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			if(!continueflg){
				break;
			}
			
		}
	
	}
	
}
