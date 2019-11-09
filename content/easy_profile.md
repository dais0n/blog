+++
categories = ["devops"]
date = "2019-11-09"
tags = ["devops"]
draft = false
author = "dais0n"
title = "プロファイルを気軽にかけれるようにしておくのが大事だなぁ"
+++

ただのメモ

## はじめに
先日、ある同じような処理をする新旧システムがあり、新システムの方がレイテンシが悪いとのことで調査した時、 古いシステムと新しいシステムの大きな違いはDBだったので、はじめからDBのボトルネックを疑った。

そのため、はじめに実際のワークロードに即したクエリを発行しDBのパフォーマンスを測った。しかしDBに関しては処理速度が早く、レイテンシに対するボトルネックではないとわかった。最終的にプロファイリングツールを入れ調査したところ、別のAPIを叩いている部分だと判明し、はじめから計測していれば無駄な調査をすることがなかった。

この時、Rob Pike氏の「推測するな計測せよ」という言葉を思い出すのと同時に、プロファイルを簡単に図れればよかったのにという思いに駆られた。 プロファイリングツールはいくつかあり、使う頻度も高くないのでたまに使う時に調べるのが面倒なのだ。

## プロファイルを簡単にかけれるようにする
Goであれば、pprof用のrouterを設定によって追加するとかをやればいつでも図りたい時に図れる。

[authorization-proxy](https://github.com/yahoojapan/authorization-proxy/blob/master/doc/debug.md#profiling)

上記プロダクトはk8sのconfigmapの設定でプロファイルのサーバが立ち上がるようになっていた。よい。