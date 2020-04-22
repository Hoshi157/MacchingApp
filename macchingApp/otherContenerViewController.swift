//
//  otherContenerViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import Firebase

// 他のユーザーが自分のプロフィールを見る場合
class otherContenerViewController: UIViewController {
    
    let detalisProfileViewController: DetalisProfileViewController = DetalisProfileViewController()
    let screen: CGRect = UIScreen.main.bounds
    // cellをタップしたuidを格納
    var cellTagetUid: String?
    let userDB = Firestore.firestore().collection("users")
    let userDefault = UserDefaults.standard
    // 自分のID
    var uid: String?
    
    lazy var goodButton: MDCFloatingButton = {
        let button: MDCFloatingButton = MDCFloatingButton()
        button.sizeToFit()
        button.backgroundColor = .white
        let image: UIImage = #imageLiteral(resourceName: "good").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        button.addTarget(self, action: #selector(goodAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: MDCFloatingButton = {
        let button: MDCFloatingButton = MDCFloatingButton()
        button.sizeToFit()
        button.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.5063944777)
        let buttonImage: UIImage = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var chatButton: MDCFloatingButton = {
        let button: MDCFloatingButton = MDCFloatingButton()
        button.sizeToFit()
        button.backgroundColor = .white
        button.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        let image = #imageLiteral(resourceName: "chat").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(chatButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(detalisProfileViewController)
        self.view.addSubview(detalisProfileViewController.view)
        self.didMove(toParent: self)
        
        self.view.addSubview(dismissButton)
        self.view.addSubview(goodButton)
        self.view.addSubview(chatButton)
        
        // Do any additional setup after loading the view.
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        goodButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-50)
            make.right.equalTo(self.view).offset(screen.width * -0.25)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalTo(self.goodButton)
            make.left.equalTo(self.view).offset(screen.width * 0.25)
        }
        
        if (userDefault.string(forKey: "uid") != nil) {
            self.uid = userDefault.string(forKey: "uid")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (userDefault.string(forKey: "uid") != nil) {
            self.uid = userDefault.string(forKey: "uid")
        }
        
        let childVC = self.children[0] as! DetalisProfileViewController;()
        
        if (self.cellTagetUid != nil) {
            userDB.document(self.cellTagetUid!).getDocument { (document, error) in
                if (document?.data()!["name"] != nil) {
                    let name = document?.data()!["name"] as! String
                    childVC.nameLabel.text = name
                }else {
                    childVC.nameLabel.text = "アカウント未登録"
                }
                if (document?.data()!["image"] != nil) {
                    let imageString = document?.data()!["image"] as! String
                    let image = UIImage(data: Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!)
                    childVC.avaterImageView.image = image
                }else {
                    childVC.avaterImageView.image = #imageLiteral(resourceName: "no_Image")
                }
                if (document?.data()!["age"] != nil) {
                    let age = document?.data()!["age"] as? String
                    childVC.ageLabel.text = age
                    childVC.thirdAgeTextLabel.text = age
                }else {
                    childVC.ageLabel.text = "未選択"
                    childVC.thirdAgeTextLabel.text = "未選択"
                }
                if (document?.data()!["residence"] != nil) {
                    let residence = document?.data()!["residence"] as? String
                    childVC.residenceLabel.text = residence
                    childVC.thirdResidenceTextLabel.text = residence
                }else {
                    childVC.residenceLabel.text = "未選択"
                    childVC.thirdResidenceTextLabel.text = "未選択"
                }
                if (document?.data()!["gender"] != nil) {
                    let gender = document?.data()!["gender"] as? String
                    let man = "男"
                    let woman = "女"
                    if (man == gender) {
                        childVC.genderImage.image = #imageLiteral(resourceName: "man")
                        childVC.genderImage.tintColor = .blue
                    }else if (woman == gender) {
                        childVC.genderImage.image = #imageLiteral(resourceName: "woman")
                        childVC.genderImage.tintColor = .red
                    }
                }else {
                    childVC.genderImage.image = #imageLiteral(resourceName: "account")
                }
                if (document?.data()!["selfIntroTextView"] != nil) {
                    let tweet = document?.data()!["selfIntroTextView"] as? String
                    childVC.introTextLabel.text = tweet
                }else {
                    childVC.introTextLabel.text = ""
                }
                if (document?.data()!["nickName"] != nil) {
                    let nickName = document?.data()!["nickName"] as? String
                    childVC.nickNameTextLabel.text = nickName
                }else {
                    childVC.nickNameTextLabel.text = "未選択"
                }
                if (document?.data()!["hobby"] != nil) {
                    let hobby = document?.data()!["hobby"] as? String
                    childVC.hobbyTextLabel.text = hobby
                }else {
                    childVC.hobbyTextLabel.text = "未記載"
                }
                if (document?.data()!["jobs"] != nil) {
                    let jobs = document?.data()!["jobs"] as? String
                    childVC.jobsTextLabel.text = jobs
                }else {
                    childVC.jobsTextLabel.text = "未選択"
                }
            }
            if (self.uid != nil) {
                Firestore.firestore().collection("users").document(self.cellTagetUid!).collection("good").getDocuments() {
                    (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    documents.forEach{ diff in
                        let targetUid = diff.data() as! Dictionary<String, String>
                        for (Id,_) in targetUid {
                            if (self.uid == Id) {
                                self.goodButton.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                                break
                            }else {
                                self.goodButton.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                            }
                        }
                    }
                }
            }else {
                self.goodButton.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        }
    }
    
    @objc func dismissButtonAction(_ button: MDCFloatingButton ) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chatButtonAction(_ button: MDCFloatingButton) {
        if (self.uid == nil) {
            alertAction(title: "アカウントを登録してください")
            return
        }
        // チャットする相手のuidを取得,ローカルに保存
        userDefault.set(cellTagetUid, forKey: "targetUid")
        
        let messageViewController: MessageViewController = MessageViewController()
        messageViewController.modalPresentationStyle = .fullScreen
        // firebaseにて過去にチャット歴があればルームナンバーを取得する
        Firestore.firestore().collection("users").document(self.uid!).collection("already").getDocuments(){querySnapshot,error in
            if querySnapshot != nil {
                guard let documents = querySnapshot?.documents else{return}
                for document in documents {
                    // チャット歴があればMessageViewControllerにルームナンバーを投げる
                    if document.data()[self.cellTagetUid!] != nil{
                        let targetRoomId = document.data()[self.cellTagetUid!]
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
    
    // いいねボタンの実装
    @objc func goodAction(_ button: MDCFloatingButton) {
        if (self.uid == nil) {
            alertAction(title: "アカウントを登録してください")
            return
        }
        if (self.cellTagetUid != nil) {
            Firestore.firestore().collection("users").document(self.cellTagetUid!).collection("good").getDocuments() {
                querydocuments, error in
                if (querydocuments != nil) {
                    guard let documents = querydocuments?.documents else {
                        return
                    }
                    // 空のときもfirestoreへpost
                    if (documents.isEmpty == true) {
                        Firestore.firestore().collection("users").document(self.cellTagetUid!).collection("good").addDocument(data: [self.uid!: self.uid!])
                        button.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    }
                    for document in documents {
                        print(document.data())
                        // 自分のIDがあれば削除してボタンの色を変更
                        if (document.data()[self.uid!] != nil) {
                            let documentTargetId = document.documentID
                            Firestore.firestore().collection("users").document(self.cellTagetUid!).collection("good").document(documentTargetId).delete()
                            button.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                            print("delete")
                            break
                        }else {
                            // 自分のIDがなければpost
                            Firestore.firestore().collection("users").document(self.cellTagetUid!).collection("good").addDocument(data: [self.uid!: self.uid!])
                            button.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                            print("add")
                            break
                        }
                    }
                }
            }
        }
    }
    
    func alertAction(title: String){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        self.present(alertController,animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        })
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
