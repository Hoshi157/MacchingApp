//
//  MenuViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import GuillotineMenu
import IBAnimatable
import Firebase

class MenuViewController: UIViewController,GuillotineMenu {
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var profilePostButton: UIButton!
    @IBOutlet weak var talkRoomButton: UIButton!
    
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountButton.addTarget(self, action: #selector(accountcreateAction(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction(_:)), for: .touchUpInside)
        profilePostButton.addTarget(self, action: #selector(PostViewAction(_:)), for: .touchUpInside)
        talkRoomButton.addTarget(self, action: #selector(talkRoomAction(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func talkRoomAction(_ button:UIButton){
        let talkButtonView = self.storyboard?.instantiateViewController(withIdentifier: "Talkroom")
        self.present(talkButtonView!,animated: true)
    }
    
    @objc func accountcreateAction(_ button:UIButton){
        let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "account")
        self.present(accountViewController!,animated: true)
    }
    
    @objc func logoutButtonAction(_ button:UIButton){
        do {
            try Auth.auth().signOut()
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!,animated: true)
            
        }catch let signOutError as NSError {
            print("signOut Error",signOutError)
        }
    }
    
    @objc func PostViewAction(_ button:UIButton){
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post")
        self.present(postViewController!,animated: true)
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
extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
