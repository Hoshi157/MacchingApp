//
//  ViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import MaterialComponents
// アカウント作成画面
class accountViewController: UIViewController, UITextFieldDelegate {
    
    let userDefault = UserDefaults.standard
    let app = UIApplication.shared.delegate as! AppDelegate
    let screen: CGRect = UIScreen.main.bounds
    let usersDB = Firestore.firestore().collection("users")
    
    private var nameTextFierld: UITextField = {
        let textFierld: UITextField = UITextField()
        textFierld.backgroundColor = .white
        textFierld.placeholder = " 名前を入力"
        return textFierld
    }()
    
    private var adressTextFierld: UITextField = {
        let textFierld: UITextField = UITextField()
        textFierld.backgroundColor = .white
        textFierld.placeholder = " アドレスを入力"
        return textFierld
    }()
    
    private var passwardTextFierld: UITextField = {
        let textFierld: UITextField = UITextField()
        textFierld.backgroundColor = .white
        textFierld.placeholder = " パスワードを入力"
        return textFierld
    }()
    
    lazy var loginButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
        button.setTitle("登録する", for: .normal)
        button.layer.cornerRadius = 7.0
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var dismissButton: MDCFloatingButton = {
        let button: MDCFloatingButton = MDCFloatingButton()
        button.sizeToFit()
        button.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 0.7)
        let buttonImage: UIImage = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(nameTextFierld)
        self.view.addSubview(passwardTextFierld)
        self.view.addSubview(adressTextFierld)
        self.view.addSubview(loginButton)
        self.view.addSubview(dismissButton)
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:))))
        self.view.backgroundColor = #colorLiteral(red: 0.9569886108, green: 0.9664637456, blue: 0.9664637456, alpha: 1)
        
        nameTextFierld.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(180)
            make.height.equalTo(40)
            make.width.equalTo(230)
        }
        
        adressTextFierld.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(230)
            make.top.equalTo(nameTextFierld.snp.bottom).offset(60)
        }
        
        passwardTextFierld.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(230)
            make.top.equalTo(adressTextFierld.snp.bottom).offset(60)
        }
        
        loginButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(180)
            make.top.equalTo(passwardTextFierld.snp.bottom).offset(100)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(45)
            make.right.equalTo(self.view).offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
    }
    
    
    @objc func viewTapAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    // アカウント登録ボタン処理
    @objc func loginButtonAction(_ button: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: { ()
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
        
        if let adress = self.adressTextFierld.text, let passWard = self.passwardTextFierld.text,let name = self.nameTextFierld.text {
            
            if adress.isEmpty || passWard.isEmpty || name.isEmpty {
                print("入力されていない")
                alertAction(title: "入力されていません")
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                return
            }
            self.app.name = name
            // firebaseのアカウント作成
            Auth.auth().createUser(withEmail: adress, password: passWard, completion: { user,error in
                
                if let error = error{
                    print("error\(error.localizedDescription)")
                    return
                }
                // ローカルに保存
                self.userDefault.set(name, forKey: "name")
                self.userDefault.set(adress, forKey: "adress")
                self.userDefault.set(passWard, forKey: "pass")
                
                // ログイン
                Auth.auth().signIn(withEmail: adress, password: passWard, completion:{authResult, error in
                    
                    if error != nil {
                        print("サインインできません")
                        return
                    }
                    
                    guard let user = authResult?.user else {
                        return
                    }
                    self.app.uid = user.uid
                    self.userDefault.set(user.uid, forKey: "uid")
                    
                    // アカウント作成後,名前,ルームナンバー, 仮アバターをfirebaseへpost
                    let imageData = #imageLiteral(resourceName: "no_Image").jpegData(compressionQuality: 0.5)
                    let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
                    let post = ["name": name, "inRoom": "0", "image": imageString]
                    Firestore.firestore().collection("users").document(user.uid).setData(post)
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    // 戻るボタン
    @objc func dismissButtonAction(_ button: MDCFloatingButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func alertAction(title: String){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        self.present(alertController,animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}

