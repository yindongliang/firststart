package main;
import java.io.File;
import java.io.IOException;

import org.springframework.context.ApplicationContext;

public class GenerateEmptyFileWithSameFileName implements WhatIdoIF {
	

	@Override
	public String dojob(ApplicationContext ac, String[] args) throws NumberFormatException, InstantiationException, IllegalAccessException, IOException {
		
		generateEmptyFiles(args[0], args[2]);
		generateEmptyFiles(args[1], args[3]);
		return "done";
	}
	public void generateEmptyFiles(String resourceFolder,String targetFolder) throws IOException{
		File fileres = new File(resourceFolder);
        File fileto = new File(targetFolder);
        if(!fileto.exists()){
        	fileto.mkdirs();
        }
        if(!fileres.exists()){
        	return;
        }
        File[] files = fileres.listFiles();
        for(int i = 0; i < files.length; i++) {
        	 String fn = files[i].getName();
        	 File f=new File(targetFolder+fn);
        	 f.createNewFile();
        }
	}

}
