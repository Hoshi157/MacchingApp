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


### 1.ホーム画面

* ユーザーの画像、名前、自己紹介文、趣味を確認できる。
* セルをタップすると相手のプロフィールが閲覧できる様になっている。
* 相手のプロフィールからいいねとチャットができる。(ログイン時のみ)

<img src="https://user-images.githubusercontent.com/51669998/80036483-c6e25b80-852c-11ea-99ee-bb99f223b350.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/80036505-d06bc380-852c-11ea-8e4b-81e69f0862ff.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/80036533-e2e5fd00-852c-11ea-9616-86e9f39ed77d.png" width="200px">


### 2.プロフィール画面

* 本人のプロフィールを確認できる。
* 画像かプロフィール確認という部分をタップすることで相手が自分のアイコンをタップしたときのプロフィールを閲覧できる。
* またプロフィールを編集するボタンをタップするとプロフィールを編集することができる。

<img src="https://user-images.githubusercontent.com/51669998/80036699-39533b80-852d-11ea-865c-522621c47191.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/80036712-3ce6c280-852d-11ea-9a93-280ee2c6d367.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/80036718-3f491c80-852d-11ea-8fa4-26b54891e822.png" width="200px">

### 3.いいね画面

* 自分のことをいいねしてくれた相手を表示する。
* タップすると相手のプロフィールを閲覧することができる。

<img src="https://user-images.githubusercontent.com/51669998/80036943-ac5cb200-852d-11ea-9a29-083de457de74.png" width="200px">

### 4.メッセージ画面

* チャットした相手の履歴が表示される。
* タップするとチャットの続きを開始することができる。

<img src="https://user-images.githubusercontent.com/51669998/80036958-aff03900-852d-11ea-928e-1d3b70b4f378.png" width="200px">&emsp;
<img src="https://user-images.githubusercontent.com/51669998/80036965-b2529300-852d-11ea-8f7e-437d99fa5957.png" width="200px">


### 5.アカウント作成

* 右上のボタンを押すことでアカウント作成することができる。
* アカウント作成後自動ログインされる。
* アカウント作成することで  
① ホーム画面に自分のアイコンを表示  
② チャット機能  
③ いいね機能  
   が使える様になる。  
   
   <img src="https://user-images.githubusercontent.com/51669998/80037174-12e1d000-852e-11ea-838c-27c29f7f5460.png" width="200px">


### 6.アイコン
* 機能とは関係ないですがsketchでアイコンを自作した。
* このアプリのコンセプトとして共通の好きなものを通して繋がり,自分の持っているものでより大きな力を作る。(マッチの火薬とライターの火でより大きな火をと言う意味を込めてマッチとライターになった)

<img src="https://user-images.githubusercontent.com/51669998/73010694-37a6a880-3e56-11ea-8986-3adfa63016ec.png" width="200px">

## Requirement

 * Firestore  
 * Messagekit     
 * sketch  
 * SnapKit     
 * MaterialComponents   

## Installation

```
pod "target" install
```

## 工夫した点

* タブコントローラーを使用し使用できる機能をわかりやすい様にした。
* ストーリーボードを廃止してコードのみの実装へ変更した。
* 保存や画面更新などはuserDefaultsやFirestoreのaddSnapshotListenerに変更してデータが変更された際に自動で受け取れる様にした。



## License

 * MIT
