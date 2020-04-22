//
//  ContenerViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
// 本人のプロフィールの詳細画面
class personContenerViewController: UIViewController {
    
    let detalisProfileViewController: UIViewController = DetalisProfileViewController()
    let userDefault = UserDefaults.standard
    
    
    lazy var editButton: MDCRaisedButton = {
        let button: MDCRaisedButton = MDCRaisedButton()
        button.setTitle("プロフィールを編集する", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.7437194496, blue: 0, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 子にプロフィール詳細画面を追加
        self.addChild(detalisProfileViewController)
        self.view.addSubview(detalisProfileViewController.view)
        self.didMove(toParent: self)
        
        self.view.addSubview(editButton)
        self.view.addSubview(dismissButton)
        
        editButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-60)
            make.right.equalTo(self.view).offset(-50)
            make.left.equalTo(self.view).offset(50)
            make.height.equalTo(50)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 子viewcontrollerを取得する
        let childVC = self.children[0] as! DetalisProfileViewController;()
        // ローカルに自分の名前が保存されている場合、ラベルに表示
        if userDefault.string(forKey: "name") != nil{
            childVC.nameLabel.text = userDefault.string(forKey: "name")
        }else{
            childVC.nameLabel.text = "未作成"
        }
        // 画像はData型でローカルに保存されている
        if userDefault.data(forKey: "image") != nil {
            childVC.avaterImageView.image = userDefault.takeOutImage(fokey: "image")
        }else {
            childVC.avaterImageView.image = #imageLiteral(resourceName: "no_Image")
        }
        if (userDefault.string(forKey: "selfIntroTextView") != nil) {
            let text: String = userDefault.string(forKey: "selfIntroTextView")!
            childVC.introTextLabel.text = text
        }else {
            childVC.introTextLabel.text = ""
        }
        if (userDefault.string(forKey: "gender") != nil) {
            let man = "男"
            if (man == userDefault.string(forKey: "gender")) {
                let image = #imageLiteral(resourceName: "man").withRenderingMode(.alwaysTemplate)
                childVC.genderImage.image = image
                childVC.genderImage.tintColor = .blue
            }else {
                let image = #imageLiteral(resourceName: "woman").withRenderingMode(.alwaysTemplate)
                childVC.genderImage.image = image
                childVC.genderImage.tintColor = .red
            }
        }else {
            childVC.genderImage.image = #imageLiteral(resourceName: "account")
        }
        if (userDefault.string(forKey: "age") != nil) {
            childVC.ageLabel.text = userDefault.string(forKey: "age")
            childVC.thirdAgeTextLabel.text = userDefault.string(forKey: "age")
        }else {
            childVC.ageLabel.text = ""
            childVC.thirdAgeTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "residence") != nil) {
            childVC.residenceLabel.text = userDefault.string(forKey: "residence")
            childVC.thirdResidenceTextLabel.text = userDefault.string(forKey: "residence")
        }else {
            childVC.residenceLabel.text = ""
            childVC.thirdResidenceTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "jobs") != nil) {
            childVC.jobsTextLabel.text = userDefault.string(forKey: "jobs")
        }else {
            childVC.jobsTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "hobby") != nil) {
            childVC.hobbyTextLabel.text = userDefault.string(forKey: "hobby")
        }else {
            childVC.hobbyTextLabel.text = "未入力"
        }
        if (userDefault.string(forKey: "nickName") != nil) {
            childVC.nickNameTextLabel.text = userDefault.string(forKey: "nickName")
        }else {
            childVC.nickNameTextLabel.text = "未入力"
        }
    }
    
    @objc func dismissButtonAction(_ button: MDCFloatingButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editButtonAction(_ button: MDCRaisedButton) {
        let editProfileVC = editProfileViewController()
        let navigationVC = UINavigationController(rootViewController: editProfileVC)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true)
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
