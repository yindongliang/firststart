package main.thread;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CopyF10DataThreadListener {
	
	
	public static void listenThreads(int threadcount,List<File> stocklist,String targetFolder) throws InstantiationException, IllegalAccessException{
		
		Map<Integer, String> mpcnt = new HashMap<Integer, String>();
		int t = stocklist.size() / threadcount;

		for (int i = 0; i < threadcount; i++) {
			CopyF10DataFileThr thread=new CopyF10DataFileThr();
			if (i == threadcount - 1) {
				
				thread.setData(mpcnt, i,stocklist.subList(i * t,
						stocklist.size()),targetFolder);
				

			} else {
				thread.setData(mpcnt, i,stocklist.subList(i * t, (i + 1) * t),targetFolder);
				


			}
			thread.start();
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
