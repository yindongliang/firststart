/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package common.answer.logic;


import common.answer.bean.dto.Alldata;
import common.answer.bean.dto.WeekData;

import java.util.*;
import org.apache.log4j.Logger;

/**
 *
 * @author doyin
 */
public class Analysis {

    /*
     *
     *
     */
    private static Logger log = Logger.getLogger(Analysis.class);

   
    public static double caculateAveNday(List<Alldata> alldatalist, int n) {
        double pricemount = 0.0;
        for (int t = 0; t < n; t++) {
            Alldata alldata = alldatalist.get(t);
            pricemount = pricemount + alldata.getPresent_price().doubleValue();

        }
        double average = pricemount / n;
        return average;
    }

   
    public static double maxValue(double ...values){

        double maxv=0;
        for (double v:values){
            maxv=Math.max(maxv, v);
        }
        return maxv;
    }
   
     public static double minValue(double ...values){

        double minv=10000;
        for (double v:values){
            minv=Math.min(minv, v);
        }
        return minv;
    }
     
    
    public static Map<String,Object> mmValue( List<Alldata> listalldata,int t){
         
        double maxv=0;
        double minv=10000;
        
        int idxmax=0;
        int idxmin=0;
       
        for (int i=0;i<t;i++){
            Alldata v= listalldata.get(i);
            double maxvorigin=maxv;
            double minvorigin= minv;
            maxv=Math.max(maxv, v.getPresent_price().doubleValue());
            minv=Math.min(minv, v.getPresent_price().doubleValue());
            if (maxv!=maxvorigin){
                
                idxmax=i;
                
            }
            if (minv!=minvorigin){
                idxmin=i;
            }
            
        }
        Map res = new HashMap<String,Integer>();
        res.put("max", idxmax);
        res.put("min", idxmin);
        
        return res;
    }
    
     public static Map<String,Object> mmValueweek( List<WeekData> listalldata,int t){
         
        double maxv=0;
        double minv=10000;
        
        int idxmax=0;
        int idxmin=0;
       
        for (int i=0;i<t;i++){
            WeekData v= listalldata.get(i);
            double maxvorigin=maxv;
            double minvorigin= minv;
            maxv=Math.max(maxv, v.getClose_price().doubleValue());
            minv=Math.min(minv, v.getClose_price().doubleValue());
            if (maxv!=maxvorigin){
                
                idxmax=i;
                
            }
            if (minv!=minvorigin){
                idxmin=i;
            }
            
        }
        Map res = new HashMap<String,Integer>();
        res.put("max", idxmax);
        res.put("min", idxmin);
        
        return res;
    }
     
    
    public static Map<String,Object> weekAlldataValue( List<Alldata> listalldata,int t){
         
        double maxv=0;
        double minv=10000;
        
        int idxmax=0;
        int idxmin=0;
        
        long deallots=0;
        for (int i=0;i<t;i++){
            Alldata v= listalldata.get(i);
            deallots=deallots+v.getDeal_lots();
            
            double maxvorigin=maxv;
            double minvorigin= minv;
            maxv=Math.max(maxv, v.getTd_highest_price().doubleValue());
            minv=Math.min(minv, v.getTd_lowest_price().doubleValue());
//            if (maxv!=maxvorigin){
//                
//                idxmax=i;
//                
//            }
//            if (minv!=minvorigin){
//                idxmin=i;
//            }
            
        }
        Map res = new HashMap<String,Integer>();
        res.put("max", maxv);
        res.put("min", minv);
        res.put("deallots", deallots);
        
        return res;
    }
    
    
    public static boolean timeWindow(List<Alldata> alldatalist,int[] mmrr,double curprice,int cnt){
         Map<String, Object> mpmm = Analysis.mmValue(alldatalist, cnt);
        int mx = (Integer)mpmm.get("max");
        int mi = (Integer)mpmm.get("min");

        double mxpr = alldatalist.get(mx).getPresent_price().doubleValue();
        double mipr = alldatalist.get(mi).getPresent_price().doubleValue();
        boolean flg=false;
        for (int i =0;i<mmrr.length;i++){
            if (mmrr[i]==mx||mmrr[i]==mi){
                flg=true;
                break;
            }
        }
        if(!flg){
            return false;
        }
        if ((mxpr-mipr)/mipr*100<14){
            return false;
        }
        
//        if (curprice<mxpr){
//            return false;
//        }
        return true;
    }
    
    public static boolean zhongsu(List<Alldata> alldatalist,int[] mmrr,double yesterdayprice){
         Map<String, Object> mpmm = Analysis.mmValue(alldatalist, 22);
        int mx = (Integer)mpmm.get("max");
        int mi = (Integer)mpmm.get("min");

        double mxpr = alldatalist.get(mx).getPresent_price().doubleValue();
        double mipr = alldatalist.get(mi).getPresent_price().doubleValue();
        
       
        if (yesterdayprice<mxpr){
            return true;
        }
        return false;
    }

    private Analysis() {
    }
    
    
    
    
}
