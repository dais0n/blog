+++
categories = ["k8s","linux"]
description = "k8sのpodからnfsマウントする"
date = "2018-07-08T13:56:02+09:00"
tags = ["k8s", "nfs"]
draft = false
author = "dais0n"
title = "k8sのpodからnfsマウントする"
+++


## 背景
k8sのvolumeマウントはよくGoogleのチュートリアルでGoogle Cloudのpersisitent diskなどで行うことはありますが、自分でnsfサーバを構築しNFSマウントすることをやったことがないのでやってみました。

## 環境
* nsfサーバ(centos7)

## nsfサーバを構築する
### nsfの説明
NFSの特長は、ネットワークファイルシステムという名前のとおり、ネットワークを介してサーバ上のストレージ領域をローカルストレージと同様にマウントして使える点です。このためNFSであることを意識する必要がなく、ローカルストレージと同様に読み書きすることが可能なため、幅広い用途で使える利点があります。[リンクベアメタルクラウドのページ](https://baremetal.jp/blog/2018/04/17/541/)より引用。引用ページわかりやすいのでそっち読んでください

### nsfサーバインストール

```
$ yum -y install nfs-utils
```

### 起動
```
# 起動
$ systemctl start nfs-server
# 自動起動設定
$ systemctl enable nfs-server
```

### 設定
nfsは/etc/exportsに設定を書きます。書式は
```
マウント対象のディレクトリ ホスト名orIP(オプション)
```
でオプションにはrw(読み書きOK)などのモードを入れます
オプションは[こちら](https://www.server-world.info/query?os=CentOS_7&p=nfs)のページを参考にしました

* マウント対象のディレクトリを作成

```
# マウント対象のディレクトリ作成
$ mkdir /share
# 適当なファイル作る
$ vi /share/dais0n.txt
```

* nsfの設定記述
今回の設定はローカルのmacと、プライベートアドレスのある範囲に対して
/shareに対する読み書き権限をつけてマウントできるようにしたいので以下のように記述

```
# /etc/exports

# 172.17.0.0〜172.17.255.255の範囲で許可
/share 172.17.0.0/255.255.0.0(rw,all_squash)
# ローカルのmac
/share 172.16.164.128(rw,all_squash)
```

* restart

```
$ systemctl restart nfs-server
```

### macからマウントしてみる
ちゃんと設定できてるかどうかまずmacからマウントしてみます
```
# マウントするディレクトリを作成
$ mkdir share
# マウント
$ sudo mount_nfs -P マウント先のサーバ名:/share ./share
# アンマウント
$ sudo umount share
```
permission deniedなど出る場合はipの指定などが間違っていないか確認してください

## persisitant volume(pv)を作る
nfsサーバの構築は終わったので、続いてk8sのpersistent volumeを作ります

### pvの説明
Persistent VolumesはPodで使うストレージを管理するための仕組みです。
k8sではPodがダウンしたり、他のマシンで再度立ち上げてもデータを残す必要がある場合があります。そのためネットワークボリュームを使うことを前提に設計されており、kubernetesのノードとは切り離して管理します。

NFSにとどまらずAWSElasticBlockStoreやGCEPersistentDiskなどPodとは独立した壽命を持つクラウドなど外部の永続化ストレージサポートします。

### pvの作成
* yamlを記載

```
# nfs-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfc-pv-test
  labels:
    name: nfc-pv-test
spec:
  capacity:
    storage: "100Mi" # ここはサーバの容量見て適切な値を設定(pvcのための定義)
  accessModes:
    # 複数のノードからR/Wでマウントできる
    - ReadWriteMany
  ## マウント先のNFS Serverの情報を記載
  nfs:
    path: /share
    server: nfsのサーバorIPを記載

```

* 作成

```
$ kubectl apply -f nfs-pv.yaml
```

* 確認

```
$ kubectl get pv
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                   STORAGECLASS   REASON    AGE
nfs-pv-test   100Mi      RWX            Retain           Available                                                    3s

# より詳細な情報を表示
$ kubectl describe pv nfs-pv-test
~省略~
Message:
Source:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    NFSサーバのホストorIP
    Path:      /share
    ReadOnly:  false
```

## persisitant volume claim(pvc)を作る
podとpvを紐付けるためにpersistent volume claim(pvc)を使ってpodからpvを要求します。

### pvcの説明
podは要求したcpuやメモリを満たしたnodeを選んでpodを立ち上げるが、pvcは要求したディスク容量などを満たしたpvを選んでpodにマウントする動的ボリューム割当ができる仕組みである。pod内で直接pvを指定することもできるが、そうするとpodの定義が特定のクラウドに固定されてしまうかつ、アプリ開発者はpvのストレージ固有の情報も知る必要がある。 

本来はpvcを使うことでpodの定義をクラウドから分離し、pvをKubernetesクラスタの管理者が作成し、pvcをアプリ開発者が作成するような管理が望ましいらしい。

### pvcの作成
* yamlを記載

```
# nfs-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc-test
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: "100Mi"
  selector:
    matchLabels:
      name: nfs-pv-test
```

* 作成

```
$ kubectl apply -f nfs-pvc.yaml
```

* 確認

```
# pvが紐付いていることがわかる
$ kubectl get pvc                  
NAME           STATUS    VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
nfs-pvc-test   Bound     nfs-pv-test   100Mi      RWX                           1m
```

## podとpersistant volume claimを紐付ける
最後にpodの定義の中にpvcを指定します.

### podの作成
* 作成

```
# nfs-mount.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nfs-mount-test
spec:
  containers:
  - name: nfs-mount-test
    image: nginx:latest
    volumeMounts:
    - name: nfs-pvc-test
      mountPath: "/share"
  volumes:
    - name: nfs-pvc-test
      persistentVolumeClaim:
        claimName: nfs-pvc-test
```

* 確認

```
# マウントされていることを確認！
$ kubectl exec -it nfs-mount-test /bin/bash
root@nfs-mount-test:~# ls /share
daison.txt
```
