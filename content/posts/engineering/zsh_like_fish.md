+++
date = "2018-02-18T13:56:02+09:00"
tags = ["tool", "zsh"]
draft = false
author = "dais0n"
type = "posts/engineering"
title = "zshでfishライクなシェルをzplugで楽に作る"
description = "zplugの紹介とzshをfishっぽく使う設定"
+++


## きっかけ

* 普段fish使ってるエンジニアに「zshでもfishっぽく使う設定をできるだけ設定ファイル少なく書きたい(長くすると管理がだるい)」と相談されたので一緒に設定ファイルを作ったら良い感じのができた

* 以前書いた[毎回コマンド調べてない？それpeco使えば解決できるよ](https://dais0n.github.io/blog/peco/)ではプラグイン使用せず設定書いたので、もう少し簡単に導入できる方法を探してた

## ゴール
1. zshでfishライクなシェルを作る
1. 履歴検索などはpecoなどを使いインタラクティブにフィルタリングし、コマンド履歴をフル活用する
1. 設定はできるだけ少なく

最終的にこんな感じになります
{{< figure src="../images/zsh_like_fish.gif">}}

上記で

* コマンド予測補完
* コマンドシンタックスハイライト
* コマンド履歴インクリメンタルサーチ
* ディレクトリ履歴インクリメンタルサーチ

をやってます。

## 今回使用するプラグインなどの紹介
### [zplug](https://github.com/zplug/zplug)
今回は設定を少なくし、プラグインの導入を楽にしたいのでzshのプラグインマネージャであるzplugを入れてプラグインを管理します

こんな感じで定義したプラグインを入れてくれます！かっこいいですね
{{< figure src="../images/zplug.gif">}}

zshのプラグインマネージャには色々あります(antigen、oh-my-zsh)が、zplugには以下の特徴があります。

* 軽い
* 依存関係を保ったインストールやブランチロック・リビジョンロックができる
* プラグインマネージャの範疇を超えることはしない

プラグインマネージャには、上記の機能があれば十分なのでzplugを採用しました。シンプルで最高です。
~~oh-my-zshなどの俺の設定を使え系のプラグインマネージャはちょっと、、~~

使い方は、zshrcに以下のようにプラグインを定義した後、```zplug install```を打つと.zplug以下のディレクトリにプラグインをインストールしてくれます。

```
zplug 'felixr/docker-zsh-completion'
```

### [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
zshをfishっぽくするエッセンスの1つ目で、fishのように途中まで文字を入力すると過去の入力履歴から補完が出てくるやつです。

{{< figure src="../images/zsh_autosuggestion.gif">}}

候補が出てきたら、C-fで補完を行の最後まで確定、Option-fで単語毎に確定できます。

Optionはターミナルの設定でOptionをmetaキーに割り当てないと効かないので気をつけてください。

### [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
zshをfizhっぽくするエッセンスの2つ目でfishのように、コマンドのシンタックスハイライトをしてくれます。

{{< figure src="../images/zsh_syntax_highlighting.png">}}
(公式より引用)

これなら打っている途中でコマンドが間違っているかわかる
存在しないコマンドは赤くなるので、```which```打つ手間省けます

### [peco](https://github.com/peco/peco)
標準入力から受けた行データをインクリメンタルサーチして、選択した行を標準出力に返すコマンドです
peco コマンドでググれば沢山でてきます。詳しくは[こちら](https://dais0n.github.io/blog/peco/)でも解説しているので、是非見て下さい。

### [anyframe](https://github.com/mollifier/anyframe)
pecoとzshの相性は最強なのですが、若干シェルの関数を書く必要があります。
便利な関数は決まっているので、特に便利な以下の関数をまとめてくれているプラグインです

* **コマンド履歴をpecoで選択して実行する関数**
* **ディレクトリ履歴をpecoで選択して実行する関数**
* プロセスをpecoで選択後killする関数
* tmux sessionをpecoで選択する関数
* git checkoutをpecoで選択して実行する関数
* ghqコマンドで管理しているリポジトリに移動する

プラグインを入れて、どの関数をどのショートカットで使うかを設定するだけです。
ちなみにpercol、fzfでも大丈夫で、インストールしてあるフィルタリングツールを勝手に選択して使ってくれます。

今回は特に便利な上記の太字の機能だけ入れていきます

## 導入方法
上記で紹介したものをインストールしていきます。.zshrcに書いていきます

* zplugで上記で定義したプラグインを入れます
    * zsh-autosuggestions
    * zsh-syntax-highlighting
    * peco
    * anyframe

```
# zplugがなければzplugをインストール後zshを再起動
if [ ! -e "${HOME}/.zplug/init.zsh" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
fi
source ${HOME}/.zplug/init.zsh
# ここに入れたいプラグインを書いていく(gitのパスで)
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug "peco/peco", as:command, from:gh-r
zplug "mollifier/anyframe"
# プラグインがまだインストールされてないならインストールするか聞く
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# .zplug以下にパスを通す。プラグイン読み込み
zplug load --verbose
```
zsh-autosuggestionsとzsh-syntax-highlightingは入れるだけで機能します。

実は上記に書いてあるようにpecoもzplugで入れられるんです！これはすごく便利ですね。

* anyframeの設定を入れますが、履歴検索とディレクトリ検索をするにあたって、zshのコマンド履歴とディレクトリスタック(cdr)の設定を書きます

```
# --------------
# cdr関連の設定
# --------------
setopt AUTO_PUSHD # cdしたら自動でディレクトリスタックする
setopt pushd_ignore_dups # 同じディレクトリは追加しない
DIRSTACKSIZE=100 # スタックサイズ
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# --------------
# 履歴関連の設定
# --------------
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

# --------------
# anyframeの設定
# --------------
# anyframeで明示的にpecoを使用するように定義
zstyle ":anyframe:selector:" use peco
# C-zでcd履歴検索後移動
bindkey '^Z' anyframe-widget-cdr
# C-rでコマンド履歴検索後実行
bindkey '^R' anyframe-widget-put-history
```

これで設定は完了です！gistに今回の設定＋おすすめ設定を書いたzshrcをおいておきます
https://gist.github.com/dais0n/0e865dd54932b9ff4ab1de40200db717


## どの環境でも同じ設定を使う

これで結構便利なシェルになったと思います。しかしサーバ入る度にzshrcコピーしてといったことをするのは面倒ですよね

サーバ入る度に一発コマンドを打てば同じ環境が出来上がるようにします
これを行うためには

* zshrc, vimrcなどをdotfilesとしてgitで管理
* そのリポジトリにinstall.shを作る

    * git clone後、シンボリックリンクを貼り、zshを再起動するといったことをシェルスクリプトで書く
* サーバでinstall.shを実行(例えばこんな感じ)

    * ``` bash -c "$(curl -L https://raw.githubusercontent.com/dais0n/dotfiles/master/rc/installer.sh)" ```

これだけです。これでどこでも同じ設定のシェルが出来上がります！

## まとめ
今回はzshでfishライクなシェルの設定を作りました。
zplugを使うことで設定が少なく、楽にプラグインを導入することができました！
これなら管理しやすいかと思います。

## 参考
* [おい、Antigen もいいけど zplug 使えよ](https://qiita.com/b4b4r07/items/cd326cd31e01955b788b) : zplug作者の記事で、zplugを作った背景から書かれていて感動する記事
* [zshでpecoと連携するためのanyframeというプラグインを作った](https://qiita.com/mollifier/items/81b18c012d7841ab33c3) : anyframe作者の記事

