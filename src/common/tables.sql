DROP TABLE IF EXISTS `alldata`;
CREATE TABLE `alldata` (
  `stock_cd` char(8) NOT NULL ,
  `td_open_price` decimal(7,3) NOT NULL default '0.00',
  `yt_close_price` decimal(7,3) NOT NULL default '0.00',
  `present_price` decimal(7,3) NOT NULL default '0.00',
  `td_highest_price` decimal(7,3) NOT NULL default '0.00',
  `td_lowest_price` decimal(7,3) NOT NULL default '0.00',
  `bdb_price` decimal(7,3) NOT NULL default '0.00',
  `bds_price` decimal(7,3) NOT NULL default '0.00',
  `deal_lots` decimal(16,0) NOT NULL default '0',
  `deal_ammount` decimal(16,0) NOT NULL default '0',
  `bdb1_lots` decimal(16,0) NOT NULL default '0',
  `bdb1_price` decimal(7,3) NOT NULL default '0.00',
  `bdb2_lots` decimal(16,0) NOT NULL default '0',
  `bdb2_price` decimal(7,3) NOT NULL default '0.00',
  `bdb3_lots` decimal(16,0) NOT NULL default '0',
  `bdb3_price` decimal(7,3) NOT NULL default '0.00',
  `bdb4_lots` decimal(16,0) NOT NULL default '0',
  `bdb4_price` decimal(7,3) NOT NULL default '0.00',
  `bdb5_lots` decimal(16,0) NOT NULL default '0',
  `bdb5_price` decimal(7,3) NOT NULL default '0.00',
  `bds1_lots` decimal(16,0) NOT NULL default '0',
  `bds1_price` decimal(7,3) NOT NULL default '0.00',
  `bds2_lots` decimal(16,0) NOT NULL default '0',
  `bds2_price` decimal(7,3) NOT NULL default '0.00',
  `bds3_lots` decimal(16,0) NOT NULL default '0',
  `bds3_price` decimal(7,3) NOT NULL default '0.00',
  `bds4_lots` decimal(16,0) NOT NULL default '0',
  `bds4_price` decimal(7,3) NOT NULL default '0.00',
  `bds5_lots` decimal(16,0) NOT NULL default '0',
  `bds5_price` decimal(7,3) NOT NULL default '0.00',
  `record_date` char(10) NOT NULL,
  `record_time` char(8) NOT NULL,
  PRIMARY KEY (`stock_cd`,`record_date`,`record_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `keyvalue`;
CREATE TABLE `keyvalue` (
`keyee` varchar(50),
`valuee` varchar(500),
PRIMARY KEY (`keyee`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ften`;
CREATE TABLE `ften` (
  `stock_cd` VARCHAR(8) NOT NULL,
  `stock_name` VARCHAR(8) NOT NULL,
   `meigusy` DECIMAL(16,2) default '0.00',
   `meigujzc` DECIMAL(16,2) default '0.00',
  `meigugjj` DECIMAL(16,2) default '0.00',
    `meiguwfplr` DECIMAL(16,2) default '0.00',
  `liutonggu` DECIMAL(16,2) default '0.00',
  `tongbiincr` DECIMAL(10,2),
  `jingzcbenifitrate` DECIMAL(10,2),
  `liutonggudongchigubili` DECIMAL(10,2),
  `suosuhangye` varchar(200),
  `update_date` CHAR(10) NOT NULL,
  PRIMARY KEY (`stock_cd`,`update_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `week_data`;
CREATE TABLE `week_data` (
  `stock_cd` VARCHAR(10) NOT NULL,
  `record_date` VARCHAR(10) NOT NULL,
  `open_price` DECIMAL(16,3) default '0',
  `close_price` DECIMAL(16,3) default '0',
  `deal_lots` DECIMAL(16,3) default '0',
  `high_price` DECIMAL(16,3),
  `low_price` DECIMAL(16,3),
  PRIMARY KEY (`stock_cd`,`record_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;