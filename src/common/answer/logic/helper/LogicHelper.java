package common.answer.logic.helper;

import common.answer.bean.dto.Alldata;
import common.answer.bean.dto.WeekData;
import java.util.List;

import org.apache.commons.configuration.PropertiesConfiguration;


import common.answer.util.Caculator;

public class LogicHelper {

    public static boolean isQuit(List<String> stock_detail) {
        if (stock_detail == null) {
            return true;
        }
        return false;
    }

    public static boolean isOpening(List<String> stock_detail) {
        if (stock_detail == null) {//quit from the market
            return false;
        }
        if (("0.00").equals(stock_detail.get(1)) || ("0.000").equals(stock_detail.get(1))) {
            return false;
        }
        return true;
    }

    public static boolean isStock(List<String> stock_detail) {
        if (stock_detail.size() < 32) {
            return false;
        }
        return true;
    }

    public static double caculatePurebenifit(double curprice, double bought_price, int bought_lots,
            PropertiesConfiguration stocksProperties) {

        double handlecharge = caculatehandCharge(bought_price, bought_lots, stocksProperties);

        double purebenifit = Caculator.keepRound(
                (curprice - bought_price) * bought_lots - handlecharge, 2);

        return purebenifit;
    }

    public static double caculatehandCharge(double bought_price, int bought_lots, PropertiesConfiguration stocksProperties) {
        double commission_rate = stocksProperties.getDouble("commission_rate");
        double charge_rate = stocksProperties.getDouble("charge_rate");


        double handlecharge = bought_price * bought_lots * commission_rate;

        if (bought_price * bought_lots * charge_rate < 5) {
            handlecharge = handlecharge + 10;
        } else {
            handlecharge = handlecharge + bought_price * bought_lots * charge_rate * 2;
        }
        return Caculator.keepRound(handlecharge, 2);
    }

    public static double caculateIncrease(double org, double now) {

        return Caculator.keepRound((now - org) * 100 / org, 2);
    }

    private LogicHelper() {
    }

    public static double caculateAveNWeek(List<WeekData> allWeeklist, int n, int m) {
        double pricemount = 0.0;
        if (allWeeklist.size() < n) {
            return 0;
        }
        for (int t = m; t < n+m; t++) {
            WeekData alldata = allWeeklist.get(t);
            pricemount = pricemount + alldata.getClose_price().doubleValue();

        }
        double average = pricemount / n;
        return average;
    }

    public static double caculateAveNDay(List<Alldata> alldaylist, int n, int m) {
        double pricemount = 0.0;
        if (alldaylist.size() < n) {
            return 0;
        }
        for (int t = m; t < n+m; t++) {
            Alldata alldata = alldaylist.get(t);
            pricemount = pricemount + alldata.getPresent_price().doubleValue();

        }
        double average = pricemount / n;
        return average;
    }

    public static boolean bfblx(double[] arr, int direction, int percent) {
        int cnt = 0;
        for (int i = 0; i < arr.length - 1; i++) {
            if (arr[i] >= arr[i + 1]) {
                cnt++;
            }
        }

        if (cnt * 100 / (arr.length - 1) > percent) {
            if (direction >= 0) {
                return true;
            }else{
                return false;
            }
        }else{
             if (direction >= 0) {
                return false;
            }else{
                return true;
            }
        }

    }
}
