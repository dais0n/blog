+++
date = "2020-02-11T00:45:02+09:00"
tags = ["k8s"]
draft = false
author = "dais0n"
type = "posts/engineering"
title = "CKAD取得してからCKA取得までにしたこと"
description = "CKADから追加で勉強したこと"
+++

## はじめに

CKADに合格してからKubernetesの仕組みにも興味を持ち、CKAも受けました。スコアとしては86%で合格しました(合格は74%以上)。

CKADと比べて何が違うのか、CKADを合格してからCKAに合格するまでにやったことを書いてみます。

CKAD合格までの勉強方法は[こちら](https://blog.dais0n.net/posts/engineering/ckad/)です。

## CKAとCKADの違い

試験内容の違いなどは[CKAとCKADの比較](https://qiita.com/oke-py/items/e8bf3863c8f48d750427#ckackad%E3%81%AE%E6%AF%94%E8%BC%83)に記載されている表がとてもわかりやすいです。

試験範囲をざっと見た感じ、かぶっている範囲があまりないように感じますが、自分なりにCKAとCKADを表現すると

```
CKA = ( CKAD - アプリケーション本番稼働に必要な細かめの設定やデバッグ方法 ) 
      + Kubernetesクラスタ構築知識
```

だと思います。つまりCKADで必要な、リソースを手早く作成するといったことに加えて、Kubernetesを構成するそれぞれのコンポーネントがどう動いているのか理解し、Kubernetesクラスタの構築ができる必要があります。

しかし、CKADに比べアプリケーション本番稼働に必要な死活監視だったり、リソース周り、アプリケーションのデバッグなどの問題は少なめな印象でした。

また、CKAはCKADに比べて時間的に若干余裕がある印象です。CKADは時間との勝負感がありますが、CKAはじっくり考えても大丈夫かと思います。

## 合格までに必要なこと

大きく3つです

1. Kubernetesを構成するコンポーネントの理解
2. それぞれのコンポーネントの実行オプションの理解
3. Kubernetesクラスタを1から構築できる知識。またクラスタ構成ツールの知識

3をやる際に1,2の知識が必要なので、最終的に3が1,2を意識しながらできれば良いという感じです。
1つずつ解説していきます

### 1. Kubernetesを構成するコンポーネントの理解

まずはKubernetesを構成するコンポーネントが、どのノードで何をしているかを理解することです。

具体的には

> kubectlによってPod Specがapplyされると、masterノードにあるkube-apiserverにアクセスがいき、etcdにPod Specを保存。

> masterノードにあるkube-schedulerがPodを実行するノードを選択し、kube-apiserverにアクセスしPod Specに実行するノードを書き込む。

> workerノードにあるkubeletは自身のノードで実行すべきPodをkube-apiserverにアクセスし監視していて、まだ自身のノードで実行すべきPodが自身のノードになければPodを作成する

といった流れを理解することです。

### 2. それぞれのコンポーネントの実行オプションの理解

次にそれぞれのコンポーネントを実行する際のオプションの意味を理解します。コンポーネントはそれぞれオプションを指定して実行します。

例えばkube-apiserverだったら[公式](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)に記載の通り、自身のClient証明書, etcdサーバ, authorizationモジュールなどの指定ができます。指定が変わる部分などを意識して理解すると良さそうです。

### 3. Kubernetesクラスタを1から構築できる知識。またクラスタ構成ツールの知識

kubernetes-hardwayなどを行い、コマンドを理解しながら、設定を理解しながら構築します。
その前でも後でもよいですが、kubeadmなどのクラスタ構築が楽にできるツールでもクラスタ構築をしてみると良さそうです。

## 合格までにやったこと

やったことは[Certified Kubernetes Administrator (CKA) with Practice Tests](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/)をやりきるだけでした。

このUdemyの講座をやりきるだけで、上記に述べた合格までに必要なこと3つは全て学べます。

このUdemyの講座は、13時間ほどの講義と、それぞれの講義の終わりにウェブコンソールでのテストがあります。そのため、講義よりもテストの方が時間がかかります。

テストは[Kode Kloud](https://kodekloud.com/)を用いて行われ、テストを開始するとクラスタが構築され、設問が現れます。
ウェブコンソールでクラスタに対して操作を行い、適切なリソースが作成されているかが自動で判定されます。このテストは問題数も多く、かなり鍛えられます。

講義は英語のみですが(2020/02現在)、講師の方の英語はゆっくりでとても聞き取りやすいです。また、イラストが多く非常にわかりやすいです。

不安であれば、[Kubernetes完全ガイド (impress top gear) ](https://www.amazon.co.jp/Kubernetes%E5%AE%8C%E5%85%A8%E3%82%AC%E3%82%A4%E3%83%89-impress-top-gear-%E9%9D%92%E5%B1%B1/dp/4295004804)などを読み切った上で再度聞くとコンテキストが補完されるため、英語も聞き取りやすくなると思います。

最初はKubernetesの基本的なリソースの知識から始まるので、CKAD合格されている方などは最初の方は飛ばしても良さそうです。

このUdemyの講座は値段は定価は24000円らしいですが、大体いつも安くて1380円とかで買えます。正直安すぎます。

他の方のブログでもまとめられていますが、このUdemyの講座は講義からテストまで構成が完璧です。

## まとめ

- CKAはCKADほどアプリケーション周りの知識は深く聞かれないが、Kubernetesを構成するコンポーネントの理解や、Kubernetesクラスタの構築の知識が必要

- [Certified Kubernetes Administrator (CKA) with Practice Tests](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/)がCKA対策では最高だった

