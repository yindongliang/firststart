import main.WhatIdoIF;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Start {
	public static ApplicationContext ac;


	public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException  {
		try{
			
			if(args==null){
				System.out.println("only support the following parameters:");
				System.out.println("Createweekdata oneweek C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ 1");
				System.out.println("Createweekdata mutiweek C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ 1");
				System.out.println("InsertCurrentDaydataFromInternet C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ 10");
				System.out.println("InsertHistorydataFromFile 2014-03-18 C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ 1");
				System.out.println("PutNewestDataIntoMemory stock_allinone /deal/ {tel:0000000000,pwd:6764,dayk:'5,8,80,1'} 1");
				System.out.println("UpdateF10dataFromFile C:\\htdzh\\DATA\\SHase\\Base\\ C:\\htdzh\\DATA\\SZnse\\Base\\ C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ 1");
				System.out.println("GenerateEmptyFileWithSameFileName C:\\htdzh\\DATA\\SHase\\Day\\ C:\\htdzh\\DATA\\SZnse\\Day\\ D:\\Y_private\\Dev\\stock_data\\sh\\ D:\\Y_private\\Dev\\stock_data\\sz\\ 1");
				System.out.println("GenerateDataFileWithSameFileName C:\\htdzh\\DATA\\SHase\\Base\\ C:\\htdzh\\DATA\\SZnse\\Base\\ D:\\Y_private\\Dev\\stock_data\\shf10\\ D:\\Y_private\\Dev\\stock_data\\szf10\\ 4");
				
			}
			ac = new ClassPathXmlApplicationContext(new String[] {
					"applicationContext.xml", "dataAccessContext-local.xml" });
			Class<?> whatido = Class.forName("main."+args[0]);
			WhatIdoIF w=(WhatIdoIF) whatido.newInstance();
			String[] args2= new String[args.length-1];
			
			for(int i=1;i<args.length;i++){
				args2[i-1]=args[i];
			}
			w.dojob(ac, args2);
			
			System.exit(0);
		}catch(Exception e){
			e.printStackTrace();
			System.exit(-1);
		}
		
		

	}

}
