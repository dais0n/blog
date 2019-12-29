+++
date = "2019-01-27T16:00:02+09:00"
tags = ["efficiency","tool"]
draft = false
author = "dais0n"
type = "posts/engineering"
title = "常に同じパフォーマンスを発揮するdotfilesの設定"
description = "どの環境でも同じ設定を使う方法をまとめてみた"
+++

## 背景
自分はサーバにdotfilesや必要なコマンドをインストールするスクリプトを用意していて、サーバに入るとそのスクリプトを走らせることで
基本どのサーバでも同じ環境で作業できるようにしてます。

今回はインストールスクリプトや

* どういったコマンドや設定を入れているのか、またその設定を入れる理由
* OSの違いなどをどう解決しているのか

を紹介できればと思います。ローカルとサーバでパフォーマンスが変わってしまうのはもったいない！

## ゴール
早速ですが、自分が初めてサーバに入ると走らせているスクリプトのgifです。
{{< figure src="../../../images/dotfiles_in_anywhere_1.gif" >}}
上記の動画のように

* dotfilesのクローン
* 必要なコマンドやプラグインマネージャなどインストール
* vimのプラグインを入れる
* dotfilesにシンボリックリンクを貼る
* zshを再起動
といったことをしてます。ここまでできるようになるのが本記事のゴールです。

サーバに入ったら必ず走らせるスクリプトなので、プラグインやコマンドはできるだけ最低限にするようにdotfilesを作るようにしてます。インストール方法は後ほど書きます

## dotfilesの作成
どの環境からでも同じ設定ファイル類をダウンロードする必要があるので、githubにvimrc、zshrcなどをまとめたdotfilesというリポジトリを作ります。ついでに自分がどの環境でも入れているコマンドも紹介します。

