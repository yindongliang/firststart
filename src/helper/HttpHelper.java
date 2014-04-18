package helper;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.PoolingClientConnectionManager;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Component;


public class HttpHelper {

    static DefaultHttpClient httpclient;
    
    static HttpHost target = null;

    static {
        final PoolingClientConnectionManager cm = new PoolingClientConnectionManager();
        cm.setMaxTotal(200);
        cm.setDefaultMaxPerRoute(200);

        Thread tr = new Thread() {

            @Override
            public void run() {
                while (true) {

                    cm.closeIdleConnections(100, TimeUnit.MILLISECONDS);

                }
            }
        };
        tr.start();
        httpclient = new DefaultHttpClient(cm);
    }

    public String sendRequest(String requestkey,String[] appserverinfo) {
        HttpGet req = null;
        HttpResponse rsp = null;
        
        try {

            if (target == null) {

                target = new HttpHost(appserverinfo[1], Integer.parseInt(appserverinfo[2]), appserverinfo[0]);
            }

            req = new HttpGet("/"+appserverinfo[3] + requestkey);
            

            try {
                rsp = httpclient.execute(target, req);
            } catch (IOException ex) {
                Logger.getLogger(HttpHelper.class.getName()).log(Level.SEVERE, null, ex);
            }

            String datas = "";
            try {
                datas = EntityUtils.toString(rsp.getEntity());
            } catch (IOException ex) {
                Logger.getLogger(HttpHelper.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ParseException ex) {
                Logger.getLogger(HttpHelper.class.getName()).log(Level.SEVERE, null, ex);
            }

            return datas;

        } finally {
            //httpclient.getConnectionManager().shutdown();
        }
    }
}
