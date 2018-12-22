+++
categories = ["k8s"]
date = "2018-12-22T12:00:02+09:00"
tags = ["k8s"]
draft = false
author = "dais0n"
title = "the illustrated Children's Guide to Kubernetes訳してみた"
+++

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_1.png" width="400" height="300" >}}
the other day my daughter sidled into my office and asked me

こないだ娘がオフィスにこっそり入ってきて訪ねてきました。

dearest father whose knowledge is incomparable

お父さんは何でも知っているんだね

what is kubernetes

kuberntesって何ですかと

right that's a little bit of a paraphrase but you get the idea and I responded

そうですね。少し言い換えることになるけど、思い浮かんでこう答えました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_2.png" width="400" height="300" >}}
kubernetes is an open source orchestration system for docker containers

kubernetesはdockerコンテナのオープンソースのオーケストレーションシステムで

it handles scheduling onto nodes in a compute cluster and actively managers workloads to ensure that their state matches the user's declared intentions using the concept of labels and pods

クラスタのnode上でスケジュールを行い、活発にユーザが宣言した状態と一致させます。これにはpodのラベルの概念を使用します。

it groups the containers which make up an application into logical units for easy management and discovery

そしてコンテナをまとめ、アプリケションを論理的なユニットにすることで、管理や監視が簡単になります。

and my daugher said to me huh

娘ははぁ？といいいました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_3.png" width="400" height="300" >}}
and so i give you the illustrated children's guid to kubernetes

そのため私はkuberetesの挿絵入りの入りの子供向けのガイドを作ります

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_4.png" width="400" height="300" >}}
once upon a time there was an app named Phippy and she was a single app

昔々、Phippyという名のアプリケーションがいました。彼女はシングルアプリでした。

and was written in PHP and has just one page she lived on a hosting provider

そしてPHPで書かれていて、ただ1ページのみのアプリケーションでした。彼女はホスティングプロバイダ上で動いていて

and she shared her environment with scary other apps that she didn't know and didn't care to associate with

彼女が知らなかったり、関連したくないと思う他のおっかないアプリケーションとともに環境をシェアしていました。

she wished she had her own environment just her and a web server she could call home

彼女は自分だけのため環境、また彼女が家といえるWebサーバがあればよいなと思っていました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_5.png" width="400" height="300" >}}
an app has an enviroment that it relies upon to run for PHP app that environment might include a web server a readable file system and the PHP engine itself

アプリケーションはPHPを動かすことに責務を負った環境をもちます。そしてその環境ではWebサーバやファイルシステムPHPのエンジンそれ自身を含むかもしれません

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_6.png" width="400" height="300" >}}
one day a kindly whale came along he suggested that little Phippy might be happier living in a container and so the app moved and the container was nice 

ある日、やさしいくじらが現れて、彼は小さいPhippyはコンテナの中で過ごすのがより幸せかもしれないと提案しました。そしてアプリケーションはコンテナに移行しました。コンテナは快適でした。

but it was a little bit like having a fancy living room floating in the middle of the ocean

しかし少し海の真ん中に浮かぶファンシーなリビングルームのようでした

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_7.png" width="400" height="300" >}}
a container provieds an isolated context in which an app together with its environment can run

コンテナはその環境で動くアプリケーションと共に隔離されたコンテキストを提供します

but those isolated containers often need to be managed and connected to the external world

しかしそれらの隔離されたコンテナはしばしば外部に接続され管理される必要があり

shared file systems networking scheduling load balancing and distribution are all challenges

共有ファイルシステムやネットワークスケジュール、ロードバランスやディストリビューションには全て課題があります

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_8.png" width="400" height="300" >}}
the whale shrugged his shoulders sorry kid he said and disappeard beneath the ocean's surface

くじらは肩をすくめ、ごめんねといって海面の下に消えました

but before Fibby could even begin to dissapear a captain appeard on the horizon piloting a gigantic ship

しかしFibbyも立ち去り始める前に水平線の彼方から大きな船にのったキャプテンが現れました

the ship was made of dozens of rafts all lashed together

その船はきつく結び付けられたたくさんのいかだから作られていました

but from the outside it looked live one giant boat 

しかし外観からはそれは一隻の大きなボートに見えました

