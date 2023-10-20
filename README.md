# trip-routing-system

[![Ruby](https://github.com/keyasuda/trip-routing-system/actions/workflows/ruby.yml/badge.svg)](https://github.com/keyasuda/trip-routing-system/actions/workflows/ruby.yml)

## 概要

旅行計画用システムです。

### 主な機能

- 旅行日程の作成
- 訪問順序の自動最適化
- iCalendar 形式でのエクスポート
  - Google カレンダー等へのインポートが可能
- オフライン動作
  - インストールすれば旅行中の旅程組み換えをネットワーク接続無しで行なえます

## インストール

地図データが必要です。[Geofabrik](https://download.geofabrik.de/asia/japan.html)等のプロバイダから入手してください。その後 Docker Compose で導入できます。

1. `wget https://download.geofabrik.de/asia/japan-latest.osm.pbf`
1. `docker compose build`
1. `docker compose up`
1. http://localhost:3009 を開く

- 初回起動時は地図データのインポートが行われます
  - マシンスペックにもよりますが数時間かかります
  - メモリを大量に消費しますので swapfile を追加すると良いでしょう
    - 32GB メモリ搭載機で swap 無しの場合 OOM が発生しました

### 地図タイルの事前生成

```
$ docker exec -it trip_routing_system-openstreetmap-tile-server-1 bash

$ render_list -a -n $THREADS -z 0 -Z 9
$ wget -O /data/tiles/render_list_geo.pl https://raw.githubusercontent.com/SomeoneElseOSM/render_list_geo.pl/master/render_list_geo.pl
$ chmod u+x /data/tiles/render_list_geo.pl
$ /data/tiles/render_list_geo.pl -n $THREADS -z 10 -Z 15 -x 117.817 -X 158.643 -y 19.849 -Y 51.069
```

## 利用方法

→[利用方法](https://portfolio.suzuran.dev/trs)

## ライセンス

[MIT](https://choosealicense.com/licenses/mit/)
