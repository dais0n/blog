+++
categories = ["command"]
date = "2018-02-18T13:56:02+09:00"
tags = ["peco"]
draft = false
author = "dais0n"
title = "毎回コマンド調べてない？それpeco使えば解決できるよ"
+++

## pecoってなに？
* [github](https://github.com/peco/peco): Go製！！
* Simplistic interactive filtering tool 

* 標準入力から受けた行データをインクリメンタルサーチして、選択した行を標準出力に返す(C-n, C-pで移動可能)
 
> インクリメンタルサーチ - Wikipedia （英語: incremental search）は、アプリケーションにおける検索方法のひとつ。 
検索したい単語をすべて入力した上で検索するのではなく、入力のたびごとに即座に候補を表示させる。逐語検索、逐次検索

## 使ってみる
[peco公式のデモ](https://github.com/peco/peco#demo)

* psコマンドの結果を標準入力としてpecoに渡す例

    ```
    ps -ax | peco
    ```
    {{< figure src="../images/peco_ps.gif" title="ps -ax | peco" >}}

## インストール方法
おすすめはバイナリそのままもってくるのがおすすめ(環境依存少ない)

現在v0.5.2が最新

* brew
    ```
    brew install peco
    ```

* go
    ```
    go get github.com/peco/peco/cmd/peco
    ```

* binary
    * macの場合
        ```
        ## バイナリダウンロード
        curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_darwin_amd64.zip
        ## 解凍後パス通ってるディレクトリにおいて、残ったディレクトリ削除
        unzip peco_darwin_amd64.zip && sudo mv peco_darwin_amd64/peco /usr/local/bin && rm -rf peco_darwin_amd64 peco_darwin_amd64.zip 
        ```
    * linuxの場合
        ```
        ## バイナリダウンロード
        curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.zip
        ## 解凍後パス通ってるディレクトリにおいて、残ったディレクトリ削除
        tar -zxvf peco_linux_amd64.tar.gz && sudo mv peco_linux_amd64/peco /usr/local/bin && rm -rf peco_linux_amd64 peco_linux_amd64.tar.gz
        ```

## pecoの利用シーン

> おにいちゃん！goのスクリプトをvimで開きたいんだけど名前忘れちゃって。。てへ

```
vi $(find . -name '*.go' | peco)
```

> おにいちゃん..なんでこんなディレクトリ深く切ってるの！？探しにくい！怒

```
# 現在以下のディレクトリを検索し、インクリメンタルサーチ後移動
cd "$(find . -type d | peco)"
```

> おにいちゃん! gitの履歴調べて、変更内容見たい！コミットメッセージ曖昧にしか覚えてない！！

```
# git logをインクリメンタルサーチ後、その結果をgit showする
git log --oneline | peco | cut -d" " -f1 | xargs git show
```

> おにいちゃん！前入ったサーバ忘れちゃった。。もうマヂ無理

```
# sshしたことのあるサーバをインクリメンタルサーチ
ssh $(grep -o '^\S\+' ~/.ssh/known_hosts | tr -d '[]' | tr ',' '\n' | sort | peco)
```

## pecoとshellのハーモニー

pecoはシェルのショートカットとして利用することで最も効果を発揮する

### コマンド履歴をpecoり、その結果を実行

#### zsh

.zshrcに以下のステップで設定を入れる

* 履歴の設定
    ```
    HISTFILE=~/.zsh_history #履歴ファイルの設定
    HISTSIZE=1000000 # メモリに保存される履歴の件数。(保存数だけ履歴を検索できる)
    SAVEHIST=1000000 # ファイルに何件保存するか
    setopt extended_history # 実行時間とかも保存する
    setopt share_history # 別のターミナルでも履歴を参照できるようにする
    setopt hist_ignore_all_dups # 過去に同じ履歴が存在する場合、古い履歴を削除し重複しない 
    setopt hist_ignore_space # コマンド先頭スペースの場合保存しない
    setopt hist_verify # ヒストリを呼び出してから実行する間に一旦編集できる状態になる
    setopt hist_reduce_blanks #余分なスペースを削除してヒストリに記録する
    setopt hist_save_no_dups # histryコマンドは残さない
    setopt hist_expire_dups_first # 古い履歴を削除する必要がある場合、まず重複しているものから削除
    setopt hist_expand # 補完時にヒストリを自動的に展開する
    setopt inc_append_history # 履歴をインクリメンタルに追加 
    ```

* histroyコマンドでpecoを利用した関数をショートカットに登録
    ```
    function peco-select-history {
        BUFFER=`history -n -r 1 | peco --query "$LBUFFER"`
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    zle -N peco-select-history
    bindkey '^r' peco-select-history
    ```
    pecoで絞り込んだ結果をzle(zsh line editor zshのコマンドライン編集機能)の関数として登録する

    peco --queryはpecoにquery以下の文字列を入れたままで実行できる機能

    そのため、コマンドを打っている途中でpecoしてもその文字が入力されたまま実行される

#### bash
.bashrcに以下のステップで設定を入れる

* 履歴の設定

    ```
    export HISTCONTROL=ignoreboth:erasedups # 重複履歴を無視
    HISTSIZE=5000 # historyに記憶するコマンド数
    HISTIGNORE="fg*:bg*:history*:h*" # historyなどの履歴を保存しない
    HISTTIMEFORMAT='%Y.%m.%d %T' # historyに時間を追加
    ```
* pecoを利用した関数をショートカットに登録
    ```
    peco_history() {
        declare l=$(HISTTIMEFORMAT=  history | LC_ALL=C sort -r |  awk '{for(i=2;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}'   |  peco --query "$READLINE_LINE")
        READLINE_LINE="$l"
        READLINE_POINT=${#l}
    }
    bind -x '"\C-x\C-r": peco_history'
    ```
    ※cent6系などは動くはず、、macのbashはデフォが3系と古いのでbrewで最新のbashをインストールするとmacもlinuxも同じように使える

    [Macのbashを4.x系に変更する](https://qiita.com/zaburo/items/1b990436ca45545959e9)

### cd履歴をpecoり移動

#### zsh
* cdrの設定(ディレクトリスタック)
    ```
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    ```
    設定してディレクトリ移動して、``` cdr -l ``` で履歴が保存されていればOK

* cdrコマンドとpecoを組み合わせる
    ```
    function peco-cdr() {
        local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-cdr
    bindkey '^Z' peco-cdr
    ```
    cdrした結果をawkで整形後pecoでサーチし、zleの関数に登録
    accept-lineで即時実行

#### bash
* pushdの設定(ディレクトリスタック)
    ```
    # cdで自動でスタックで入れる機能がないためaliasを張る
    alias cd=pushd
    ``` 
* dirsコマンドとpecoを組み合わせる
    ```
    function peco-pushd() {
      local pushd_number=$(dirs -v | peco | perl -anE 'say $F[0]')
      pushd +$pushd_number
    }

    bind -x '"\C-z": peco_pushd'
    ```
    bashのpushdは癖あるので扱いずらいかも。。

### よく使用するコマンドを~/.zsh/.snippetsに定義し、それを検索
* zsh

    ```
    function peco-snippets() {
        BUFFER=$(grep -v "^#" ~/.zsh/snippets | peco --query "$LBUFFER")
        zle reset-prompt
    }
    zle -N peco-snippets
    bindkey '^T' peco-snippets
    ```

### ghqでリポジトリ管理している人向け
* ghqで管理しているディレクトリをインクリメンタルサーチして移動　

    ```
    alias ghd='cd $(ghq list --full-path | peco)'
    ```

## どの環境でもすぐpecoる ~dotfilesのススメ~
pecoに慣れてしまうと以下の現象が発生

* どの環境でもpeco入れたい!
* zshの設定も共有したい!
* .snippetsとかどう共有するの?

これらの問題は以下の方法で解決できる

* gitで設定ファイル類を管理

* git cloneとpecoなどをインストールするコマンドを書いたシェルを作成(install.sh)し、gitに上げる
    ```
    # 以下コマンド例
    ## git clone
    git clone ${REPO_URL}
    ## シンボリックリンクを張る
    ln -sf ~/${REPO_URL}/.bashrc ~/.bashrc
    ln -sf ~/${REPO_URL}/.zshrc ~/.zshrc
    ln -sf ~/${REPO_URL}/.snippets ~/.snippets
    ## peco install
    curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz
    unzip peco_darwin_amd64.zip && sudo mv peco_darwin_amd64/peco /usr/local/bin && rm -rf peco_darwin_amd64 peco_darwin_amd64.zip 

    ```
    installだけ、シンボリックリンク張るだけといったターゲット分けができるので自分はMakefileで管理している

    参考: [優れた dotfiles を設計して、最速で環境構築する話](https://qiita.com/b4b4r07/items/24872cdcbec964ce2178)

* 新しいサーバではcurlでinstall.shを取得後実行する
    ```
    bash -c "$(curl -L https://github.com/dais0n/dotfiles/master/rc/installer.sh)"
    ```

## 参考
* [例えばpecoをビルドしない](https://qiita.com/lestrrat/items/de8565fe32864f76ac19)
* [コマンドライン編集機能 Zsh Line Editor を使いこなす](https://qiita.com/b4b4r07/items/8db0257d2e6f6b19ecb9)
* [bashで使うpeco .bashrcサンプル](https://gist.github.com/umeyuki/0267d8e995e32012cfe8)
* [最強の dotfiles 駆動開発と GitHub で管理する運用方法](https://qiita.com/b4b4r07/items/b70178e021bef12cd4a2)
* [peco/percolでCUIなスニペットツールを作ってみる](http://blog.glidenote.com/blog/2014/06/26/snippets-peco-percol/)
* [pecoでssh](http://d.hatena.ne.jp/tacahiroy/20140826/1409069304)
