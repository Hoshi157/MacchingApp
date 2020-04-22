//
//  profileNavigationViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/19.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class profileNavigationViewController: UIViewController {
    
    // 4なら趣味・5ならニックネーム
    var indexRowInt: Int?
    let userDefault = UserDefaults.standard
    var uid: String?
    let userDB = Firestore.firestore().collection("users")
    
    // tableView選択時画面
    lazy var backButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_left"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        button.tintColor = .black
        return button
    }()
    
    lazy var okButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ok_button"), style: .plain, target: self, action: #selector(okButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    private var profileText: UITextField = {
        let text: UITextField = UITextField()
        text.textAlignment = .left
        text.placeholder = "入力してください"
        text.layer.cornerRadius = 5.0
        text.layer.masksToBounds = true
        text.borderStyle = .roundedRect
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(profileText)
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = okButton
        self.navigationController?.navigationBar.barTintColor = .white
        
        // タイトルを変更, 初期値を設定
        if (indexRowInt == 4) {
            self.title = "趣味を編集"
            if (userDefault.string(forKey: "hobby") != nil) {
                profileText.text = userDefault.string(forKey: "hobby")
            }else {
                profileText.text = ""
            }
        }else {
            self.title = "ニックネームを編集"
            if (userDefault.string(forKey: "nickName") != nil) {
                profileText.text = userDefault.string(forKey: "nickName")
            }else {
                profileText.text = ""
            }
        }
        
        profileText.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(130)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(350)
        }
        
        if (userDefault.string(forKey: "uid") != nil) {
            self.uid = userDefault.string(forKey: "uid")
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonAction(_ button: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func okButtonAction(_ button: UIBarButtonItem) {
        if (indexRowInt == 4) {
            if (profileText.text != userDefault.string(forKey: "hobby")) {
                userDefault.set(profileText.text, forKey: "hobby")
                if (self.uid != nil) {
                    let post = ["hobby": profileText.text]
                    userDB.document(self.uid!).updateData(post as [String : Any])
                }
                alertAction(text: "")
            }
        }else {
            if (profileText.text != userDefault.string(forKey: "nickName")) {
                userDefault.set(profileText.text, forKey: "nickName")
                if (self.uid != nil) {
                    let post = ["nickName": profileText.text]
                    userDB.document(self.uid!).updateData(post as [String : Any])
                }
                alertAction(text: "")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func alertAction(text:String){
        let alertController = UIAlertController(title: "保存しました", message: text, preferredStyle: .alert)
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
