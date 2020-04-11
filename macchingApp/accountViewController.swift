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
import TPKeyboardAvoiding
// アカウント作成画面
class accountViewController: UIViewController, UITextFieldDelegate {
    
    let userDefault = UserDefaults.standard
    let app = UIApplication.shared.delegate as! AppDelegate
    let screen: CGRect = UIScreen.main.bounds
    
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
    
    lazy var dismissButtonItem: UINavigationItem = {
        let button: UINavigationItem = UINavigationItem()
        button.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_right"), landscapeImagePhone: #imageLiteral(resourceName: "back_right"), style: .plain, target: self, action: #selector(dismissButtonAction(_:)))
        return button
    }()
    
    private let navigationBar: UINavigationBar = {
        let naviBar: UINavigationBar = UINavigationBar()
        naviBar.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 40)
        naviBar.barTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        naviBar.tintColor = .orange
        naviBar.setValue(true, forKey: "hidesShadow")
        return naviBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(nameTextFierld)
        self.view.addSubview(passwardTextFierld)
        self.view.addSubview(adressTextFierld)
        self.view.addSubview(loginButton)
        self.view.addSubview(navigationBar)
        
        self.navigationBar.pushItem(dismissButtonItem, animated: false)
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:))))
        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
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
                alertAction(text: "入力されていないテキストがあります")
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
                    self.userDefault.set(self.app.uid, forKey: "uid")
                    button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    let transition: CATransition = CATransition()
                    transition.duration = 0.25
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    self.view.window?.layer.add(transition, forKey: kCATransition)
                    self.dismiss(animated: false, completion: nil)
                })
            })
        }
    }
    // 戻るボタン
    @objc func dismissButtonAction(_ button: UIBarButtonItem){
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func alertAction(text:String){
        let alertController = UIAlertController(title: "アラート", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    
    
}