hello there friend PHP app my name is captain kuby said the wise old captain

こんちにはPHPアプリケーション。私はキャプテンKube。賢く年老いたキャプテンは言いました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_9.png" width="400" height="300" >}}
kubernetes is the greek word for a ship's captain

kubernetesは船のキャプテンという意味のギリシャ語です

we get the word cybernetic and gubernatorial from it

私達はkubernetesというワードからサイバネティックと舵を取るという意味を受け取っています

it led by Google the Kubernetes project focuses on building a robust platform for running thousands of containers in production

kubernetesプロジェクトはGoogleによって指揮が取られていて、たくさんのコンテナをプロダクションで動かしていくための堅牢なプラットフォームの構築に焦点をあてています

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_10.png" width="400" height="300" >}}
I am fibbies said the little app nice to make your acquaitance said the captain as he slapped a nametag on her

私はFibby。小さなアプリは言いました。キャプテンは彼女にネームタグをつけながら以後お見知りおきをと言いました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_11.png" width="400" height="300" >}}
kubernetes uses labels as a name tags to identify things and it can query based on these labels 

kubernetesはある物事を特定するためにネームタグのようなラベルを使います。kubernetesはそれらのラベルをもとにクエリをかけられます

labels are open-ended you can use them to indicate roles stability or other important attributes

ラベルはroleの安定性や重要な属性を示す誰でも使うことのできる変更可能なものです

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_12.png" width="400" height="300" >}}
captain kuby suggested that the app might like to move her container into a pod aboard the ship

キャプテンkubeはそのアプリケーションはコンテナを船の上のpodに移したほうが好ましいかもしれないと提案した

Pippy happly moved to coops giant boat it felt like home

Phibbyは喜んでkubeの大きな船に移しました。そしてそこは家のように感じました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_13.png" width="400" height="300" >}}
captain kuby suggested that the app might like to move her container into a pod aboard the ship
in kubernetes a pod represents a runnable unit of work usually

kubernetesにおいてポッドは通常、可動できる動作単位です

you will run a single container inside of a pod

podの中で単一のコンテナを動かします

but for cases where a few containers are tightly coupled you may opt to run more than one container inside a same pod

しかし、いくつかのコンテナが密に結合されている場合には同じpod内で1つ以上のコンテナを動かすことを選択するかもしれません

kubernetes takes on the work of connecting your pod to the network and the rest of the kubernetes ecosystem

kubernetesではpodをネットワークや他のkubernetesのエコシステムにつなぐ役割を担っています。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_14.png" width="400" height="300" >}}
phippy had some unusual interests

Phippyはいくつか興味がありました

she was really into genetics and sheep and so she asked a captain um what if I want to clone myself on-demand any number of times

彼女は遺伝学やクローン羊に興味があり、もしいつか必要にかられて自身のクローンを作りたくなった場合はどうすればよいのでしょうかと訪ねました

well that's easy said the captain he introduced her to the replication controllers

なるほど、それは簡単だよとキャプテンは答えて、彼はreplication controllersを紹介しました。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_15.png" width="400" height="300" >}}
replication controllers provide a method for managing an arbitrary number of pods

replication controllersは任意の数のpodを管理する方法を提供しています

a replication controller contains a pod template which can be replicated any number of times 

replication controllerはpodが何度も複製できるテンプレートを内包しています。

through the replication controller kubernetes will manage your pod life cycle including scheduling up and down rolling deployments and monitorring

replication controllerを通してkubernetesはpodのライフサイクルを管理しており、それはスケジュールアップやローリングデプロイメントや監視を含んでいます。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_16.png" width="400" height="300" >}}
replication controllers provide a method for managing an arbitrary number of pods
for many days and nights the little app was happy with her pod and happy with her replicas

数日間その小さなアプリケーションはpodやreplication controllerをと一緒に幸せに過ごしていました。

but only having yourself for company is not all it's cracked up to be even if it is and copies of yourself

しかし自身で楽しんでいるならたとえそれ自身かコピーであろうが、全て期待通りである限りませんでした。

captain kuby smiled benevolently I have just the thing he said no sooner had he spoken than a tunnel opened between fibbies replication controller and the rest of the ship

