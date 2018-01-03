+++
author = "dais0n"
categories = ["isucon"]
date = "2017-09-23T21:38:02+09:00"
description = "isuconの勉強"
draft = false
tags = ["isucon"]
title = "isuconの勉強"
+++

# ISUCON勉強の記録

### 環境構築
1. [ISUCON用のvagrantファイル](https://github.com/matsuu/vagrant-isucon)をclone

    ```
    git clone https://github.com/matsuu/vagrant-isucon
    ```

2. isucon6-qualifier-standaloneのディレクトリに移動し、Vagrantfileがあるところでvagrant up
    * 特にvagrantfileを書き換える必要はない
    * エラーが出た場合はリポジトリのREADMEに書いてある方法で解決できる
    * 結構時間かかる
3. ansibleによるデプロイが終わったら、vagrant sshする。最初にisuconユーザにパスワードをつけておいたほうがよいかも

    ```
    sudo passwd isucon
    ```

4. ifconfigでipアドレスを調べ、ブラウザでアクセスするとアプリがたちあがっている
5. 最初はperlでアプリが立ち上がっているので以下の方法で切り替える
    * ３つのマイクロサービスが立ち上がっているのでそれぞれ止める

    ```
    sudo systemctl stop isupam.service
    sudo systemctl stop isutar.perl.service
    sudo systemctl stop isuda.perl.service
    ```

    * nginxのconfをPHP用に書き換え、restart

    ```
    # バックアップ取る
    cp nginx.conf{,.`date "+%Y%m%d_%H%M%S"`}
    # もともとあるPHPの設定ファイルに置き換える
    cp nginx.php.conf nginx.conf
    # nginx再起動
    systemctl restart nginx.service
    ```

    * phpのサービスを起動する

    ```
    sudo systemctl start isuda.php.service
    sudo systemctl start isutar.php.service
    sudo systemctl start isupam.service
    ```

    * ウェブ上で動いているのか確認
6. ベンチマーク動かす
    ```
    cd isucon6q/
    ./isucon6q-bench -target http://127.0.0.1
    ```

### [ISUCON夏期講習2017](http://isucon.net/archives/50648750.html)やってみる
1. システムの把握
    * 以下のコマンドを実行し、動いているプロセスを確認。同時にプロセスごとに使用されているリソース量を知れるとなお良い

    ```
    top -c
    ps auxf
    ```
    * どのdeamonや、ミドルウェアで構成されているのかを知る
    * [原因調査用コマンド](http://blog.father.gedow.net/2012/10/23/linux-command-for-trouble/)
    * [Linuxサーバにログインしたらいつもやっているオペレーション](http://blog.yuuk.io/entry/linux-server-operations)
2. わかったこと
    * リバースプロキシ(nginx)してアプリケーションサーバ(php-fpm)へ, php-fpmはそれぞれのアプリケーションで5プロセスずつ起動している
3. バックアップ
    * webappの部分はgitで管理する
    * configファイルは必ずcpしてから使用するようにする

    ```
    # 自動で時間を含めたファイル名でバックアップ
    cp nginx.conf{,.`date "+%Y%m%d_%H%M%S"`}
    ```
4. journalctlでログを見る
5. モニタリングツールインストール
    * [netdata](https://github.com/firehol/netdata/wiki/Installation)
    * ``` bash <(curl -Ss https://my-netdata.io/kickstart.sh) ```
    * ベンチマークを回した際のモニタリングをする
6. プロファイリングツールインストール
    * [alp](https://github.com/tkuchiki/alp)
    * インストール方法
    ```
    sudo apt-get install unzip
    wget https://github.com/tkuchiki/alp/releases/download/v0.3.1/alp_linux_amd64.zip
    ./alp_linux_amd64.zip
    sudo install alp /usr/local/bin
    ```
    * nginxのログをalp用にフォーマットさせる

7. パフォーマンスのボトルネックの考察
8. 静的ファイルのproxy配信
9. SQLのスロークエリの探し方
    * confにスローログを吐く設定を追記
    ```
    # /etc/mysql/my.conf
    low_query_log = 1
    slow_query_log_file = /var/log/mysql/slow.log
    long_query_time = 0
    ```
    * ログに対し、以下のコマンドを実行
    ```
    mysqldumpslow /var/log/mysql/slow.log
    ```
    * ログを解析するためにpercona-toolkitをいれる
    ```
    # ubuntuのversionを調べる
    lsb_release -a
    cat /etc/os-release
    # versionに応じたdebパッケージを取得する
    wget https://www.percona.com/downloads/percona-toolkit/3.0.4/binary/debian/xenial/x86_64/percona-toolkit_3.0.4-1.xenial_amd64.deb
    # 依存関係インストール
    sudo apt-get install libio-socket-ssl-perl libnet-ssleay-perl libterm-readkey-perl
    # percona-toolkit インストール
    sudo dpkg -i percona-toolkit_3.0.4-1.xenial_amd64.deb
    # インストールされたか確認
    dpkg -s percona-toolkit 
    ```
    * pt-query-digestで解析
    ```
    pt-query-digest --limit 10 /var/log/mysql/slow.log
    ```
    * EXPLAINしてどこにインデックスを貼ったらよいかなどを調べる
10. UNIXドメインソケット化
    
### 参考記事
* スコア推移など見ていると勉強になる。どこをボトルネックとしているのか
    * http://blog.nomadscafe.jp/2015/09/isucon5-elimination.html
    * http://sfujiwara.hatenablog.com/entry/2015/09/28/135717#fn-bee0e543
* mysqlの勉強
    * [innodbについて](http://shindolog.hatenablog.com/entry/2015/04/01/185703)
* [yuukiさんの記事](http://blog.yuuk.io/entry/web-operations-isucon)
    * こちらもISUCON夏期講習と同じく、調査の仕方、どこがボトルネックになりやすいのか、どうやって解決するのかがまとまっている。超おすすめ記事
* [ISUCON6の公式解説](http://isucon.net/archives/48697611.html)
