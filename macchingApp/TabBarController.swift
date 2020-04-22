//
//  TabBarController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/03.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase

// タブコントローラーを設置
class TabBarController: UITabBarController {
    // virecontrollerの配列を設置
    var ViewVontrollers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController: UINavigationController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem.image = #imageLiteral(resourceName: "Home")
        homeViewController.tabBarItem.title = "ホーム"
        homeViewController.navigationBar.barTintColor = .white
        self.ViewVontrollers.append(homeViewController)
        
        let profileViewController: UINavigationController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.navigationBar.barTintColor = .white
        profileViewController.tabBarItem.image = #imageLiteral(resourceName: "account")
        profileViewController.tabBarItem.title = "プロフィール"
        self.ViewVontrollers.append(profileViewController)
        
        let goodTableVC : UINavigationController = UINavigationController(rootViewController: goodTableViewController())
        goodTableVC.navigationBar.barTintColor = .white
        goodTableVC.tabBarItem.image = #imageLiteral(resourceName: "good_tab")
        goodTableVC.tabBarItem.title = "お相手から"
        self.ViewVontrollers.append(goodTableVC)
        
        let talkroomViewController: UINavigationController = UINavigationController(rootViewController: TalkroomViewController())
        talkroomViewController.tabBarItem.image = #imageLiteral(resourceName: "message")
        talkroomViewController.tabBarItem.title = "メッセージ"
        talkroomViewController.navigationBar.barTintColor = .white
        self.ViewVontrollers.append(talkroomViewController)
        
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .orange
        self.setViewControllers(ViewVontrollers, animated: false)
        // Do any additional setup after loading the view.
        
        Auth.auth().signInAnonymously(completion: nil)
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
