//
//  LoginViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    let userDb = Firestore.firestore().collection("users")
    var MyCollections = [CastamCollection]()
    let size: CGRect = UIScreen.main.bounds
    
    // コレクションビュー作成
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    // ナビケーションアイテムにアカウントボタンを設置する
    lazy var accountButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), landscapeImagePhone: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(accountButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        // ローカルに自分のID(uid)が保存しているかでアカウントを作成したか判断
        if userDefault.string(forKey: "uid") != nil {
            self.navigationItem.title = "ホーム (ログイン)"
        }else {
            self.navigationItem.title = "ホーム (ログアウト)"
            
            // アカウントを作成していない場合、匿名ログインする
            Auth.auth().signInAnonymously() { (authResult, error) in
                if error != nil {
                    print("エラー")
                    return
                }
            }
            
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationItem.leftBarButtonItem = accountButton
        
        // Do any additional setup after loading the view.
    }
    // アカウント作成ページへ移動する
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        let transition: CATransition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        present(accountVC, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MyCollections = []
        // firebaseに保存されたユーザーの名前、画像情報を取り出しコレクションビューに反映
        userDb.getDocuments {(querySnapshot,error) in
            guard let documens = querySnapshot?.documents else{return}
            print(documens)
            
            documens.forEach{ diff in
                print(diff.documentID)
                let name = diff.data()["name"] as! String
                let uid = diff.documentID
                let image = diff.data()["image"] as! String
                print(name)
                let castamCollection = CastamCollection(name:name, uid:uid, image:image)
                print(castamCollection)
                self.MyCollections.append(castamCollection)
                print(self.MyCollections.count)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.MyCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! CollectionCell
        let name: String = self.MyCollections[indexPath.item].name!
        cell.NameLabel.text = name
        // 画像情報はサブスレッドで更新
        DispatchQueue.global().async {
            let imageString: String = self.MyCollections[indexPath.item].image!
            let image: UIImage? = UIImage(data: Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!)
            // 元からセットしてある画像ではなかったらセルを更新
            DispatchQueue.main.async {
                if image! != UIImage(named: "No Image") {
                    cell.ImageView.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // セルの大きさは画面の3分の１
        let cellSise: CGFloat = self.view.bounds.width / 3
        return CGSize(width: cellSise - 5, height: cellSise)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ローカルにuidが保存していなけばアラート表示
        if userDefault.string(forKey: "uid") == nil {
            alertAction(text: "アカウントを登録してください")
            return
        }
        // チャットする相手のuidを取得,ローカルに保存
        let targetUid = MyCollections[indexPath.row].uid
        userDefault.set(targetUid, forKey: "targetUid")
        
        let uid = userDefault.string(forKey:"uid")
        let messageViewController: MessageViewController = MessageViewController()
        messageViewController.modalPresentationStyle = .fullScreen
        // firebaseにて過去にチャット歴があればルームナンバーを取得する
        Firestore.firestore().collection("users").document(uid!).collection("already").getDocuments(){querySnapshot,error in
            if querySnapshot != nil {
                guard let documents = querySnapshot?.documents else{return}
                for document in documents {
                    // チャット歴があればMessageViewControllerにルームナンバーを投げる
                    if document.data()[targetUid!] != nil{
                        let targetRoomId = document.data()[targetUid!]
                        print("targetRoomIdHome:\(targetRoomId!)")
                        messageViewController.targetRoomId = targetRoomId as? String
                        // チャット歴があった時点で抜ける
                        break
                    }
                    
                }
            }
            
        }
        self.present(messageViewController, animated: true,completion:nil)
    }
    
    func alertAction(text:String){
        let alertController = UIAlertController(title: "アラート", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
}