自分のdotfilesは[こちら](https://github.com/dais0n/dotfiles)です。

また、各設定の解説をすると長くなるため各設定で自分が意識していることを中心に記載します。

### 必要なコマンド
自分がどの環境でも入れているコマンド。

* [peco](https://github.com/peco/peco): フィルタリングツール。ディレクトリ移動、コマンド履歴。真面目にこれないと仕事ができない
* [ghq](https://github.com/motemen/ghq): gitリポジトリの統一的な管理。色々サーバ入っているとどこにcloneしたのかわからなくなるので必須。またpecoと組み合わせるとリポジトリをすぐ見つけることができる。
* [ag](https://github.com/ggreer/the_silver_searcher): 高速grepツール。ソースコードを検索する際に使う

### zshrc

続いてzshrcです。自分のzshrcは200行くらいしかなく短いのですが、意識していることは

#### 履歴を利用する設定を入れる

一度調べて打ったコマンドはもう一度打ちたくない

  * cd履歴をpecoで絞り込む
  * コマンド履歴をpecoで絞り込む
  * 過去の履歴からコマンドの補完が行われる(zsh-autosuggestions)

#### プロンプトに必要な情報を載せる

本番環境でうっかりコマンド実行、実行しちゃいけないディレクトリでうっかり(ryがないようにする

  * git関係(今commitできるものがあるか・pullできるものがあるか)
  * hostname
  * pwd

### 地味に便利なsyntaxハイライト(zsh-syntax-highlighting)
プログラムがあるかの確認などにwhichとかしなくて良い。打っている途中でコマンドが間違っているか視覚的に気づける

### vimrc
続いてvimrcです。vimrcも削りに削って200行くらいですが、意識していることは

* vimscriptのみで動くプラグインを入れる

なんかpythonとかluaとか必要とするプラグインは使わないです。プラグインマネージャはvim-plugを使ってます。

おすすめプラグインは[vimawesome](https://vimawesome.com/)で探すと良いと思います。利用者数順やstar数順でプラグインが紹介されていて、ジャンル別のランキングも見れます。

* [ctrlp.vim](https://github.com/kien/ctrlp.vim): C-pで最近開いたファイル開くやつ
* [nerd tree](https://github.com/scrooloose/nerdtree): finder
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter): gitで編集しているファイルを編集すると+-っていう差分を示すマークが出るようになるやつ
* [vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace): ワンコマンドでいらない空白を排除するやつ

### gitconfig & gitignore
gitconfigは地味に便利なので、dotfilesで管理することをおすすめします。
aliasの設定が便利です。

```
co = checkout
s = status --short --branch
b = branch -a
cm = commit -v
cma = commit -a -v
d = diff -C --stat -p
dc = diff --cached
br = branch
s = status --short --branch
rv = remote --verbose
l = log --graph --date=short --decorate=short --pretty=format:'%C(red)%h　%C(reset)-%C(yellow)%d %Creset%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
ll = log --graph --all --abbrev-commit --date=relative --pretty=format:'%C(red)%h　%C(reset)-%C(yellow)%d %Creset%s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
```

gitignoreはグローバルにignoreしたいファイルを書きます。キャッシュ系のファイルと、.key、.pemなども書いておくとうっかりがないです。

## Makefileの作成
後ほどインストールスクリプトを書くんですが、その中ではほぼmakeのinstallタスクを実行するだけなので、先にMakefileを書きます。ちょっと抜粋すると

```
install: vim-init zsh-init
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	vim +PlugInstall +qall
	zsh
vim-init: ctags-init
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

* 必要なバイナリ(peco、vimのプラグインマネージャなど)を持ってくる
* dotfilesをシンボリックリンクを用いてホームディレクトリに設置する
* vimのプラグインインストール
* zshの再起動で全設定完了

といったことをしてます。

### なぜMakefileか
プログラムのビルドの自動化で使うMakefileをdotfilesのインストールにも用いるのには以下の3つの理由があるからです。

* どこでも入っているから。Makefileとシェルスクリプトを使うのはそのため
* 自動でインストールされるものと必要な環境にインストールするものを分けたい
  * pecoは自動で入れてほしいけど、ghqは必要な環境だけにインストールしたいみたいなことができる
* make タスク名で実行できるので、長いインストールスクリプトを忘れても良い

### デプロイ(install)とイニシャライズ(init)は分ける
installはシンボリックリンクを貼ったりパスに置いたりしてプログラムを使えるようにすること、initはダウンロードなど必要なプログラムを外部から取得することを指します。

これは、[最強の dotfiles 駆動開発と GitHub で管理する運用方法](https://qiita.com/b4b4r07/items/b70178e021bef12cd4a2)の引用なのですが

> ドットファイルを一括でターゲットとすることで、新規ドットファイルが追加されてもこの Makefile を修正する必要がないので便利です（ファイルの追加に追従してリンクファイルの修正することを忘れたり、ファイルリストから漏れたりすることで、リンクされないようなバグやそれに関するコンフリクトはよくあります）

シンボリックリンクを貼るタスクと、諸々ツールインストールするタスクが一緒になっていた場合、新しくdotfilesを足してシンボリックリンク貼りたいだけにもかかわらず、ツールが再度インストールされてしまったりといったことがあり得る。そのためinstallとinitのMakeタスクは分けましょう。

### 環境ごとに違うバイナリをインストールする場合
macとlinuxなど環境ごとに異なるバイナリをインストールするためには、Makefileの中で判定させます。
例えばpecoのインストールタスクは以下のようになってます。

```
UNAME := $(shell uname)
peco-init:
ifeq ($(UNAME),Darwin)
	curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_darwin_amd64.zip
	unzip peco_darwin_amd64.zip && sudo mv peco_darwin_amd64/peco /usr/local/bin && rm -rf peco_darwin_amd64 peco_darwin_amd64.zip
endif
ifeq ($(UNAME),Linux)
	curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz
	tar -zxvf peco_linux_amd64.tar.gz && sudo mv peco_linux_amd64/peco /usr/local/bin && rm -rf peco_linux_amd64 peco_linux_amd64.tar.gz
endif
```

unameコマンドを最初に打っておき、その結果でifeqを用いてどちらかのバイナリを取得します。

## インストールスクリプトの作成
最後にインストールスクリプト作成します。インストールスクリプトでやることはシンプルで

* git clone
* make install

だけです。他はかっこよくアスキーアート出したりしてもよいかと思います。自分のインストールスクリプトは短いのでほぼ全文以下に記載します。

```
# check git
if ! type git > /dev/null 2>&1; then
  echo "this dotfiles is required gitd"
  echo "please retry when you install git"
  exit 1
fi

# echo logo

echo "$DOTFILES_LOGO"

# git clone
git clone ${REPO_URL}

# make
cd dotfiles && make
```

これをinstaller.shとしてgitにあげておき

```
bash -c "$(curl -L https://raw.githubusercontent.com/dais0n/dotfiles/master/rc/installer.sh)"
```

で実行すればinstaller.shが起動します。

## よく忘れるコマンドをどの環境でも打つ方法
おまけで、よく忘れるコマンドをスニペットとして登録しておき、スニペットをどの環境でも使う簡単な方法を紹介します。

1. .zsh/snippetを作る
1. snippetの内容を呼び出して表示するzshの関数を作る

上記の2ステップで実現できます。

### .zsh/snippetを作る
.zsh/snippetはただのコマンド羅列ファイルですｗ以下によく忘れるコマンドを記載してdotfilesとして管理します。コマンドの後ろに#をつけてコメントを書くと良いです。例えば以下用な感じです。

```
# git
git commit --amend
git branch -D # delete local branch
git push --delete origin branch_name # delete remote branch
git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}' # check parent branch
git log --oneline | peco | cut -d" " -f1 | xargs git show # git show
git submodule update -i # git submodule
# curl
curl -H "Content-Type: application/json" -X POST -d '{"username":"xyz","password":"xyz"}' http://localhost:3000/v1/login
# kubernetes
kubectl config set-context $(kubectl config current-context) --namespace=<YOUR_NAMESPACE> # change namespace
# investigation
netstat -ltapn | grep ESTABLISHED | more
netstat -ltan | grep ":80 " | awk '{print $5}' | awk -F : '{print $4}' | sort | uniq -c | sort -nr | head
lsof -i:80
nc localhost 8080 # netcat
```

### snippetの内容を呼び出して表示するzshの関数を作る
作成したsnippetファイルをpecoを使ってインクリメンタルサーチさせます。

```
function peco-snippets() {
    BUFFER=$(grep -v "^#" ~/.zsh/snippets | peco --query "$LBUFFER")
    zle reset-prompt
}
zle -N peco-snippets
bindkey '^S' peco-snippets
```

コメント行のみを覗いてpecoで絞り込みをかけてくれます。そうすると以下のようにどの環境でも忘れやすいコマンドを検索できるようになります。

{{< figure src="../../../images/dotfiles_in_anywhere_2.png" >}}

シンプルですが自分はこのsnippet管理方法が好きです。

## 参考
[最強の dotfiles 駆動開発と GitHub で管理する運用方法](https://qiita.com/b4b4r07/items/b70178e021bef12cd4a2)
