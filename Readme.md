# docker-mirakurun-epgstation
[Mirakurun](https://github.com/Chinachu/Mirakurun) + [EPGStation](https://github.com/l3tnun/EPGStation) の Docker コンテナ

## 更新情報
mirakurunが仕様変更したタイミングでこちらも中身を更新しています。以前バージョンからご使用の場合は一度コンテナを終了し`mirakurun/data`内のjsonをymlに拡張子を変更してください。
上記mirakurun側での実装ミスだったようです2020/7/9以前から利用している方は再度ymlをjsonに戻してください。

## 前提条件
- Docker, docker-compose の導入が必須
- ホスト上の pcscd は停止する
- PT3用に設定済みなのでPT3での使用を想定

## インストール手順

```sh
$ git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
$ cd docker-mirakurun-epgstation
$ cp docker-compose-sample.yml docker-compose.yml
$ cp epgstation/config/config.sample.json epgstation/config/config.json
$ sudo docker-compose pull
$ sudo docker-compose build

#チャンネル設定
$ vim mirakurun/conf/channels.yml

#コメントアウトされている restart や user の設定を適宜変更する
$ vim docker-compose.yml
```

## 起動

```sh
$ sudo docker-compose up -d
```
mirakurun の EPG 更新を待ってからブラウザで http://DockerHostIP:8888 へアクセスし動作を確認する

## 停止

```sh
$ sudo docker-compose down
```

## 設定

### Mirakurun

* ポート番号: 40772

### EPGStation

* ポート番号: 8888
* ポート番号: 8889

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
