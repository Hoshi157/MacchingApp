//
//  TabBarController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/03.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

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
        
        let postViewController: UINavigationController = UINavigationController(rootViewController: PostViewController())
        postViewController.navigationBar.barTintColor = .white
        postViewController.tabBarItem.image = #imageLiteral(resourceName: "Post")
        postViewController.tabBarItem.title = "ポスト"
        self.ViewVontrollers.append(postViewController)
        
        let talkroomViewController: UINavigationController = UINavigationController(rootViewController: TalkroomViewController())
        talkroomViewController.tabBarItem.image = #imageLiteral(resourceName: "message")
        talkroomViewController.navigationBar.barTintColor = .white
        talkroomViewController.tabBarItem.title = "トーク"
        self.ViewVontrollers.append(talkroomViewController)
        
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .orange
        self.setViewControllers(ViewVontrollers, animated: false)
        // Do any additional setup after loading the view.
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
