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
    
    // コレクションビュー作成
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationItem.rightBarButtonItem = accountButton
        self.title = "ホーム"
        
        // firebaseに保存されたユーザーの名前、画像情報を取り出しコレクションビューに反映
        Firestore.firestore().collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.MyCollections = []
            documents.forEach{ diff in
                print(diff.documentID)
                let name = diff.data()["name"] as! String
                let uid = diff.documentID
                let image = diff.data()["image"] as! String
                let hobby: String? = diff.data()["hobby"] as? String
                let intro: String? = diff.data()["selfIntroTextView"] as? String
                print(name)
                let castamCollection = CastamCollection(name:name, uid:uid, image:image, hobby: hobby, introText: intro)
                print(castamCollection)
                self.MyCollections.append(castamCollection)
                print(self.MyCollections.count)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    // アカウント作成ページへ移動する
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: true)
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
            // セルを更新
            DispatchQueue.main.async {
                cell.ImageView.image = image
                cell.setNeedsLayout()
            }
        }
        // 趣味、自己紹介ラベルはプロフィール編集画面に行かないとnilの可能性があるためnilチェック
        if (self.MyCollections[indexPath.row].hobby != nil) {
            let hobbyText = self.MyCollections[indexPath.row].hobby
            cell.HobbyLabel.text = hobbyText
        }else {
            cell.HobbyLabel.text = ""
        }
        if (self.MyCollections[indexPath.row].introText != nil) {
            let intro = self.MyCollections[indexPath.row].introText
            cell.IntroductionLabel.text = intro
        }else {
            cell.IntroductionLabel.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // セルの大きさはscreenの縦1/3, 横1/2
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2
        let cellHeight: CGFloat = UIScreen.main.bounds.height / 3
        return CGSize(width: cellWidth, height: cellHeight - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップしたcellのユーザーuidを送る
        let indexRow = indexPath.row
        let targetUid = self.MyCollections[indexRow].uid
        
        if (userDefault.string(forKey: "uid") != targetUid) {
            let otherContenerVC = otherContenerViewController()
            otherContenerVC.cellTagetUid = targetUid
            self.present(otherContenerVC, animated: true)
        }else {
            let personVC = personContenerViewController()
            self.present(personVC, animated: true)
        }
    }
    
    func alertAction(text:String){
        let alertController = UIAlertController(title: "アラート", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
}
