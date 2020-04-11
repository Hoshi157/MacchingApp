macching service created from swift.
# Saloon!  <img src="https://user-images.githubusercontent.com/51669998/72959475-c6330f80-3ded-11ea-8abc-861385272953.png" width="40px" height="40px">
![80pxgithub_1024](https://user-images.githubusercontent.com/51669998/72960878-a18d6680-3df2-11ea-9bb0-3d30e7960cfd.png)
<p align="center">
   <a href="https://github.com/apple/swift"><img src="https://camo.githubusercontent.com/de32b354687f1cd9b05a89e4aa03c7f2d311f294/68747470733a2f2f73776966742e6f72672f6173736574732f696d616765732f73776966742e737667" width="180px"; /></a><br>
 <a href="https://firebase.google.com/?hl=ja"><img src="https://firebase.google.com/downloads/brand-guidelines/PNG/logo-built_white.png?hl=ja" width="150px" /></a>&emsp;<a href="https://github.com/MessageKit/MessageKit"><img src="https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/mklogo.png" width="150px" height="50px"; />
 </p>
<br>
<br>
<br>
<br>


## アプリの機能


### 1.ログイン、ホーム画面

* アカウント作成せずにプロフィール表示画面(ホーム画面)を閲覧できる様にし、アカウント作成(ログイン)した時点でチャット機能、投稿機能を使用できる様にした。
* 上部のナビゲーションバーにて現在ログイン状態か、ログアウト状態かわかる様にした。

<img src="https://user-images.githubusercontent.com/51669998/79055570-fa013100-7c88-11ea-9258-88a16b61c767.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/79055611-6714c680-7c89-11ea-80d8-760d33717cd7.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/79055632-91668400-7c89-11ea-9bd4-71330403e1ba.png" width="200px">


### 2.アカウント作成

* 左上部のアカウントボタンをプッシュすることでアカウント作成画面が表示される。
* 登録ボタンを押すことでアカウントの登録ができ、チャット機能、投稿機能が使用できる。

<img src="https://user-images.githubusercontent.com/51669998/79055666-d25e9880-7c89-11ea-97b1-b1e8f0d1d4e5.png" width="200px">

### 3.プロフィール投稿機能

* 名前はアカウント作成時の名前が自動入力され、画像をタップするとアバター画像が表示できる様になります。
* プロフィールを投稿する画面では名前、テキスト(ホーム画面には表示はされない),写真が投稿できます。

<img src="https://user-images.githubusercontent.com/51669998/79055700-09cd4500-7c8a-11ea-8416-fdcb09bed827.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/79055704-0e91f900-7c8a-11ea-98f2-07ff0cf18f6f.png" width="200px">&emsp;

### 4.チャット機能（トーク履歴記憶保持機能）

* ホーム画面でチャットしたい相手の画像をタップするとトークルームが作成され、チャットできる様になります。
* 一度チャットした相手はトークルームに追加・保持され、チャットを継続することができます。
* トークルームに追加された相手のセルをタップすることでもチャット画面に行くことができます。

<img src="https://user-images.githubusercontent.com/51669998/79055737-5749b200-7c8a-11ea-98fa-1d2d5b747de6.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/79055744-5ca6fc80-7c8a-11ea-9c42-0fda0fa67018.png" width="200px">&emsp;

### 4.アイコン
* 機能とは関係ないですがsketchでアイコンを自作しました。(一応、マッチとライターです)

<img src="https://user-images.githubusercontent.com/51669998/73010694-37a6a880-3e56-11ea-8986-3adfa63016ec.png" width="200px">

## Requirement

 * Firestore  
 * Messagekit     
 * sketch  
 * SnapKit     


## Installation

```
pod "target" install
```

## 前回との改善した点

* タブコントローラーを使用することでログインした時点で機能、画面一目でわかりやすい様にした。
* アイコンに合わせて色を統一し、ログイン状態かそうでないかなどわかる様にした。
* ブラッシュアップしやすい様にストーリボードを廃止してコードのみで実装した。
* ホーム画面のセルなどを非同期で読み込むことで表示をより早くした。
* ボタンをプッシュしたときのアニメーションと追加した。


## 問題点

 * アーキテクチャは今回は使用しなかった。
 * マッチングアプリであるがいいねやタイムラインの様な機能はなく投稿して、チャットするだけの機能なため今後改善していく必要がある。
 


## License

 * MIT
