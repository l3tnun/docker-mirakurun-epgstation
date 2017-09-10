docker-mirakurun-epgstation
====

[Mirakurun](https://github.com/Chinachu/Mirakurun) + [EPGStation](https://github.com/l3tnun/EPGStation) の Docker コンテナ

## 前提条件

Docker, docker-compose, nvidia-docker の導入が必須

PT3 + [m-tsudo/pt3](https://github.com/m-tsudo/pt3) の組み合わせを想定

ホスト上の pcscd は停止する

## インストール手順

```
$ git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
$ cd docker-mirakurun-epgstation
$ sudo docker-compose pull
$ sudo docker-compose build

#チャンネル設定
$ vim mirakurun/conf/channels.yml

#コメントアウトされている restart や user の設定を適宜変更する
$ vim docker-compose.yml

#同様に設定を適宜変更する
$ vim startup.sh
```

## 起動

```
# mysql の user & データベース生成のために起動 (初回だけ)
# 起動が一通り完了したら Ctrl + c で停止
$ sudo docker-compose up
# nvidia-docker を使用して起動
# sudo ./startup.sh
```
mirakurun の EPG 更新を待ってからブラウザで http://DockerHostIP:8888 へアクセスし動作を確認する

## 停止

```
$ sudo ./stop.sh
```

## 設定

### Mirakurun

* ポート番号: 40772

### EPGStation

* ポート番号: 40772

### 各種ファイル保存先

* 録画データ

```./recorded```

* サムネイル

```./epgstation/thumbnail```

* 予約情報と HLS 配信時の一時ファイル

```./epgstation/data```

* EPGStation 設定ファイル

```./epgstation/config```

* EPGStation のログ

```./epgstation/logs```
