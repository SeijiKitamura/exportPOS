#SQLServer CSV変換プログラム

上位DBから必要なテーブルをCSV出力するために作成しました。
上位側はMicrosoft SQLServerとなっています。
このプログラムを走らせるPCはRaspberryPiを想定しています。

## プログラム構成
CSVデータが作成される流れは以下のとおりです。

```
SQLSERVER -> FREETDS -> UNIXODBC -> freebcp(bash) -> csv
```

この仕組みを使って以下のプログラムが用意されています。

### primestore.sh
上位側テーブルをコピーしたDB用CSVバッチ。
上位側は定められた期間(おおよそ1年間)しかデータを保存しないため、復旧用として出力しています。

#### 変数
```
BEFORE_DAY=3            #何日前からのデータを出力するか
CSVDIR="csv/primestore" #CSV保存先ディレクトリ
```

実行すると以下のCSVが作成されます。
```
TB_GDCP_MST
TB_GDCP_DAY_RST
TB_GDCP_TZ_D_RST
TB_JAN_MST
TB_JAN_DAY_RST
TB_JAN_TZ_D_RST
TB_DEAL_DAY_RST
TB_ELEC_JOURNAL_CLOSE
TB_ELEC_JOURNAL_CREDIT
TB_ELEC_JOURNAL_DEAL
TB_ELEC_JOURNAL_ITEM
TB_ELEC_JOURNAL_MAM
TB_ELEC_JOURNAL_PNT
```

### ultradbd.sh
オリジナルデータベース用CSV作成バッチ。

#### 変数
```
BEFORE_DAY=3            #何日前からのデータを出力するか
CSVDIR="csv/ultradb"    #CSV保存先ディレクトリ
```

実行すると以下のCSVが作成されます。
```
dpsmas      マスタ(メジャー)
linmas      マスタ(部門)
clsmas      マスタ(クラス)
janmas      マスタ(単品)
dpsdaysale  日別売上(メジャー)
lindaysale  日別売上(部門)
clsdaysale  日別売上(クラス)
jandaysale  日別売上(単品)
dpshoursale 時間帯別売上(メジャー)
linhoursale 時間帯別売上(部門)
clshoursale 時間帯別売上(クラス)
janhoursale 時間帯別売上(単品)
```

### POS.ini
POS.ini.defaultをコピーしてPOS.iniファイルを作成してください。
```bash
cd
cd exportPOS
cp POS.ini.default POS.ini
vim POS.ini
```

POS.iniは以下のとおりです。
```
DBUSER=""  #SQLServer DB接続ユーザー名
PASS=""    #SQLServer DB接続パスワード
DBNAME=""  #SQLServer DB名
```

### フォーマットファイル
本家SQL Serverではbcp出力の際フォーマットファイルを使用するそうです。
(僕は使ったことはないのでよくわからないのですが...)
ところがfreebcpの場合、このフォーマットファイルの出力がうまくできません。
フォーマットファイルがなくてもCSV出力はできますが、nullを許可している列
については注意が必要です。

### 注意点
freebcpを使用して上位側に接続し、必要な情報を抽出します。
抽出する列順については、受け側のDBに合わせる必要があります。
列順を変更する場合には、「freebcp "select 」以降に列名をカンマ区切りで
記入してください。

## ダウンロード
コンソールを開いて以下のコマンドを実行してください。

```bash
  cd
  git clone あとで追加
```

## ディレクトリ構成
```
 /home/ユーザー名/exportPOS
                   |- csv
                   |   |- primestore (CSV保存ディレクトリ)
                   |   |- ultradb    (CSV保存ディレクトリ)
                   |
                   |- crontab.txt
                   |- install.sh
                   |- primestore.sh
                   |- ultradb.sh
                   |- POS.ini
```

## インストール内容
(1)apt-get  
以下のパッケージをインストールします。  
```bash
unixodbc
unixodbc-dev
freetds-dev
freetds-bin
tdsodbc
```
(2)/etc/odbcinst.iniの設定  
(3)/etc/odbc.iniの設定  
(4)/etc/freetds/freetds.conの設定  

## インストール前の設定
install.shを開いて以下の項目を適切な値に変更してください。

### odbcinst.iniの設定
/etc/odbcinst.iniに必要な項目を追記します。  

```bash
Driver = libtdsodbc.soのフルパス
Setup  = libtdsodec.soのフルパス
```

### odbc.iniの設定
/etc/odbc.iniに必要な項目を追記します。

```bash
Server = SQLServer のIPアドレス
TDS Version = SQL Serverのバージョン
```

### freetds.confの設定
 /etc/freetds/freetds.confに変更が必要な項目を登録します。

```bash
database = SQLServer DB名
host = SQLServerのIPアドレス
port = 1433
tds version = SQLServerのバージョン
client charset = UTF-8
```
## インストール方法
ターミナルにて以下のコマンドを実行してください。インストールを開始します。
```bash
cd
./exportPOS/install.sh
```
### 注意事項
libtdsodbc.soの保存先ディレクトリがOSによって違う場合があります。  
その場合は以下のコマンドを実行して表示された場所に書き換えてください。  
```bash
sudo find . -type f -name "libtdsodbc.so"
```

上記で表示されたパスを/etc/odbcinst.iniの[FreeTDS]に記入
```bash
Driver = libtdsodbc.soのフルパス
Setup =  libtdsodbc.soのフルパス
```

## Raspberry セットアップ
### OSセットアップ
インターネットに掲載されている通りなので詳細は割愛します。

### 設定
[Raspberryセットアップ](https://github.com/SeijiKitamura/raspberry)を参照してください。

## ネットワークについて
僕の場合、上位側セグメントとLAN側セグメントが違うためLANポートが2つ搭載されているPC
が必要です。

以下、Raspberryでは以下のように設定しています。
```
有線LANポート 上位側IPアドレス
無線LAN       LAN側IPアドレス
```

