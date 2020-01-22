//
//  ViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import TransitionButton
import Firebase
import TextFieldEffects
import IBAnimatable


class accountViewController: UIViewController,UITextFieldDelegate {
    
   
    @IBOutlet weak var nameTextFirld: KaedeTextField!
    @IBOutlet weak var adressTextFirld: KaedeTextField!
    @IBOutlet weak var passWardTextFirld: KaedeTextField!
    @IBOutlet weak var LoginButton: TransitionButton!
    @IBOutlet weak var dismissButton: AnimatableButton!
    @IBOutlet weak var stackView: UIStackView!
    
    let userDefault = UserDefaults.standard
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextFirld.delegate = self
        adressTextFirld.delegate = self
        passWardTextFirld.delegate = self
        adressTextFirld.placeholderColor = .darkGray
        adressTextFirld.foregroundColor = .lightGray
        adressTextFirld.backgroundColor = .white
        passWardTextFirld.placeholderColor = .darkGray
        passWardTextFirld.foregroundColor = .lightGray
        passWardTextFirld.backgroundColor = .white
        nameTextFirld.placeholderColor = .darkGray
        nameTextFirld.foregroundColor = .lightGray
        nameTextFirld.backgroundColor = .white
        
        LoginButton.backgroundColor = .red
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:))))
        
        dismissButton.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @objc func viewTapAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func LoginButtonAction(_ sender: Any) {

        self.LoginButton.startAnimation()
        
        if let adress = self.adressTextFirld.text,let passWard = self.passWardTextFirld.text,let name = self.nameTextFirld.text {
            
            if adress.isEmpty || passWard.isEmpty || name.isEmpty {
                print("入力されていない")
                self.LoginButton.stopAnimation()
                alertAction(text: "入力されていないテキストがあります")
                return
            }
            self.app.name = name
            
            Auth.auth().createUser(withEmail: adress, password: passWard, completion: { user,error in
                
                if let error = error{
                    print("error\(error.localizedDescription)")
                    self.LoginButton.stopAnimation()
                    return
                }
                
                
                if self.userDefault.string(forKey: "name") == self.app.name {
                    self.alertAction(text:"この名前で既に登録されています")
                    return
                }else{
                    self.userDefault.set(name, forKey: "name")
                    self.userDefault.set(adress, forKey: "adress")
                    self.userDefault.set(passWard, forKey: "pass")
                }
                
            })
        }
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        
        backgroundQueue.async(execute: {
            sleep(3)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.LoginButton.stopAnimation(animationStyle: .expand,completion: {
                    self.dismiss(animated: true, completion:nil)
                        
                })
            })
            })
    }
    
    @objc func dismissButton(_ button:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(notification:)),name:UIResponder.keyboardWillHideNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShowNotification(notification: NSNotification){
        let userInfo = notification.userInfo
        let keybordScreenEndFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keybordY = self.view.frame.size.height - keybordScreenEndFrame.height
        let stackLimit = self.stackView.frame.origin.y + 300
        if stackLimit >= keybordY - 300{
            UIView.animate(withDuration: 0.25,delay: 0.0,options:.curveEaseIn,animations:{
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (stackLimit - (keybordY - 60)), width: self.view.bounds.width, height:self.view.bounds.height)
            },completion: nil)
        }
    }
    
    @objc func handleKeyboardWillHideNotification(notification: NSNotification){
        UIView.animate(withDuration: 0.25,delay:0.0,options:.curveEaseIn,animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        },completion: nil)
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

