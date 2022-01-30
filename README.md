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
  - 旅行中の旅程組み換えをネットワーク接続無しで行なえます

## インストール

地図データが必要です。[Geofabrik](https://download.geofabrik.de/asia/japan.html)等のプロバイダから入手してください。その後 Docker Compose で導入できます。

1. `wget https://download.geofabrik.de/asia/japan-latest.osm.pbf`
1. `docker-compose build`
1. `docker-compose up -d app`

- 初回起動時は地図データのインポートが行われます
  - マシンスペックにもよりますが数時間かかります
  - メモリを大量に消費しますので swapfile を追加すると良いでしょう
    - 32GB メモリ搭載機で swap 無しの場合 OOM が発生しました
- インポート完了後は使用できますが、バックグラウンドで地図タイルのバッチ生成処理が走るためしばらく CPU 使用率が高くなります

## 利用方法

→[利用方法](https://portfolio.suzuran.dev/trs)

## ライセンス

[MIT](https://choosealicense.com/licenses/mit/)
