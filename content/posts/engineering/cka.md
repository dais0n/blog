+++
date = "2020-02-11T00:45:02+09:00"
tags = ["k8s"]
draft = false
author = "dais0n"
type = "posts/engineering"
title = "CKAに合格するまでに必要な知識と勉強方法"
description = ""
+++

## はじめに

CKADに合格してからKubernetesの仕組みにも興味を持ち、CKA(Certified Kubernetes Administrator)も受けました。スコアとしては86%で合格しました(合格は74%以上)。CKAに合格するまでにやったことを書いてみます。

CKAD合格までの勉強方法は[こちら](https://blog.dais0n.net/posts/engineering/ckad/)にまとめてます。

## 合格までにやったこと

### 合格に必要なこと

合格に必要な知識としては[公式ページ](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)のDomains & Competenciesに詳しく記載してありますが、まとめると

- Kubernetesの基本リソースの理解

- Kubernetesクラスタ管理者向けのリソースの理解

- Kubernetesクラスタを構成するコンポーネントの理解及びクラスタの構築

が必要です。

### 合格までにやったこと

やったことは[Certified Kubernetes Administrator (CKA) with Practice Tests](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/)をやりきるだけでした。

このUdemyの講座をやりきるだけで、上記に述べた合格までに必要な知識は全て学べます。例えばクラスタの構築に関してはkubernetes-hard-way及びkubeadmでクラスタ構築を行い、解説もついています。

このUdemyの講座は、13時間ほどの講義と、それぞれの講義の終わりにウェブコンソールでのテストがあります。そのため、講義よりもテストの方が時間がかかります。

テストは[Kode Kloud](https://kodekloud.com/)を用いて行われ、テストを開始するとクラスタが構築され、設問が現れます。
ウェブコンソールでクラスタに対して操作を行い、適切なリソースが作成されているかが自動で判定されます。このテストは問題数も多く、かなり鍛えられます。

講義は英語のみですが(2020/02現在)、講師の方の英語はゆっくりでとても聞き取りやすいです。また、イラストが多く非常にわかりやすいです。

不安であれば、[Kubernetes完全ガイド (impress top gear) ](https://www.amazon.co.jp/Kubernetes%E5%AE%8C%E5%85%A8%E3%82%AC%E3%82%A4%E3%83%89-impress-top-gear-%E9%9D%92%E5%B1%B1/dp/4295004804)などを読み切った上で再度聞くとコンテキストが補完されるため、英語も聞き取りやすくなると思います。

最初はKubernetesの基本的なリソースの講義から始まるので、CKAD合格されている方などは最初の方は飛ばしても良さそうです。

このUdemyの講座は定価24000円らしいですが、大体いつも安くて1380円とかで買えます。正直安すぎます。

他の方のブログでもまとめられていますが、このUdemyの講座は講義からテストまで構成が完璧です。

## まとめ

- [Certified Kubernetes Administrator (CKA) with Practice Tests](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/)がCKA対策では最高だった

