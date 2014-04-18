import helper.HttpHelper;

import java.net.URLEncoder;
import java.util.List;

import net.sf.json.JSONObject;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.core.IMap;

import common.answer.bean.dto.Keyvalue;
import common.answer.logic.Stock2DB;

public class Start {
	public static ApplicationContext ac;

	@SuppressWarnings("deprecation")
	public static void main(String[] args)  {
		
		try{

			ac = new ClassPathXmlApplicationContext(new String[] {
					"applicationContext.xml", "dataAccessContext-local.xml" });
			Stock2DB st = (Stock2DB) ac.getBean("Stock2DB");
			List<Keyvalue> kvlst = st.getKeyvalue();
			ClientConfig clientConfig = new ClientConfig();
			for (Keyvalue kv : kvlst) {
				if ("mmaddress".equals(kv.getKeyee())) {
					clientConfig.addAddress(kv.getValuee());
				}
			}

			HazelcastInstance client = HazelcastClient
					.newHazelcastClient(clientConfig);
			IMap<?, ?> map = client.getMap("stockers");
			map.clear();

			st.setDataintoMem(map);
			client.shutdown();
			
			HttpHelper httpHelper = new HttpHelper();
			
			JSONObject tempjson = JSONObject.fromObject(args[1]);
			
			String forwardid = URLEncoder.encode(tempjson.toString(),"UTF-8");
			String[] strarr= {args[2],args[3],args[4],args[5]};
			// initiate web project,make data get involved into web application from hazelcast
			httpHelper.sendRequest(args[0]+forwardid, strarr);
			AbstractApplicationContext acc = (AbstractApplicationContext) ac;
			acc.registerShutdownHook();
			System.exit(0);
		}catch(Exception e){
			e.printStackTrace();
			System.exit(-1);
		}
		
		

	}

}
