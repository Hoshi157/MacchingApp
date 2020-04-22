//
//  selfIntroViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/20.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class selfIntroViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    var uid: String?
    let userDB = Firestore.firestore().collection("users")
    
    lazy var backButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_left"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        button.tintColor = .black
        return button
    }()
    
    lazy var okButtonAction: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ok_button"), style: .plain, target: self, action: #selector(okButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    private var textView: UITextView = {
        let textV = UITextView()
        textV.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6)
        textV.textAlignment = .left
        textV.font = UIFont.systemFont(ofSize: 16)
        textV.layer.cornerRadius = 10.0
        textV.layer.masksToBounds = true
        return textV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(textView)
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = okButtonAction
        self.title = "自己紹介文の編集"
        
        if userDefault.string(forKey: "selfIntroTextView") != nil {
            textView.text = userDefault.string(forKey: "selfIntroTextView")
        }else {
            textView.text = ""
        }
        
        // Do any additional setup after loading the view.
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(130)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(200)
        }
        
        if (userDefault.string(forKey: "uid") != nil) {
            self.uid = userDefault.string(forKey: "uid")
        }
    }
    
    @objc func backButtonAction(_ button: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func okButtonAction(_ button: UIBarButtonItem) {
        
        if (textView.text != userDefault.string(forKey: "selfIntroTextView")) {
            userDefault.set(textView.text, forKey: "selfIntroTextView")
            if (self.uid != nil) {
                let post = ["selfIntroTextView": textView.text]
                userDB.document(self.uid!).updateData(post as [String : Any])
            }
            alertAction(text: "")
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
