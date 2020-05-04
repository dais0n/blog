+++
date = "2019-01-04T11:00:02+09:00"
engineering = ["gcp"]
draft = false
author = "dais0n"
title = "プライベートなmatttermostサーバをGCP上に立てる"
+++

メモとかTODO管理用にMattermostサーバをGCP上に立ててみたので備忘録として残します

実際に立てたとこ: https://mattermost.dais0n.net/

{{< figure src="../../../images/mattermost_setup_1.png" width="400" height="300" >}}

上記はプライベート(管理者アカウントのみしか作れない設定にしてある)ので登録はみなさんは登録できません

## Mattermostとは

[公式サイト](https://www.mattermost.org/)引用

> Mattermost is an open source, self-hosted Slack-alternative

つまりSlackみたいなやつを自前でたてれるossです

公式に記載している特徴としては

- slack互換性があり、slackのみしかできないことはない
  - incoming, outgoing webhookがある
  - slackからメンバー、チャンネルのヒストリ、テーマのセッティングさえimportできる！
- ウェブに加えて、モバイル、デスクトップのアプリがある
  - ios, android(phone, tablet対応), windows, mac, linuxアプリに対応している
- 様々なアプリケーションと連携ができる
  - Jira, Jenkins, GitLab, などなど。MattermostAPIも使える
  
Mattermostを触ってみたい人はDockerイメージもあるので、それで立ててみるとよい。

## 構築手順

今回はDebian 8 (jessie)に立てるので、[Installing Mattermost on Debian Jessie](https://docs.mattermost.com/install/install-debian-88.html#configuring-nginx-with-ssl-and-http-2)を参考というかほぼコピペで行います。

大まかな作業手順は

- GCPでサーバ立てる
- MySQLを立ててユーザとデータベースを作成
- Mattermostサーバを立てる
- Nginxをたてて動作確認
- Mattermost自体の設定(新規ユーザを作らせない設定など)
- ドメイン登録
- Let's Encryptを使って証明書を作成
- Nginxの設定を変更しTLS化

作業時間は1時間くらいです。

### GCPでサーバ立てる
以下の記事などを参考にたてます
https://qiita.com/FukuharaYohei/items/0614354d6a4eda32d521

Debian jessieでf1-microでたてます。ssh鍵を設定し、.ssh/configの設定でも書いておきます

```
# .ssh/config
Host mattermost
    HostName x.x.x.x
    User test
    IdentityFile ~/.ssh/mattermost.key
    Port 22
    TCPKeepAlive yes
    IdentitiesOnly yes
```


### MySQLを立ててユーザとデータベースを作成

MySQLをインストール後、ユーザとデータベースを作成します

* インストール

```
sudo apt-get install mysql-server
```

* ユーザ作成

```
# ログイン
mysql -u root -p

# localhost上からしかアクセスしないのでlocalhostにします。アプリケーションと別サーバにする場合はそのipをlocalhostの部分に記載します。
mysql> create user 'mmuser'@'localhost' identified by 'mmuser-password';

```

* db作成

```
# db作成
mysql> create database mattermost;

# 作成したdbに権限を与える
mysql> grant all privileges on mattermost.* to 'mmuser'@'localhost';

# ログアウト
mysql> exit
```

### Mattermostサーバを立てる
続いてMattermostサーバをインストールして、dbの設定などを反映後にMattemostサーバをたてる。その後、systemdでデーモン化をします。

* mattermostをダウンロード
5.6.1(2019-01-03時点最新)をダウンロードします。

```
wget https://releases.mattermost.com/5.6.1/mattermost-5.6.1-linux-amd64.tar.gz

tar -xvzf mattermost*.gz

sudo mv mattermost /opt
    
sudo mkdir /opt/mattermost/data
```

* mattermostアプリケーション用のユーザ作成、権限追加

```
sudo useradd --system --user-group mattermost

sudo chown -R mattermost:mattermost /opt/mattermost

sudo chmod -R g+w /opt/mattermost
```

* mattermostの設定ファイルの書き換え
    /opt/mattermost/config/config.json にdbのドライバ、接続先の情報(dbname, password)を記載するようになっているので、こちらを修正します。

    120行目あたりにSqlSettingsがあるのでその部分を書き換える

    1. "DriverName"をmysqlに(デフォルト)
    1. "Detasource"を"mmuser:<mmuser-password>@tcp(localhost:3306)/mattermost?charset=utf8mb4,utf8&readTimeout=30s&writeTimeout=30s"


* mattermostサーバ起動

```
cd /opt/mattermost
# Server is listening on :8065が出て入れは成功
sudo -u mattermost ./bin/mattermost
```
一旦動作確認ができたらCTRL+Cでストップします

* systemdでデーモン化

* unitファイル作成

```
sudo touch /lib/systemd/system/mattermost.service
```

* unitファイルに以下の内容を記載

```
[Unit]
Description=Mattermost
After=network.target
After=mysql.service
Requires=mysql.service

[Service]
Type=notify
ExecStart=/opt/mattermost/bin/mattermost
TimeoutStartSec=3600
Restart=always
RestartSec=10
WorkingDirectory=/opt/mattermost
User=mattermost
Group=mattermost
LimitNOFILE=49152

[Install]
WantedBy=multi-user.target
```

* systemdでmattermostサーバを起動

```
# unitファイルを認識させる
sudo systemctl daemon-reload

# unitとして認識されているか確認
sudo systemctl start mattermost.service

# 起動
sudo systemctl start mattermost.service

# 確認(HTMLが返却されればOK)
curl http://localhost:8065

# 自動起動設定
sudo systemctl enable mattermost.service
```

### Nginxをたてて動作確認
nginxmattermostにする

* インストール

```
sudo apt-get install nginx
# nginxが起動しているか確認
curl http://localhost
```

* mattermostの設定を記載

```
# mattermost用の設定を書くファイルを作成
sudo touch /etc/nginx/sites-available/mattermost

# 作成したファイルに以下を記載して保存
upstream backend {
   server localhost:8065;
   keepalive 32;
}

proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=mattermost_cache:10m max_size=3g inactive=120m use_temp_path=off;

server {
   listen 80;

   location ~ /api/v[0-9]+/(users/)?websocket$ {
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
       client_max_body_size 50M;
       proxy_set_header Host $http_host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Frame-Options SAMEORIGIN;
       proxy_buffers 256 16k;
       proxy_buffer_size 16k;
       client_body_timeout 60;
       send_timeout 300;
       lingering_timeout 5;
       proxy_connect_timeout 90;
       proxy_send_timeout 300;
       proxy_read_timeout 90s;
       proxy_pass http://backend;
   }

   location / {
       client_max_body_size 50M;
       proxy_set_header Connection "";
       proxy_set_header Host $http_host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Frame-Options SAMEORIGIN;
       proxy_buffers 256 16k;
       proxy_buffer_size 16k;
       proxy_read_timeout 600s;
       proxy_cache mattermost_cache;
       proxy_cache_revalidate on;
       proxy_cache_min_uses 2;
       proxy_cache_use_stale timeout;
       proxy_cache_lock on;
       proxy_http_version 1.1;
       proxy_pass http://backend;
   }
}

# デフォルトの設定を削除 
sudo rm /etc/nginx/sites-enabled/default

# 反映させる
sudo ln -s /etc/nginx/sites-available/mattermost /etc/nginx/sites-enabled/mattermost

sudo systemctl restart nginx

# 動作確認。mattermostサーバの結果が返ってきていれば設定完了
curl http://localhost

# その後nginxを止めておく
sudo systemctl stop nginx
```

### DNS登録
今回はRoute53を使った。ドメインはmattermost.dais0n.netとした

### Let's Encryptを使って証明書を作成
TLS対応をするために、証明書を作成する

```
# git入れる
sudo apt-get install git

# download
git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt

# メールアドレスの確認と、ドメインを入力する
./letsencrypt-auto certonly --standalone

# /etc/letsencrypt/live以下に証明書ができていれば完了
ls /etc/letsencrypt/live
```

### Nginxの設定を変更しTLS化

* 先程のnginxの設定に以下の設定を付け足す

```
// http to https 設定
server {
   listen 80 default_server;
   server_name   mattermost.dais0n.net;
   return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl http2;
  server_name    mattermost.dais0n.net;

  ssl on;
  ssl_certificate /etc/letsencrypt/live/mattermost.dais0n.net/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/mattermost.dais0n.net/privkey.pem;
  ssl_session_timeout 1d;
  ssl_protocols TLSv1.2;
  ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:50m;
  # HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
  add_header Strict-Transport-Security max-age=15768000;
  # OCSP Stapling ---
  # fetch OCSP records from URL in ssl_certificate and cache them
  ssl_stapling on;
  ssl_stapling_verify on;
  
  // 以下はさっきと同じ
```

* nginxを再度立てる

```
sudo service nginx start
```

httpsでアクセスできていること、httpでアクセスした際にhttps担っていることを確認すればOK

## まとめ
mattermostサーバを立ててみた。ドキュメントが丁寧でとてもわかりやすかった。GKEとかでも今度たててみたい。

これで容量無制限の自分通知用Slackができるので、ぜひ作ってみてください！
