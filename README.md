macching service created from swift.
# Saloon!  <img src="https://user-images.githubusercontent.com/51669998/72959475-c6330f80-3ded-11ea-8abc-861385272953.png" width="40px" height="40px">
![80pxgithub_1024](https://user-images.githubusercontent.com/51669998/72960878-a18d6680-3df2-11ea-9bb0-3d30e7960cfd.png)
<p align="center">
   <a href="https://github.com/apple/swift"><img src="https://camo.githubusercontent.com/de32b354687f1cd9b05a89e4aa03c7f2d311f294/68747470733a2f2f73776966742e6f72672f6173736574732f696d616765732f73776966742e737667" width="180px"; /></a><br>
 <a href="https://firebase.google.com/?hl=ja"><img src="https://firebase.google.com/downloads/brand-guidelines/PNG/logo-built_white.png?hl=ja" width="150px" /></a>&emsp;<a href="https://github.com/MessageKit/MessageKit"><img src="https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/mklogo.png" width="150px" height="50px"; /></a>&emsp;<a href="https://github.com/IBAnimatable/IBAnimatable"><img src="https://raw.githubusercontent.com/IBAnimatable/IBAnimatable-Misc/master/IBAnimatable/Hero.png" width="200px" height="50px"; /></a>
 </p>
<br>
<br>
<br>
<br>


## アプリの機能


### 1.ログイン起動

* 3番目のaccoute Createボタンでアカウントを作成しログインできます。
* 2番目のボタンのwithOut Loginではログインせずにプロフィール表示画面を見ることができますがチャット機能,プロフィール投稿機能は使用できません。

<img src="https://user-images.githubusercontent.com/51669998/73009609-3d02f380-3e54-11ea-8217-e92e1960c37a.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73010245-65d7b880-3e55-11ea-9eea-b0c3f42f7f6d.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73010394-b222f880-3e55-11ea-9efd-8589e3906cf6.png" width="200px">

### 2.プロフィール表示機能

* Users画面(プロフィール表示画面)から左上のボタンを押し、profile Postボタン(3番目)を押すことで自分のプロフィールを投稿することができます。
* プロフィールを投稿する画面では名前、テキスト(表示はされない),写真が投稿できます。(写真を投稿する際は左上の画像をタップします)

<img src="https://user-images.githubusercontent.com/51669998/73010968-c1567600-3e56-11ea-8240-52f2af724209.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73011064-e8ad4300-3e56-11ea-959b-8435cf8eb568.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73011166-11cdd380-3e57-11ea-8623-04965b30bb9c.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73011204-24480d00-3e57-11ea-9b88-e4a9722d3f59.png" width="200px">

### 3.チャット機能（トーク履歴記憶保持機能）

* User画面にてプロフィールボタンをタップすることにより、相手とチャットすることができます。
* 1度チャットした相手のトーク履歴も残り、menu画面のTook Roomボタンでチャットした相手がリスト表示されタップすると再度チャットができます。

<img src="https://user-images.githubusercontent.com/51669998/73011747-37a7a800-3e58-11ea-908e-ca01400e68e5.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73011760-3e361f80-3e58-11ea-9498-b079410262cf.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/73011768-442c0080-3e58-11ea-8fb3-9ddb818f4273.png" width="200px">


### 4.アイコン
* 機能とは関係ないですがsketchでアイコンを自作しました。(一応、マッチとライターです)

<img src="https://user-images.githubusercontent.com/51669998/73010694-37a6a880-3e56-11ea-8986-3adfa63016ec.png" width="200px">

## Requirement

 * Firestore  
 * Messagekit   
 * IBAnimatable  
 * TransitionButton  
 * TextFieldEffects  
 * GuillotineMenu
 * sketch


## Installation

```
pod "target" install
```

## 改善点

* 動作が重く読み込み、表示に時間がかかりデータが反映しないことがある。そのため非同期処理、並列処理などを使用してUXを考えないといけない
* UIのライブラリやアイコンを自作したがあまりいい出来にはならなかった。
* 今回は画像の読み取りににはFirestoreを使用している。Cloud Storegeを使用できるようにしたい。
* ホーム画面のコレクションセルをサーチバーなどを使用して絞り込みができるようにすればいいと思った。

## 感想

* 今回前回作ったChuck(ランダムマッチングチャットアプリ)を作ったことがFirestoreのデータ構造やライブラリの選定などに役立ったので自分の思い描いたアプリを0から自作することは大切だと痛感した。次回自作アプリを作る際は、上記改善点を念頭に置いて作っていきたい。


## License

 * MIT
