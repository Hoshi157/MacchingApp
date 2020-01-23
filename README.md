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

### 2.プロフィール表示機能

* Users画面(プロフィール表示画面)から左上のボタンを押し、profile Postボタン(3番目)を押すことで自分のプロフィールを投稿することができます。
* プロフィールを投稿する画面では名前、テキスト(表示はされない),写真が投稿できます。(写真を投稿する際は左上の画像をタップします)

### 3.チャット起動

* User画面にてプロフィールボタンをタップすることにより、相手とチャットすることができます。
* 1度チャットした相手のトーク履歴も残り、menu画面のTook Roomボタンでチャットした相手がリスト表示されタップすると再度チャットができます。


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

## License

 * MIT
