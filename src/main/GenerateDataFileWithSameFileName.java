package main;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import main.thread.CopyF10DataThreadListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;

public class GenerateDataFileWithSameFileName implements WhatIdoIF {
	
	private static final Log Logger = LogFactory.getLog(GenerateDataFileWithSameFileName.class);
	@Override
	public String dojob(ApplicationContext ac, String[] args) throws NumberFormatException, InstantiationException, IllegalAccessException, IOException {
		
		generateEmptyFiles(args[0], args[2],args[4]);
		generateEmptyFiles(args[1], args[3],args[4]);
		return "done";
	}
	public void generateEmptyFiles(String resourceFolder,String targetFolder,String threadcount) throws IOException, NumberFormatException, InstantiationException, IllegalAccessException{
		File fileres = new File(resourceFolder);
        File fileto = new File(targetFolder);
        if(!fileto.exists()){
        	fileto.mkdirs();
        }
        if(!fileres.exists()){
        	return;
        }
        Logger.info("start");
        List<File> lstfile=Arrays.asList(fileres.listFiles());
        CopyF10DataThreadListener.listenThreads(Integer.parseInt(threadcount), lstfile, targetFolder);
        Logger.info("end");
	}
	 

}
