package common.answer.logic;

import com.alisoft.xplatform.asf.cache.ICacheManager;
import com.alisoft.xplatform.asf.cache.IMemcachedCache;
import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.core.IMap;
import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;

import common.answer.bean.dto.*;

import java.io.IOException;
import java.util.List;

import jp.terasoluna.fw.dao.QueryDAO;
import jp.terasoluna.fw.dao.UpdateDAO;






import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;






import common.answer.logic.helper.Formater;
import common.answer.logic.helper.HttpHelper;
import common.answer.logic.helper.LogicHelper;
import common.answer.logic.helper.PopertiesHelper;
import common.answer.util.Caculator;
import common.answer.util.Canlendar;
import common.answer.util.Convertor;

import java.io.*;
import java.math.BigDecimal;
import java.util.*;
import java.util.logging.Level;

import org.springframework.dao.DataIntegrityViolationException;

@Service(value = "Stock2DB")
public class Stock2DB {

    @Autowired
    protected HttpHelper httpHelper = null;
    @Autowired
    protected UpdateDAO updateDAO = null;
    @Autowired
    protected QueryDAO queryDAO = null;
    @Autowired
    protected PopertiesHelper popertiesHelper = null;
    private static Logger log = Logger.getLogger(Stock2DB.class);

    
    public List<Keyvalue> getKeyvalue() {
   	 
        List<Keyvalue> Keyvalue = queryDAO.executeForObjectList("keyvalue.selectKeyvalueAll", null);
   	
       return Keyvalue;
   }
    public List<String> getStockList(String datafile_path_sh, String datafile_path_sz){
    	List<String> ls_shsz =popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);
    	ls_shsz.add(popertiesHelper.getStocksProperties().getString("shindice_code"));
    	return ls_shsz;
    }
    public String getAlldata(List<String> ls_shsz ) {
        // get all stock's code
      //  List<String> ls_shsz = popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);
        // add the shanghai indices
//    	ls_shsz.add(popertiesHelper.getStocksProperties().getString("shindice_code"));
        List<String> stock_detail = null;
        // get the detail of the stocks
        for (int j = 0; j < ls_shsz.size(); j++) {

            stock_detail = httpHelper.sendRequest(ls_shsz.get(j), popertiesHelper.getStocksProperties());
            if (stock_detail==null){
            	continue;
            }
            if (!LogicHelper.isOpening(stock_detail) || !LogicHelper.isStock(stock_detail)) {
                continue;
            }

            Alldata ad = Formater.editCriteria(stock_detail);
            int cn = queryDAO.executeForObject("download.checkBeforeInsert", ad, Integer.class);

            if (cn == 0) {

                if (stock_detail.size() > 32) {
                    for (int b = 32; b < stock_detail.size(); b++) {
                        stock_detail.remove(b);
                    }
                }
                updateDAO.execute("download.insert2Alldata", stock_detail);
                log.info("data has been inserted :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());
            } else {
                log.info("data is exsiting :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());
            }

        }

        return "0";
    }

    public String generateWeekData(boolean oneWeekonly, String datafile_path_sh, String datafile_path_sz) {

        List<String> ls_shsz = popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);

        List<String> datelist = Canlendar.getAllfridaybynow("2012-01-01");
        List<Alldata> adlsOneweek = null;
        String mondaydate;
        // get the detail of the stocks
        for (int j = 0; j < ls_shsz.size(); j++) {


            Map<String, Object> condition = new HashMap<String, Object>();
            condition.put("stock_cd", ls_shsz.get(j));

            condition.put("record_date_to", datelist.get(datelist.size() - 1));
            condition.put("orderby", "desc");

            if (oneWeekonly) {

                condition.put("limit", 10);
            }
            List<WeekData> adls = new ArrayList<WeekData>();

            List<Alldata> adlstemp = queryDAO.executeForObjectList("download.searchdownloadResult", condition);
            int idx = 0;
            for (int i = datelist.size() - 1; i >= 0; i--) {

                mondaydate = Canlendar.getMondayOfSpeciWeek(datelist.get(i));
                adlsOneweek = new ArrayList<Alldata>();
                for (int m = idx; m < adlstemp.size(); m++) {
                    idx++;
                    if (adlstemp.get(m).getRecord_date().compareTo(datelist.get(i)) <= 0
                            && adlstemp.get(m).getRecord_date().compareTo(mondaydate) >= 0
                            && !Canlendar.isCurrentWeek(adlstemp.get(m).getRecord_date())) {

                        adlsOneweek.add(adlstemp.get(m));
                        continue;
                    } else if (Canlendar.isCurrentWeek(adlstemp.get(m).getRecord_date())) {
                        if (oneWeekonly) {
                            Calendar ca = Calendar.getInstance();
                            if (ca.get(Calendar.DAY_OF_WEEK) >= 6
                                    || ca.get(Calendar.DAY_OF_WEEK) == 1) {
                                adlsOneweek.add(adlstemp.get(m));
                            }
                        }

                        continue;
                    } else if (adlstemp.get(m).getRecord_date().compareTo(mondaydate) < 0) {
                        idx--;
                        break;
                    } else {
                        break;
                    }
                }
                if (adlsOneweek.isEmpty()) {
                    continue;
                }
                Map<String, Object> weekAlldata = Analysis.weekAlldataValue(adlsOneweek, adlsOneweek.size());
                WeekData adweek = new WeekData();
                adweek.setRecord_date(adlsOneweek.get(0).getRecord_date());
                adweek.setStock_cd(adlsOneweek.get(0).getStock_cd());
                adweek.setOpen_price(new BigDecimal(adlsOneweek.get(adlsOneweek.size() - 1).getTd_open_price()));
                adweek.setClose_price(adlsOneweek.get(0).getPresent_price());
                adweek.setHigh_price(new BigDecimal((double) weekAlldata.get("max")));
                adweek.setLow_price(new BigDecimal((double) weekAlldata.get("min")));

                adweek.setDeal_lots(new BigDecimal((long) weekAlldata.get("deallots")));
                adls.add(adweek);
                if (oneWeekonly) {
                    break;
                }
            }
//            ComparatorAlldata comparator = new ComparatorAlldata();
            // 升序排列
//            Collections.sort(adls, comparator);



            for (WeekData adwk : adls) {
                Map<String, Object> mpdata = new HashMap<String, Object>();

                mpdata.put("stock_cd", adwk.getStock_cd());
                mpdata.put("record_date", adwk.getRecord_date());
                mpdata.put("deal_lots", adwk.getDeal_lots());
                mpdata.put("open_price", adwk.getOpen_price());
                mpdata.put("close_price", adwk.getClose_price());
                mpdata.put("high_price", adwk.getHigh_price());
                mpdata.put("low_price", adwk.getLow_price());

                try {
                    updateDAO.execute("weekData.insertAll", mpdata);
                    log.info(adwk.getStock_cd() + "-" + adwk.getRecord_date() + " is inserted");

                } catch (Exception e) {
                    if (e instanceof DataIntegrityViolationException) {
                        log.info(adwk.getStock_cd() + "-" + adwk.getRecord_date() + " is existing");
                    } else {
                        throw e;
                    }
                }
            }
        }
        return "done";

    }

    public String insert2dbFromFile(String datefrom, String dateto, boolean del,
            String datafile_path_sh, String datafile_path_sz) {
        List<String> ls_shsz = popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);
        FileInputStream fis = null;
//        String datafile_path_sh = popertiesHelper.getStocksProperties().getString("datafile_path_sh");
//        String datafile_path_sz = popertiesHelper.getStocksProperties().getString("datafile_path_sz");

        try {

            for (String stockcd : ls_shsz) {

                if (stockcd.startsWith("60")) {
                    fis = new FileInputStream(datafile_path_sh + stockcd + ".day");
                } else if (stockcd.startsWith("30") || stockcd.startsWith("00")) {
                    fis = new FileInputStream(datafile_path_sz + stockcd + ".day");
                } else if (stockcd.equals("si000001")) {
                    fis = new FileInputStream(datafile_path_sh + "000001.day");
                }



                byte[] b = new byte[40];
                byte[] byestoday = new byte[40];

                while ((fis.read(b)) != -1) {
                    boolean ignorfag = false;
                    int date = Convertor.bytes2int(Convertor.cut(b, 0, 4));
                    String stockdate = Canlendar.formaterString("" + date);
                    if (stockdate.compareTo(datefrom) >= 0 && stockdate.compareTo(dateto) <= 0) {
                        List<String> stock_detail = new ArrayList<String>();

                        stock_detail.add(stockcd);// 0:股票代码
                        for (int i = 1; i < 10; i++) {
                            double data = (double) Convertor.bytes2int(Convertor.cut(b, i * 4, 4));

                            if (i == 1) {
                                double dt = Caculator.keepRound(data / 1000, 2);
                                if (dt == 0 || dt > 9000) {
                                    ignorfag = true;
                                    break;
                                }
                                stock_detail.add(dt + "");// 1:今日开盘价格
                                double yestdayprice = (double) Convertor.bytes2int(Convertor.cut(byestoday, 16, 4));
                                double dty = Caculator.keepRound(yestdayprice / 1000, 2);
                                stock_detail.add(dty + "");// 2:昨日收盘价格
                                stock_detail.add("3");// 3:当前价格

                            }
                            if (i == 2) {
                                double dt = Caculator.keepRound(data / 1000, 2);
                                if (dt == 0 || dt > 9000) {
                                    ignorfag = true;
                                    break;
                                }
                                stock_detail.add(dt + "");// 4:今日最高价格
                            }
                            if (i == 3) {

                                double dt = Caculator.keepRound(data / 1000, 2);
                                if (dt == 0 || dt > 9000) {
                                    ignorfag = true;
                                    break;
                                }
                                stock_detail.add(dt + "");// 5:今日最低价格
                            }
                            if (i == 4) {
                                double dt = Caculator.keepRound(data / 1000, 2);
                                if (dt == 0 || dt > 9000) {
                                    ignorfag = true;
                                    break;
                                }
                                stock_detail.set(3, dt + "");// 今日收盘价格设置成当前价格
                                stock_detail.add("0");// 6:竞买价买一
                                stock_detail.add("0");//7: 竞卖价卖一
                            }
                            if (i == 5) {
                                stock_detail.add("0"); // 8:成交量 
                                double dt = Caculator.keepRound(data / 10, 2);
                                stock_detail.add(dt * 10000 + "");//9: 成交额


                            }
                            if (i == 6) {
                                stock_detail.set(8, data * 100 + "");//8:成交量 更新

                                stock_detail.add("0");// 10:申请买一
                                stock_detail.add("0");// 11:报价买一
                                stock_detail.add("0");// 12:申请买2
                                stock_detail.add("0");// 13:报价买2
                                stock_detail.add("0");// 14:申请买3
                                stock_detail.add("0");// 15:报价买3
                                stock_detail.add("0");// 16:申请买4
                                stock_detail.add("0");// 17:报价买4
                                stock_detail.add("0");// 18:申请买5
                                stock_detail.add("0");// 19:报价买5
                                stock_detail.add("0");// 20:申请卖1
                                stock_detail.add("0");// 21:报价卖1
                                stock_detail.add("0");// 22:申请卖2
                                stock_detail.add("0");// 23:报价卖2
                                stock_detail.add("0");// 24:申请卖3
                                stock_detail.add("0");// 25:报价卖3
                                stock_detail.add("0");// 26:申请卖4
                                stock_detail.add("0");// 27:报价卖4
                                stock_detail.add("0");// 28:申请卖5
                                stock_detail.add("0");// 29:报价卖5
                                stock_detail.add(stockdate);//30:日期
                                stock_detail.add("15:00:00");//31: 时间

                            }
                        }
                        if (ignorfag) {
                            continue;
                        }

                        Alldata ad = Formater.editCriteria(stock_detail);
                        int cn = queryDAO.executeForObject("download.checkBeforeInsert", ad, Integer.class);

                        if (cn == 0) {

                            if (stock_detail.size() > 32) {
                                for (int t = 32; t < stock_detail.size(); t++) {
                                    stock_detail.remove(t);
                                }
                            }
                            updateDAO.execute("download.insert2Alldata", stock_detail);
                            log.info("data has been inserted :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());
                        } else {
                            if (del) {
                                updateDAO.execute("download.deleteExsitingdata", ad);
                                log.info("data has been deleted :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());
                                updateDAO.execute("download.insert2Alldata", stock_detail);
                                log.info("data has been inserted :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());

                            } else {
                                log.info("data is exsiting :" + ad.getStock_cd() + "-" + ad.getRecord_date() + "-" + ad.getRecord_time());
                            }

                        }
                    } else if (stockdate.compareTo(dateto) > 0) {
                        break;
                    }
                    byestoday = b.clone();


                }

                fis.close();


            }
            return "done";
        } catch (IOException ex) {
            java.util.logging.Logger.getLogger(Stock2DB.class.getName()).log(Level.SEVERE, null, ex);
            return "error";
        } finally {
            try {
                fis.close();
            } catch (IOException ex) {
                java.util.logging.Logger.getLogger(Stock2DB.class.getName()).log(Level.SEVERE, null, ex);
            }

        }

    }

    public String insertf10FromFile(String f10_file_path_sh, String f10_file_path_sz, String datafile_path_sh, String datafile_path_sz) {
        List<String> ls_shsz = popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);
        FileInputStream fis = null;
//        String f10_file_path_sh = popertiesHelper.getStocksProperties().getString("f10_file_path_sh");
//        String f10_file_path_sz = popertiesHelper.getStocksProperties().getString("f10_file_path_sz");
        updateDAO.execute("ften.deleteFten", null);
        log.info("ften has been deleteed");
        for (String stockcd : ls_shsz) {

            List<String> stock_detail = httpHelper.sendRequest(stockcd, popertiesHelper.getStocksProperties());
            if (stock_detail == null) {
                continue;
            }
            String stock_name = stock_detail.get(stock_detail.size() - 1);
            if (stock_name.contains("ST")) {
                continue;
            }

            Map<String, Object> mpfile001 = null;
            Map<String, Object> mpfile013 = null;
            Map<String, Object> mpfile010 = null;
            if (stockcd.startsWith("60")) {
                mpfile001 = readFileByLines(f10_file_path_sh + stockcd + ".001");
                if (mpfile001 != null) {
                    mpfile013 = readFileByLines(f10_file_path_sh + stockcd + ".013");
                    mpfile010 = readFileByLines(f10_file_path_sh + stockcd + ".010");
                }


            } else if (stockcd.startsWith("30") || stockcd.startsWith("00")) {
                mpfile001 = readFileByLines(f10_file_path_sz + stockcd + ".001");
                if (mpfile001 != null) {
                    mpfile013 = readFileByLines(f10_file_path_sz + stockcd + ".013");
                    mpfile010 = readFileByLines(f10_file_path_sz + stockcd + ".010");
                }
            }
            if (mpfile001 == null || mpfile013 == null || mpfile001.keySet().size() < 4) {
                continue;
            }
            double meigusy = (Double) mpfile001.get("meigusy");
            double meigujzc = (Double) mpfile001.get("meigujzc");
            double meigugjj = (Double) mpfile001.get("meigugjj");
            double meiguwfplr = (Double) mpfile001.get("meiguwfplr");

            double liutonggu = (Double) mpfile001.get("liutonggu");
            double tongbiincr = (Double) mpfile001.get("tongbiincr");
            double jingzcbenifitrate = (Double) mpfile001.get("jingzcbenifitrate");
            String update_date = (String) mpfile001.get("update_date");
            String suosuhangye = (String) mpfile013.get("suosuhangye");
            double liutonggudongchigubili = (Double) mpfile010.get("liutonggudongchigubili");

            log.info(stockcd + " " + stock_name + "：流通股 " + liutonggu + "，净利润同比增长 " + tongbiincr
                    + "，净资产收益率 " + jingzcbenifitrate
                    + "，所属行业 " + suosuhangye
                    + "，更新时间 " + update_date);


            Map<String, Object> mp = new HashMap<String, Object>();
            mp.put("stock_cd", stockcd);
            mp.put("stock_name", stock_name);

            mp.put("meigusy", meigusy);
            mp.put("meigujzc", meigujzc);
            mp.put("meigugjj", meigugjj);
            mp.put("meiguwfplr", meiguwfplr);

            mp.put("liutonggu", liutonggu);
            mp.put("tongbiincr", tongbiincr);
            mp.put("jingzcbenifitrate", jingzcbenifitrate);
            mp.put("update_date", update_date);
            mp.put("suosuhangye", suosuhangye);
            mp.put("liutonggudongchigubili", liutonggudongchigubili);
            try {
                updateDAO.execute("ften.insertFten", mp);
            } catch (Exception e) {
                if (e instanceof DataIntegrityViolationException) {
                    log.info(stockcd + " is existing");
                } else {
                    throw e;
                }
            }

        }
        return "done";
    }

    public void deleteBankStocks() {
        int cnt = updateDAO.execute("bankuaiStock.deleteExsitingdata", null);
        if (cnt > 0) {
            log.info("bankuai stocks  has been deleted:" + cnt + "条数据");
        }
    }

    public void lankactivty(String dateto, String datafile_path_sh, String datafile_path_sz) {

        updateDAO.execute("huoyuelank.deleteHuoyuelank", null);
        log.info("huoyuelank has been deleted");
        List<String> ls_shsz = popertiesHelper.getStockCds(datafile_path_sh, datafile_path_sz);
        List<String> stock_detail = null;
        // get the detail of the stocks
        for (int j = 0; j < ls_shsz.size(); j++) {
            Map<String, Object> condition = new HashMap<String, Object>();
            String stockcd = ls_shsz.get(j);
            condition.put("stock_cd", stockcd);

            Ften ften = queryDAO.executeForObject("ften.selectFten", condition, Ften.class);
            if (ften == null) {
                log.info(stockcd + " dosen't exist");
                continue;
            }
            condition.put("record_date_to", dateto);
            condition.put("orderby", "desc");
            condition.put("limit", 30);
            List<Alldata> adls = queryDAO.executeForObjectList("download.searchdownloadResult", condition);

            if (adls == null || adls.size() == 0) {
                continue;
            }
            int i = 1;
            double totdeal = 0;
            double fiveturnover = 0;
            double tenturnover = 0;
            double thirtyturnover = 0;

            for (Alldata ad : adls) {

                totdeal = totdeal + ad.getDeal_lots();

                if (i == 5) {
                    fiveturnover = Caculator.keepRound(totdeal / (ften.getLiutonggu().doubleValue() * 100 * 5), 2);
                }
                if (i == 10) {
                    tenturnover = Caculator.keepRound(totdeal / (ften.getLiutonggu().doubleValue() * 100 * 10), 2);
                }
                if (i == 30) {
                    thirtyturnover = Caculator.keepRound(totdeal / (ften.getLiutonggu().doubleValue() * 100 * 30), 2);
                }
                i++;
            }
            log.info(stockcd + " fiveturnover=" + fiveturnover + " tenturnover=" + tenturnover + " thirtyturnover=" + thirtyturnover);
            Map<String, Object> mp = new HashMap<String, Object>();
            mp.put("stock_cd", stockcd);
            mp.put("fivedayturnover", fiveturnover);
            mp.put("tendayturnover", tenturnover);
            mp.put("thirtydayturnover", thirtyturnover);

            updateDAO.execute("huoyuelank.insertHuoyuelank", mp);
            log.info(stockcd + " has been inserted");


        }


    }

    public List<SearchRecord> gethistoryRecordFromDB(String date) {
        Map<String, Object> con = new HashMap<String, Object>();
        con.put("record_date", date);

        List<SearchRecord> lst = queryDAO.executeForObjectList("SearchRecord.selectAllCond", con);
        return lst;
    }

    public String insertsearchResult(List<SearchRecord> lst) {
        for (SearchRecord rc : lst) {
            Map<String, Object> mp = new HashMap<String, Object>();
            mp.put("stock_cd", rc.getStock_cd());
            mp.put("record_date", rc.getRecord_date());
            mp.put("stock_name", rc.getStock_name());
            mp.put("fullup_cnt", rc.getFullup_cnt());
            mp.put("liutongguben", rc.getLiutongguben());
            mp.put("liutonggudongbl", rc.getLiutonggudongbl());
            mp.put("yeji", rc.getYeji());

            try {
                updateDAO.execute("SearchRecord.insertAll", mp);
            } catch (DataIntegrityViolationException e) {
                System.out.println(rc.getStock_cd() + "is existing");
            }
        }

        return "done";
    }
    static Map<String, Datastorage> datastore;
    static List<String> liangrstore;


    
    public void setDataintoMem(IMap cache){
    	
    	
    	List<Ften> ftenlist = queryDAO.executeForObjectList("ften.selectDataAll", null);

    	List<String> stock_cds= new ArrayList<String>();
    	for (Ften ft : ftenlist) {
            Datastorage ds = new Datastorage();

            ds.setFten(ft);

            String stockcd = ft.getStock_cd();

            Map<String, Object> weekcond = new HashMap<String, Object>();
            weekcond.put("stock_cd", stockcd);
            weekcond.put("limit", 40);
            List<WeekData> weekdatas = queryDAO.executeForObjectList("weekData.selectDataForChecking", weekcond);
            ds.setWeekdatalist(weekdatas);

            Map<String, Object> confalldata = new HashMap<String, Object>();
            confalldata.put("stock_cd", stockcd);
            confalldata.put("record_date_to", Canlendar.getSystemdate());
            confalldata.put("orderby", "desc");
            confalldata.put("limit", 100);

            List<Alldata> listalldata = queryDAO.executeForObjectList("alldata.selectData", confalldata);
            ds.setAlldatalist(listalldata);
            ds.setRecord_date(listalldata.get(0).getRecord_date());
            if("si000001".equals(stockcd)){
            	cache.put("stockdate", listalldata.get(0).getRecord_date());
            }
            cache.put(stockcd, ds);
            stock_cds.add(stockcd);
        }
    	cache.put("stocklist", stock_cds);
    }
 
    public List<SearchRecord> getSearchResultList(int wp1, int wp2, int wp3, int wp4,
            int dp1, int dp2, int dp3, int dp4,
            int kp1, int kp2, int kp3, String kp4, int kp5, int kp6,
            int ckp1, int ckp2, int ckp3, double ckp4, double ckp5, int dwk, int lr,int dayago, int rinei, int gdc) {

        List<SearchRecord> lsr = new ArrayList<>();
        if (lr == 1 && liangrstore == null) {
            liangrstore = queryDAO.executeForObjectList("liangrongtarget.selectDataAll", null);
        }
        if (datastore == null) {
            datastore = new HashMap<String, Datastorage>();
            List<Ften> ftenlist = queryDAO.executeForObjectList("ften.selectDataAll", null);

            for (Ften ft : ftenlist) {
                Datastorage ds = new Datastorage();

                ds.setFten(ft);

                String stockcd = ft.getStock_cd();

                Map<String, Object> weekcond = new HashMap<String, Object>();
                weekcond.put("stock_cd", stockcd);
                weekcond.put("limit", 40);
                List<WeekData> weekdatas = queryDAO.executeForObjectList("weekData.selectDataForChecking", weekcond);
                ds.setWeekdatalist(weekdatas);

                Map<String, Object> confalldata = new HashMap<String, Object>();
                confalldata.put("stock_cd", stockcd);
                confalldata.put("record_date_to", Canlendar.getSystemdate());
                confalldata.put("orderby", "desc");
                confalldata.put("limit", 60);

                List<Alldata> listalldata = queryDAO.executeForObjectList("alldata.selectData", confalldata);
                ds.setAlldatalist(listalldata);

                SearchRecord rsreslut = caculateResult(ds, wp1, wp2, wp3, wp4,
                        dp1, dp2, dp3, dp4,
                        kp1, kp2, kp3, kp4, kp5, kp6,
                        ckp1, ckp2, ckp3, ckp4, ckp5, dwk, lr,dayago,rinei,gdc);
                if (rsreslut != null) {
                    lsr.add(rsreslut);
                }


                datastore.put(stockcd, ds);
            }
        } else {

            for (String stockcd : datastore.keySet()) {

                SearchRecord rsreslut = caculateResult(datastore.get(stockcd), wp1, wp2, wp3, wp4,
                        dp1, dp2, dp3, dp4,
                        kp1, kp2, kp3, kp4, kp5, kp6,
                        ckp1, ckp2, ckp3, ckp4, ckp5, dwk, lr,dayago,rinei,gdc);
                if (rsreslut != null) {
                    lsr.add(rsreslut);
                }


            }
        }




        return lsr;
    }

    private SearchRecord caculateResult(Datastorage ds, int wp1, int wp2, int wp3, int wp4,
            int dp1, int dp2, int dp3, int dp4,
            int kp1, int kp2, int kp3, String kp4, int kp5, int kp6,
            int ckp1, int ckp2, int ckp3, double ckp4, double ckp5, int dwk, int lr, int dayago,int rinei, int gdc) {

        //当日数据
        List<Alldata> listalldata = ds.getAlldatalist();
        double todayprice = listalldata.get(0).getPresent_price().doubleValue();
        double yestodayprice = listalldata.get(0).getYt_close_price().doubleValue();
        double ev = todayprice - Double.parseDouble(listalldata.get(0).getTd_open_price());

        if (!(ckp1 > 0 & ckp2 > 0)) {
            if (ckp1 > 0) {//查阳线
                if (ev < 0) {
                    return null;
                }
            } else if (ckp2 > 0) {//查阴线
                if (ev >= 0) {
                    return null;
                }
            }
            if (ckp1 < 0 && ckp2 < 0) {
                return null;

            }
        }

        double todayav = LogicHelper.caculateAveNDay(listalldata, ckp3, 0);
        if (listalldata.get(0).getPresent_price().doubleValue() < todayav) {
            return null;
        }
        double incr = Caculator.keepRound((todayprice - yestodayprice)
                / yestodayprice * 100, 2);

        if (incr < ckp4 || incr > ckp5) {
            return null;
        }

        // 日线数据
        // 连续多少天的天均线

        double[] daves = new double[dp2 + 1];
        if (listalldata.size() < dp1 + dp2 + 1) {
            return null;
        }
        for (int i = 0; i < daves.length; i++) {

            daves[i] = LogicHelper.caculateAveNDay(listalldata, dp1, i);

        }
        if (!LogicHelper.bfblx(daves, dp4, dp3)) {
            return null;
        };

        // 周线数据
        // 连续多少周的周均线
        List<WeekData> weekdatas = ds.getWeekdatalist();
        double[] wkaves = new double[wp2 + 1];
        if (weekdatas.size() < wp1 + wp2 + 1) {
            return null;
        }
        for (int i = 0; i < wkaves.length; i++) {
            //计算连续wp2周 ，wp1周均线

            wkaves[i] = LogicHelper.caculateAveNWeek(weekdatas, wp1, i);
        }

        if (!LogicHelper.bfblx(wkaves, wp4, wp3)) {
            return null;
        };

        String[] jx = kp4.split(",");

        double kp1v = 0;

        double minprice = 0;
        double maxprice = 0;
        Map<String, Object> mp = null;
        if (dwk > 0) {
            // kp1日前收盘价格
            kp1v = listalldata.get(kp1).getPresent_price().doubleValue();

            mp = Analysis.mmValue(listalldata.subList(kp1, kp2 + 1), kp2 - kp1 + 1);
            // kp2日内最低收盘价格
            minprice = listalldata.get((int) mp.get("min") + kp1).getPresent_price().doubleValue();
            // kp2日内最高收盘价格
            maxprice = listalldata.get((int) mp.get("max") + kp1).getPresent_price().doubleValue();
        } else {
            // kp1周前收盘价格
            kp1v = weekdatas.get(kp1).getClose_price().doubleValue();
            mp = Analysis.mmValueweek(weekdatas.subList(kp1, kp2 + 1), kp2 - kp1 + 1);
            // kp2周内最低收盘价格
            minprice = weekdatas.get((int) mp.get("min") + kp1).getClose_price().doubleValue();
            // kp2周内最高收盘价格
            maxprice = weekdatas.get((int) mp.get("max") + kp1).getClose_price().doubleValue();
        }

        double[] arrjx1 = new double[jx.length];
        double[] arrjx2 = new double[jx.length];
        for (int i = 0; i < jx.length; i++) {
            if (dwk > 0) {
                // 计算kp1日前?日均线
                arrjx1[i] = LogicHelper.caculateAveNDay(listalldata, Integer.parseInt(jx[i]), kp1);
                if (kp3 > 0) {
                    // 计算最低日前?日均线
                    arrjx2[i] = LogicHelper.caculateAveNDay(listalldata, Integer.parseInt(jx[i]), (int) mp.get("min") + kp1);
                } else {
                    // 计算最高日前?日均线
                    arrjx2[i] = LogicHelper.caculateAveNDay(listalldata, Integer.parseInt(jx[i]), (int) mp.get("max") + kp1);
                }

            } else {
                // 计算kp1周前?周均线
                arrjx1[i] = LogicHelper.caculateAveNWeek(weekdatas, Integer.parseInt(jx[i]), kp1);
                if (kp3 > 0) {
                    // 计算最低周前?周均线
                    arrjx2[i] = LogicHelper.caculateAveNWeek(weekdatas, Integer.parseInt(jx[i]), (int) mp.get("min") + kp1);
                } else {
                    // 计算最低周前?周均线
                    arrjx2[i] = LogicHelper.caculateAveNWeek(weekdatas, Integer.parseInt(jx[i]), (int) mp.get("max") + kp1);
                }

            }

            if (kp3 > 0) {//上穿均线
                if (kp1v < arrjx1[i] || minprice > arrjx2[i]) {
                    return null;
                }
            } else {//下穿均线
                if (kp1v > arrjx1[i] || maxprice < arrjx2[i]) {
                    return null;
                }
            }
        }

        Map<String, Object> confalldata = new HashMap<String, Object>();
        confalldata.put("stock_cd", ds.getFten().getStock_cd());
        confalldata.put("record_date_to", Canlendar.getSystemdate());
        confalldata.put("orderby", "desc");
        confalldata.put("limit", kp5);

        List<Alldata> listalldatazt = queryDAO.executeForObjectList("alldata.selectData", confalldata);
        int zt = 0;
        for (int f = 0; f < listalldatazt.size(); f++) {
            if (listalldatazt.get(f).getPresent_price().doubleValue()
                    > 1.095 * listalldatazt.get(f).getYt_close_price().doubleValue()) {
                zt++;

            }
        }
        if (zt < kp6) {
            return null;
        }
        if (lr == 1) {
            if (!liangrstore.contains(ds.getFten().getStock_cd())) {
                return null;
            }
        }
        // 天前算起，日内 最高最低差计算
        if (rinei+dayago > 60 || rinei < 0) {
            return null;
        } else {
            Map<String, Object> mp2 = Analysis.mmValue(listalldata.subList(dayago, dayago+rinei), rinei);
            double minprice2 = 0;
            double maxprice2 = 0;
            minprice2 = listalldata.get((int) mp2.get("min")+dayago).getPresent_price().doubleValue();
            
            maxprice2 = listalldata.get((int) mp2.get("max")+dayago).getPresent_price().doubleValue();
            if ((maxprice2-minprice2)*100/maxprice2<gdc){
                return null;
            }
        }
        SearchRecord rsreslut = new SearchRecord();
        rsreslut.setStock_cd(ds.getFten().getStock_cd());
        rsreslut.setRecord_date(ds.getAlldatalist().get(0).getRecord_date());
        rsreslut.setFullup_cnt(new BigDecimal(zt));
        rsreslut.setLiutongguben(ds.getFten().getLiutonggu());
        rsreslut.setLiutonggudongbl(ds.getFten().getLiutonggudongchigubili());
        rsreslut.setStock_name(ds.getFten().getStock_name());
        rsreslut.setYeji(ds.getFten().getJingzcbenifitrate());

        return rsreslut;
    }

    /**
     * 以行为单位读取文件，常用于读面向行的格式化文件
     */
    private Map<String, Object> readFileByLines(String fileName) {
        File file = new File(fileName);
        BufferedReader reader = null;
        Map<String, Object> mp = new HashMap<String, Object>();
        try {

            reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "GB2312"));

            String tempString = null;
            String meigusy = "";
            String meigujzc = "";
            String meigugjj = "";
            String meiguwfplr = "";
            String liutonggu = "";
            String tongbiincr = "";
            String jingzcbenifitrate = "";
            String suosuhangye = "";
            String liutonggudongchigubili = "";
            String update_date = "";
            String stock_name = "";
            String tempUsedName = "";

            boolean wuxianshoutiaojiangudong = false;

            int line = 1;
            // 一次读入一行，直到读入null为文件结束
            while ((tempString = reader.readLine()) != null) {
                // 显示行号

                if (tempString.contains("更新时间")) {
                    if (mp.containsKey("update_date")) {
                        continue;
                    }
                    update_date = tempString.substring(tempString.lastIndexOf(":") + 1, tempString.lastIndexOf(":") + 11);
                    mp.put("update_date", update_date);

                    continue;
                }


                if (tempString.contains("每股收益 ")) {
                    if (mp.containsKey("meigusy")) {
                        continue;
                    }
                    meigusy = tempString.substring(tempString.indexOf(":") + 1).substring(0, 10).trim();
                    if (meigusy.contains("--")) {
                        return null;
                    }
                    mp.put("meigusy", Double.parseDouble(meigusy));

                }
                if (tempString.contains("目前流通")) {
                    if (mp.containsKey("liutonggu")) {
                        continue;
                    }
                    liutonggu = tempString.substring(tempString.lastIndexOf(":") + 1);
                    if (liutonggu.contains("--")) {
                        return null;
                    }
                    mp.put("liutonggu", Double.parseDouble(liutonggu));

                    continue;
                }
                if (tempString.contains("每股净资产")) {
                    if (mp.containsKey("meigujzc")) {
                        continue;
                    }
                    meigujzc = tempString.substring(tempString.indexOf(":") + 1).substring(0, 10).trim();
                    if (meigujzc.contains("--")) {
                        return null;
                    }
                    try {
                        mp.put("meigujzc", Double.parseDouble(meigujzc));

                    } catch (Exception e) {
                        System.out.println("");
                    }
                    continue;
                }
                if (tempString.contains("每股公积金")) {
                    if (mp.containsKey("meigugjj")) {
                        continue;
                    }
                    meigugjj = tempString.substring(tempString.indexOf(":") + 1).substring(0, 10).trim();
                    if (meigugjj.contains("--")) {
                        return null;
                    }
                    mp.put("meigugjj", Double.parseDouble(meigugjj));

                    continue;
                }
                if (tempString.contains("每股未分配利润")) {
                    if (mp.containsKey("meiguwfplr")) {
                        continue;
                    }
                    meiguwfplr = tempString.substring(tempString.indexOf(":") + 1).substring(0, 10).trim();
                    if (meiguwfplr.contains("--")) {
                        return null;
                    }
                    mp.put("meiguwfplr", Double.parseDouble(meiguwfplr));

                }


                if (tempString.contains("净利润同比增长")) {
                    if (mp.containsKey("tongbiincr")) {
                        continue;
                    }
                    tongbiincr = tempString.substring(tempString.lastIndexOf(":") + 1);
                    if (tongbiincr.contains("--")) {
                        mp.put("tongbiincr", new Double(-10000));
                    } else {
                        mp.put("tongbiincr", Double.parseDouble(tongbiincr));
                    }

                    continue;

                }
                if (tempString.contains("净资产收益率")) {
                    if (mp.containsKey("jingzcbenifitrate")) {
                        continue;
                    }
                    jingzcbenifitrate = tempString.substring(tempString.lastIndexOf(":") + 1);
                    if (jingzcbenifitrate.contains("--")) {
                        mp.put("jingzcbenifitrate", new Double(-10000));
                    } else {
                        mp.put("jingzcbenifitrate", Double.parseDouble(jingzcbenifitrate));
                    }

                    continue;
                }

                if (tempString.contains("曾用名")) {
                    tempUsedName = tempUsedName + tempString;
                    continue;
                }
                if (!tempUsedName.equals("")) {
                    tempUsedName = tempUsedName + tempString;
                }
                if (tempString.contains("大智慧金融交易")) {

                    if (!tempUsedName.equals("")) {

                        if (tempUsedName.contains("Sk")) {
                            if (tempUsedName.lastIndexOf("Sk") > tempUsedName.lastIndexOf("->")) {

                                return null;
                            }
                        }
                    }

                    break;
                }

                if (tempString.contains("所属行业:")) {
                    try {
                        stock_name = tempString.substring(0, tempString.indexOf("("));
                    } catch (Exception e) {
                        System.out.println("");
                    }
                    mp.put("stock_name", stock_name);
                    continue;
                }

                if (tempString.contains("证监会行业")) {
                    suosuhangye = tempString.substring(tempString.indexOf(":") + 1);
                    suosuhangye = suosuhangye.substring(0, suosuhangye.indexOf(" "));
                    mp.put("suosuhangye", suosuhangye);
                    break;
                }
                if (tempString.contains("前十名无限售条件")) {
                    wuxianshoutiaojiangudong = true;
                    continue;
                }
                if (wuxianshoutiaojiangudong == true
                        && tempString.contains("总    计")) {

                    int idx = tempString.indexOf("%");
                    if (idx < 0) {
                        mp.put("liutonggudongchigubili", 0.0);
                        break;
                    }
                    liutonggudongchigubili = tempString.substring(idx - 5);
                    liutonggudongchigubili = liutonggudongchigubili.substring(0, liutonggudongchigubili.length() - 1);
                    mp.put("liutonggudongchigubili", Double.parseDouble(liutonggudongchigubili));
                    break;
                }


                line++;
            }
            reader.close();

            return mp;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                }
            }
        }
    }

    public String insertLiangrongTargetTable(String filepath) {
        File file = new File(filepath);
        BufferedReader reader = null;
        Map<String, Object> mp = new HashMap<String, Object>();
        updateDAO.execute("liangrongtarget.deleteLiangrongtarget", null);
        try {
            reader = new BufferedReader(new InputStreamReader(new FileInputStream(file), "GB2312"));
            String tempString = null;
            int line = 1;
            // 一次读入一行，直到读入null为文件结束
            while ((tempString = reader.readLine()) != null) {
                // 显示行号
                if (tempString.startsWith("00")
                        || tempString.startsWith("60")
                        || tempString.startsWith("30")) {
                    updateDAO.execute("liangrongtarget.insertLiangrongtarget", tempString.trim());
                    log.info("liangrong data has been inserted :" + tempString);
                }
                line++;
            }
            reader.close();
//            return mp;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                }
            }
        }
        return "done";
    }

    public String writeZhangTBfile(String filepath) {
        File file = new File(filepath);
        String lastLine = "";
        try {
            lastLine = readLastLine(file, "gbk");
        } catch (IOException ex) {
            java.util.logging.Logger.getLogger(Stock2DB.class.getName()).log(Level.SEVERE, null, ex);
        }
        String[] resarr;
        String lastdate = "19880101";
        if (lastLine != null && !lastLine.equals("")) {
            resarr = lastLine.split(",");
            lastdate = Canlendar.formaterString((resarr[1]));
        }


        List<String> datelst = queryDAO.executeForObjectList("alldata.selectDate", null);

        List<Ztgs> ztgslst = new ArrayList();
        for (int i = 0; i < datelst.size(); i++) {
            if (lastdate.compareTo(datelst.get(i)) >= 0) {
                continue;
            } else {

                Integer ztgs = queryDAO.executeForObject("alldata.countZToftargetDate", datelst.get(i), Integer.class);
                Ztgs ztgsbean = new Ztgs();
                ztgsbean.setRecord_date(datelst.get(i));
                ztgsbean.setZtgs(ztgs);
                ztgslst.add(ztgsbean);

            }
        }

        StringBuilder sb = new StringBuilder();
        try {
            File f = new File(filepath);
            if (!f.exists()) {
                f.createNewFile();//不存在则创建
            }
            BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
            for (Ztgs entry : ztgslst) {
                sb.append("ZTGS");
                sb.append(",");
                sb.append(entry.getRecord_date().replace("-", ""));
                sb.append(",");
                sb.append(entry.getZtgs().doubleValue());
                sb.append(",");
                sb.append(entry.getZtgs().doubleValue());
                sb.append(",");
                sb.append(entry.getZtgs().doubleValue());
                sb.append(",");
                sb.append(entry.getZtgs().doubleValue());
                sb.append(",");
                sb.append(entry.getZtgs().doubleValue());
                sb.append("\r\n");

            }
            output.write(sb.toString());
            output.close();
            log.info("file writing is finished");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "done";
    }

    public String readLastLine(File file, String charset) throws IOException {
        if (!file.exists() || file.isDirectory() || !file.canRead()) {
            return null;
        }
        RandomAccessFile raf = null;
        try {
            raf = new RandomAccessFile(file, "r");
            long len = raf.length();
            if (len == 0L) {
                return "";
            } else {
                long pos = len - 1;
                while (pos > 0) {
                    pos--;
                    raf.seek(pos);
                    if (raf.readByte() == '\n') {
                        break;
                    }
                }
                if (pos == 0) {
                    raf.seek(0);
                }
                byte[] bytes = new byte[(int) (len - pos)];
                raf.read(bytes);
                if (charset == null) {
                    return new String(bytes);
                } else {
                    return new String(bytes, charset);
                }
            }
        } catch (FileNotFoundException e) {
        } finally {
            if (raf != null) {
                try {
                    raf.close();
                } catch (Exception e2) {
                }
            }
        }
        return null;
    }
}
