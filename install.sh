#!/bin/bash

cd `dirname $0`

sudo apt-get install -y unixodbc unixodbc-dev freetds-dev freetds-bin tdsodbc

sudo sh -c "cat << EOF >> /etc/odbcinst.ini
[ODBC]
Trace = No
TraceFile = /tmp/odbc.log

[FreeTDS]
Desctiption = FreeTDS
Driver = /usr/lib/arm-linux-gnueabihf/odbc/libtdsodbc.so
Setup = /usr/lib/arm-linux-gnueabihf/odbc/libtdsodbc.so
UsageCount = 1
EOF"

sudo sh -c "cat << EOF >> /etc/odbc.ini
[POS]
Driver = FreeTDS
Server = SQLServer のIPアドレス
Port = 1433
TDS_Version = 7.0
EOF"

sudo sh -c "cat << EOF >> /etc/freetds/freetds.conf
[POS]
 database = DB_ROCKY_B_001
 host = SQLServer のIPアドレス
 port = 1433
 tds version = 7.0
 client charset = UTF-8
EOF"
