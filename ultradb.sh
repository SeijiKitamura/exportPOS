#!/bin/bash

cd `dirname $0`

#######################################################
# 変数

BEFORE_DAY=3            #何日前からのデータを出力するか
SERVER="POS"            #/etc/odbc.iniと同じラベルにする
CSVDIR="csv/ultradb"    #CSV保存先ディレクトリ
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

#dpsmas
table="dpsmas"
echo "exporting ${table}...."
freebcp "select LINK_CD,GDCP_CD,GDCP_NAME from ${DBNAME}..TB_GDCP_MST where GDCP_KIND=6 order by LINK_CD,GDCP_CD" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#linmas
table="linmas"
echo "exporting ${table}...."
freebcp "select 1,GDCP_CD,GDCP_NAME,LINK_CD from ${DBNAME}..TB_GDCP_MST where GDCP_KIND=7 order by LINK_CD,GDCP_CD" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#clsmas
table="clsmas"
echo "exporting ${table}...."
freebcp "select 1,GDCP_CD,GDCP_NAME,LINK_CD from ${DBNAME}..TB_GDCP_MST where GDCP_KIND=8 order by LINK_CD,GDCP_CD" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#dpsdaysale
table="dpsdaysale"
echo "exporting ${table}...."
freebcp "
select
 convert(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,GDCP_CD
,SALES_ITM_TOTAL_DAY
,SALES_AMT_TOTAL_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,ABD_ITM_DAY
,ABD_AMT_DAY
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_DAY_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=6
order by
 DATA_DATE_DAY
,STORE_CD
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#lindaysale
table="lindaysale"
echo "exporting ${table}...."
freebcp "
select
 convert(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,GDCP_CD
,SALES_ITM_TOTAL_DAY
,SALES_AMT_TOTAL_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,ABD_ITM_DAY
,ABD_AMT_DAY
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_DAY_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=7
order by
 DATA_DATE_DAY
,STORE_CD
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#clsdaysale
table="clsdaysale"
echo "exporting ${table}...."
freebcp "
select
 convert(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,GDCP_CD
,SALES_ITM_TOTAL_DAY
,SALES_AMT_TOTAL_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,ABD_ITM_DAY
,ABD_AMT_DAY
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_DAY_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=8
order by
 DATA_DATE_DAY
,STORE_CD
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"


#dpshoursale
table="dpshoursale"
echo "exporting ${table}"
freebcp "
select
 CONVERT(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,TZ_NO
,GDCP_CD
,SALES_ITM_DAY
,SALES_AMT_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,0
,0
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_TZ_D_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=6
order by
 DATA_DATE_DAY
,STORE_CD
,TZ_NO
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#linhoursale
table="linhoursale"
echo "exporting ${table}"
freebcp "
select
 CONVERT(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,TZ_NO
,GDCP_CD
,SALES_ITM_DAY
,SALES_AMT_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,0
,0
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_TZ_D_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=7
order by
 DATA_DATE_DAY
,STORE_CD
,TZ_NO
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#clshoursale
table="clshoursale"
echo "exporting ${table}"
freebcp "
select
 CONVERT(nvarchar(10),DATA_DATE_DAY,111)
,STORE_CD
,TZ_NO
,GDCP_CD
,SALES_ITM_DAY
,SALES_AMT_DAY
,CUT_ITM_REGI_DAY
,CUT_AMT_REGI_DAY
,0
,0
,SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_GDCP_TZ_D_RST
where
DATA_DATE_DAY>=${SQLDAY}
and GDCP_KIND=8
order by
 DATA_DATE_DAY
,STORE_CD
,TZ_NO
,GDCP_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#janmas
table="janmas"
echo "exporting ${table}"
freebcp "
select
 1
,0
,CLA8_CD
,JAN_CD
,JAN_NAME
,SPEC_NAME
,NORMAL_SD_U_PRICE
,NOW_U_PRICE_FACT_SD_U_PRICE
,COST_PRICE
,NOW_COST_PRICE
,0
,START_DAY
,FINAL_SALES_DAY
from ${DBNAME}..TB_JAN_MST
where
FINAL_UPDATE_DAY_TIME>=${SQLDAY}
order by
 CLA8_CD
,JAN_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#jandaysale
table="jandaysale"
echo "exporting ${table}"
freebcp "
select
 CONVERT(nvarchar(10),t.DATA_DATE_DAY,111)
,t.STORE_CD
,t1.CLA8_CD
,t.JAN_CD
,t.SALES_ITM_TOTAL_JAN_DAY
,t.SALES_AMT_TOTAL_JAN_DAY
,t.CUT_ITM_REGI_JAN_DAY
,t.CUT_AMT_REGI_JAN_DAY
,t.ABD_ITM_JAN_DAY
,t.ABD_AMT_JAN_DAY
,t.SALES_CST_JAN_DAY
,0
,0
from ${DBNAME}..TB_JAN_DAY_RST as t
inner join ${DBNAME}..TB_JAN_MST as t1 on
t.JAN_CD = t1.JAN_CD
where
 t.DATA_DATE_DAY>=${SQLDAY}
order by
 t.DATA_DATE_DAY
,t.STORE_CD
,t1.CLA8_CD
,t.JAN_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"

#janhoursale
table="janhoursale"
echo "exporting ${table}"
freebcp "
select
 CONVERT(nvarchar(10),t.DATA_DATE_DAY,111)
,t.STORE_CD
,t.TZ_NO
,t1.CLA8_CD
,t.JAN_CD
,t.SALES_ITM_JAN_DAY
,t.SALES_AMT_JAN_DAY
,t.CUT_ITM_REGI_JAN_DAY
,t.CUT_AMT_REGI_JAN_DAY
,0
,0
,t.SALES_CST_DAY
,0
,0
from ${DBNAME}..TB_JAN_TZ_D_RST as t
inner join ${DBNAME}..TB_JAN_MST as t1 on
t.JAN_CD = t1.JAN_CD
where
 t.DATA_DATE_DAY>=${SQLDAY}
order by
 t.DATA_DATE_DAY
,t.STORE_CD
,t.TZ_NO
,t1.CLA8_CD
,t.JAN_CD
" queryout ${CSVDIR}/${table}.csv -c -t, -S ${SERVER} -U ${DBUSER} -P ${PASS}
echo "finished ${table}!"
