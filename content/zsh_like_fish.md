+++
categories = ["peco", "zsh"]
date = "2018-02-18T13:56:02+09:00"
tags = ["peco", "zsh"]
draft = true
author = "dais0n"
title = "zshでfishライクなシェルをzplugで楽に作る"
+++

## きっかけ
* 普段fish使ってるエンジニアに「zshでもfishっぽく使う設定をできるだけ設定ファイル少なく書きたい(長くすると管理がだるい)」と相談されたので一緒に設定ファイルを作ったら良い感じのができた

* 以前書いた[毎回コマンド調べてない？それpeco使えば解決できるよ](https://dais0n.github.io/blog/peco/)ではプラグイン使用せず設定書いたので、もう少し簡単に導入できる方法を探してた

## ゴール
1. zshでfishライクなシェルを作る
1. 履歴検索などはpecoなどを使いインタラクティブにフィルタリングし、コマンド履歴をフル活用する
1. 設定はできるだけ少なく

## 今回使用するプラグインなどの紹介
### [zplug](https://github.com/zplug/zplug)
今回は設定を少なくし、プラグインの導入を楽にしたいのでzshのプラグインマネージャであるzplugを入れてプラグインを管理します
zshのプラグインマネージャには色々あります(antigen、oh-my-zsh)が、zplugには以下の特徴があります。

* 軽い
* 依存関係を保ったインストールやブランチロック・リビジョンロックができる
* プラグインマネージャの範疇を超えることはしない

プラグインマネージャには、上記の機能があれば十分なのでzplugを採用しました。シンプルで最高です。

~~oh-my-zshなどの俺の設定を使え系のプラグインマネージャはちょっと~~

### [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
zshをfishっぽくするエッセンスの1つ目で、fishのように途中まで文字を入力すると過去の入力履歴から補完が出てくるやつです。


候補が出てきたら、C-fで補完を行の最後まで確定、Option-fで単語毎に確定できます。

### [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
zshをfizhっぽくするエッセンスの2つ目でfishのように、コマンドのシンタックスハイライトをしてくれます。


これなら打っている途中でコマンドが間違っているかわかるし、地味にコマンドの存在確認にも使えます

### [peco](https://github.com/peco/peco)
標準入力から受けた行データをインクリメンタルサーチして、選択した行を標準出力に返すコマンドです
peco コマンドでググれば沢山でてきます。詳しくは[こちら](https://dais0n.github.io/blog/peco/)でも解説しているので、是非見て下さい。

### [anyframe](https://github.com/mollifier/anyframe)
pecoとzshの相性は最強なのですが、若干シェルの関数を書く必要があります。
便利な関数は決まっているので、特に便利な以下の関数をまとめてくれているプラグインです

* コマンド履歴をpecoで選択して実行する関数
* ディレクトリ履歴をpecoで選択して実行する関数
* プロセスをpecoで選択後killする関数
* tmux sessionをpecoで選択する関数
* git checkoutをpecoで選択して実行する関数
* ghqコマンドで管理しているリポジトリに移動する

プラグインを入れて、どの関数をどのショートカットで使うかを設定するだけです。
ちなみにpercol、fzfでも大丈夫で、インストールしてあるフィルタリングツールを勝手に選択して使ってくれます。

## 導入方法
上記で紹介したものをインストールしていきます
* zplug
```

```

## どの環境でも同じ設定を使う

## 参考
* [おい、Antigen もいいけど zplug 使えよ](https://qiita.com/b4b4r07/items/cd326cd31e01955b788b) : zplug作者の記事で、zplugを作った背景から書かれていて感動する記事
* [zshでpecoと連携するためのanyframeというプラグインを作った](https://qiita.com/mollifier/items/81b18c012d7841ab33c3) : anyframe作者の記事