キャプテンkubeはうってつけのものがあるといって慈愛に満ちた笑顔を見せました。彼がそう言うか言わないかのうちに、replication controllerと船の他の箇所との間にトンネルが開通しました

with a hearty laugh captain kube said even when your clones come and go this tunnel will stay here

キャプテンkubeは大笑いして、たとえきみのクローンがいったりきたりしてもトンネルはここにある

so you can discover other pods and they can discover you 

だから君は他のpodをみつけられるし、他のpodはあなたをみつけることができますよ

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_17.png" width="400" height="300" >}}
a service tells the rest of kubernetes is environment including other pods and replication controllers

サービスは残りのkubernetesが他のpodやreplication controllerを含んだ環境であると教えてくれます

what services your application provides while pods may come and go the IP address and ports of your service remain the same

どんなサービスをあなたのアプリケーションが提供してもpodはいったりきたりしながらもサービスのポートやIPアドレスは同じままです

and the other applications can find through kubernetes as service discovery

そして他のアプリケーションがサービスディスカバリのようにkubernetesを通して見つけることができます。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_18.png" width="400" height="300" >}}
thanks to the services phippy began to explore the rest of the ship

サービスのおかげでFippyは残りの船の場所を調査し始めました

it wasn't long before phippy met goldie and they became the best of friends

まもなくPhippyはGoldieに会って、彼らは親友になりました

one day Goldie did something extraordinary

ある日Goldieは特別なことをしました

she gave Phippy a present

彼女はPhippyにプレゼントをあげました

Phippy took one look and the saddest of sad tears escaped her eyes

彼女はひと目みて、悲しそうな涙が彼女の目から漏れました

why are you so sad asked Goldie 

なんでそんな悲しそうなんだい？Goldieは訪ねました

oh I love the present but but I have nowhere to put it sniffled Fippy

プレゼントは嬉しいんだけどそれを置く場所がないんだ。Fippyはぐすんと泣いていました

but Goldie know what to do

しかしGoldieはどうすべきかわかっていました

Why not put it in a volume 

なんでvolumeに置かないんだい

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_19.png" width="400" height="300" >}}
a volume represents a location where containers can access and store infomation

volumeはコンテナがアクセスし、情報を格納できる場所を提供します。

for the application the volume appears as part of the local file system

アプリケーションにとってはvolumeがローカルファイルシステムのように見えます

but volumes may be backend by local storage SEF Gluster elastic block storage and a number of other storage backends

しかしvolumeはローカルストレージ、SEF Gluster elastic block ストレージ他の様々なストレージバックエンドかもしれません。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_20.png" width="400" height="300" >}}
Fhippy loved life abord captain kube's ship and she enjoyed the company of her new friends

Fhippyはキャプテンkubeの船の上で幸せに暮らしていました。彼女は新しい友だちとともに楽しんでいました

every replicated pod of Goldie was equally delightful

Goldieのクローンはいつも楽しそうでした

but as she throught back to her days on the scary hosted provider

しかし彼女がおそろしいホスティングプロバイダで暮らしていた時のことを思い出しました

she began to wonder if perheps she could also have a little privacy

彼女はもう少しプライバシーがあったらなと思い始めていました

sound like what you need said captain kube is a namespace

必要としているのはnamespaceだと思うよとキャプテンkubeはいいました

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_21.png" width="400" height="300" >}}
namespace functions is a grouping mechanism inside of kubernetes

namespace機能はkubernetesのグルーピング機能です

services pods replication controllers and volumes can easily cooperate wihin a namespace

services、pods、replication controllers、volumeはnamespace内で協調できます

but the namespace provides a degree of isolation from the other part of cluster

しかしnamespaceは他のクラスタからはある種隔離しています。

{{< figure src="../images/illustrated_children_s_guide_to_kubernetes_22.png" width="400" height="300" >}}
together with her new friends Phippy sailed the seas on captain kube's great boat

Phippyは友達と共に、キャプテンkubeのボートに乗って航海しました

she had many grand adventures but most importantly Phippy had fould her home

彼女は様々な冒険をしてきましたが、Phippyは自分のおうちを見つけました

and so Phippy lived happily ever after the end

そしてPhippyは幸せに暮らしましたとさ。おわり
