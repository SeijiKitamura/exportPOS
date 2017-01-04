#!/bin/bash

cd `dirname $0`

#######################################################
# 変数

BEFORE_DAY=3            #何日前からのデータを出力するか
SERVER="POS"            #/etc/odbc.iniと同じラベルにする
CSVDIR="csv/primestore" #CSV保存先ディレクトリ
#######################################################

if [ ! -e ${CSVDIR} ]; then
  mkdir -p ${CSVDIR}
fi

if [ ! -e POS.ini ]; then
  echo "POS.iniが存在しません"
  exit 1
fi

. POS.ini

#日付確定
SQLDAY="CONVERT(nvarchar(10),DATEADD(DAY,-${BEFORE_DAY},GETDATE()),111)"

table="TB_JAN_MST"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where FINAL_UPDATE_DAY_TIME>=${SQLDAY} order by JAN_CD" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_JAN_TZ_D_RST
table="TB_JAN_TZ_D_RST"
order="DATA_DATE_DAY,STORE_CD,JAN_CD,TZ_NO,COUNTER_CD"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where DATA_DATE_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_JAN_DAY_RST
table="TB_JAN_DAY_RST"
order="DATA_DATE_DAY,STORE_CD,JAN_CD,COUNTER_CD"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where DATA_DATE_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_GDCP_TZ_D_RST
table="TB_GDCP_TZ_D_RST"
order="DATA_DATE_DAY,STORE_CD,GDCP_KIND,GDCP_CD,TZ_NO,COUNTER_CD"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where DATA_DATE_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_GDCP_DAY_RST
table="TB_GDCP_DAY_RST"
order="DATA_DATE_DAY,STORE_CD,GDCP_KIND,GDCP_CD,COUNTER_CD"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where DATA_DATE_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_DEAL_DAY_RST
table="TB_DEAL_DAY_RST"
order="DATA_DATE_DAY,STORE_CD,DATA_KIND,REGI_FLOOR_NO,DEAL_CD,DEAL_SUB_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where DATA_DATE_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_CLOSE
table="TB_ELEC_JOURNAL_CLOSE"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_CREDIT
table="TB_ELEC_JOURNAL_CREDIT"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SERIES_NO,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_DEAL
table="TB_ELEC_JOURNAL_DEAL"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SERIES_NO,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_ITEM
table="TB_ELEC_JOURNAL_ITEM"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SERIES_NO,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_MAM
table="TB_ELEC_JOURNAL_MAM"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SERIES_NO,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}

#TB_ELEC_JOURNAL_PNT
table="TB_ELEC_JOURNAL_PNT"
order="BUSINESS_DAY,STORE_CD,REGI_NO,DEAL_DATE,DEAL_TIME,DEAL_SERIES_NO,DEAL_SEQ_NO,FILE_TYPE_SEQ_NO"
echo "exporting ${table}..."
freebcp "select * from ${DBNAME}..${table} where BUSINESS_DAY>=${SQLDAY} order by ${order}" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
