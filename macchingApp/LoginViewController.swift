//
//  LoginViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/15.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import IBAnimatable

class LoginViewController: UIViewController {

    @IBOutlet weak var wellcomeLabel: AnimatableTextField!
    @IBOutlet weak var loginButton: AnimatableButton!
    
    @IBOutlet weak var withoutButton: AnimatableButton!
    @IBOutlet weak var accountButton: AnimatableButton!
    
    let userDefault = UserDefaults.standard
    let app = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        withoutButton.addTarget(self, action:#selector(LoginRessButtonAction(_:)), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(acountButtonAction(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(LoginButtonAction(_:)), for: .touchUpInside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillApper")
        
        if userDefault.string(forKey: "name") != nil{
            let namex = userDefault.string(forKey: "name")
            wellcomeLabel.text = "WellCome \(namex!) さん"
            loginButton.setTitle("\(namex!) さんでログイン", for: .normal)
        }else{
            wellcomeLabel.text = "WellCome ?? さん"
            loginButton.setTitle("Login", for: .normal)
        }
    }

    
    @objc func LoginRessButtonAction(_ button:UIButton){
        Auth.auth().signInAnonymously(){ (authResult,error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(homeViewController!,animated: true)
        }
        
    }
    
    
    @objc func acountButtonAction(_ button:UIButton){
        let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "account")
        self.present(accountViewController!,animated:true)
    }
    
    @objc func LoginButtonAction(_ button:UIButton){
        if userDefault.string(forKey: "adress") != nil && userDefault.string(forKey: "pass") != nil{
            let adress = userDefault.string(forKey: "adress")
            let passWord = userDefault.string(forKey: "pass")
            
            Auth.auth().signIn(withEmail: adress!, password: passWord!){ authResult,error in
                
                guard let user = authResult?.user else{return}
                self.app.uid = user.uid
                self.userDefault.set(self.app.uid!, forKey: "uid")
                
                let homeviewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(homeviewController!,animated: true)
            }
        }else{
            self.alertAction(text:"アカウントが登録されていません")
            return
        }
    }
        
        func alertAction(text:String){
            let alertController = UIAlertController(title: "アラート", message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true)
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
