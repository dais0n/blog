+++
date = "2019-04-07T00:45:02+09:00"
tags = ["k8s"]
draft = false
author = "dais0n"
type = "posts/engineering"
title = "CKAD合格までの勉強方法"
description = "CKADとは何というところから勉強方法のまとめ"
+++

## はじめに
CKADを受けてみました。なんとか受かることができたので
CKADとは何かというところから勉強方法までまとめてみました

## CKADについて

### CKADとは
- Certified Kubernetes Application Developerの略。CNCFが作成したKubernetesを使用してアプリケーションを動かす開発者向けの認定試験です(クラスタ管理者向けはCertified Kubernetes Administrator(CKA)です)
- Kubernetesでのクラウドネイティブなアプリケーションのデザイン、ビルド、設定、公開ができることを証明する試験と[試験概要](https://www.cncf.io/certification/ckad/)に記載してあります
- Kubernetesクラスタとターミナルが与えられ、podやvolumeなどのKubernetesリソースをコマンドを打って作っていったり、動かないpodを設定を編集して直したりといった実務的な試験です

### 試験概要
- 試験時間は120分、問題は20問で、合格ラインは66%となってます
- 参照できるドキュメントは https://kubernetes.io/docs と https://github.com/kubernetes/ のみです
- 申し込みや注意事項が書いてあるHandbook、試験官とのチャットは英語ですが、試験の問題文は言語選択が可能です

### 申し込み方法
- [linux foundationのページ](https://www.cncf.io/certification/ckad/)から申し込めます
- 試験費用は$300です。試験に落ちても一度のみ再度受けることができます
- 基本情報入力の後に日程決めや、使用している環境が試験にふさわしいかのチェックなどがあります
- 試験での違反行為や試験前に試験官がチェックすることなどが申し込み時にダウンロードできるHandbookに書いてあるので読みます

## 試験本番
- 試験15分前から試験を受けることができます
- 試験開始ボタンを押すと試験官とのチャットが始まります。パスポート見せたり、デスクや部屋をwebcumで写したりします。そのためデスクや部屋は綺麗にしておいたほうが良いです
- 他の方のエントリにもありますが、翻訳のchromeアドオンなどは使用しても大丈夫だそうです。一応試験官に許可を取って使ったほうがよさそうです
- 最後にHandbookにも書いてある注意事項を言い渡され試験が始まります
- 試験途中に怪しい行為をすると試験を中断して試験官のチェックが入ります。自分は姿勢が悪く、下に何か隠してるのかを疑われたのか、webcumで机の下を写せなど言われました。。結構ちゃんと見られているので意識したほうが良いです

## 結果
1回目の試験では44%で落ちて、その後1週間勉強して91%で合格しました
1回目は圧倒的な時間不足で、リソースをすばやく作れなかったことが原因でした

以下が合格証明書です。560番目ですかね?
{{< figure src="../images/ckad.png" width="400" height="300" >}}

## CKADで問われる内容と合格までにやったこと

### CKADの問題例
- 120分で20問、例えば以下のような問題がでます。実際にはもう少し細かい指示がされてます。
  - configmapを作って、AとBのコンテナの/etc/hogeにマウントしたコンテナを含んだpodを作成しなさい
  - deploymentのimageのhogeに変更しローリングアップデート後、ロールバックしなさい
  - 再起動を繰り返しているpodがあります。そのpodを探し、正常に動くように直しなさい

### 合格に必要なこと
- Kubernetesリソースの理解。
  - 普段からKubernetesでアプリケーションを動かしているなら追加の知識は必要ないかと思います
- 簡単なpod/deployment/job/cronjob/confimap/secretを何もみずに作成できること
  - 試験は問題文の理解からはじまり、リソースの作成、リソースが作成できたかの確認を含め1問あたり6分しかかけられないため、とにかく時間が足りないです。そのため練習次第で早くできるkubenetesリソースの作成を早くすることが重要です。[こちらの表](https://qiita.com/oke-py/items/e8bf3863c8f48d750427#kubectl-run%E3%81%AB%E3%82%88%E3%82%8B%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E4%BD%9C%E6%88%90)が覚えやすいです
- コマンドのヘルプやkubernetes.ioをすばやく検索して目的の情報に辿り着く能力
- わからない問題や配点が低い問題は勇気を持って捨てることも必要
  - 実際に91%で合格した際も手を付けなかった問題がありました

### 合格までにやったこと
- CKADを既に受けた方々のエントリを読む
  - [CKADをさっさと合格するためのTips](https://qiita.com/kentakozuka/items/c1a30f1545752264dfe6)
  - [CKA/CKADに合格したので比較してみた + Tips](https://qiita.com/oke-py/items/e8bf3863c8f48d750427)
- 基礎的な部分の復習のため、以下の本を読む
  - [Kubernetes完全ガイド (impress top gear)](https://www.amazon.co.jp/Kubernetes%E5%AE%8C%E5%85%A8%E3%82%AC%E3%82%A4%E3%83%89-impress-top-gear-%E9%9D%92%E5%B1%B1/dp/4295004804/ref=sr_1_1?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&keywords=kubernetes&qid=1554566717&s=gateway&sr=8-1)
  - [Kubernetes実践入門 プロダクションレディなコンテナ&アプリケーションの作り方 (Software Design plusシリーズ)](https://www.amazon.co.jp/Kubernetes実践入門-プロダクションレディなコンテナ-アプリケーションの作り方-Software-plusシリーズ/dp/4297104385/ref=sr_1_2?__mk_ja_JP=カタカナ&keywords=kubernetes&qid=1554566747&s=gateway&sr=8-2)
- [CKAD-exercises](https://github.com/dgkanatsios/CKAD-exercises)をなるべく試験と同じ状況で3周行う
  - コマンドのヘルプかkubernetes.ioで調べながら行う
  - 素のbashで練習(いつものシェルだと補完やsyntaxが効きすぎて試験環境に近くなかった)

## まとめ
- CKADはKubernetesを使用してアプリケーションを動かす開発者向けの認定試験
- 試験官のチェックはしっかりしてるので疑われないように注意したほうがよさそう
- CKAD-exercisesを試験環境にできるだけ近い環境で何週もするのがオススメ

