//
//  DetalisProfileViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
// プロフィール詳細画面
class DetalisProfileViewController: UIViewController {
    
    let screen = UIScreen.main.bounds
    
    lazy var scrollView: UIScrollView = {
        let scrolleview: UIScrollView = UIScrollView()
        scrolleview.frame = self.view.frame
        scrolleview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.53)
        scrolleview.backgroundColor = #colorLiteral(red: 0.9367260324, green: 0.9460005476, blue: 0.9460005476, alpha: 1)
        return scrolleview
    }()
    
    lazy var firstView: UIView = {
        let view: UIView = UIView()
        view.frame = CGRect(x: 0, y: -45, width: self.view.frame.width, height: self.view.frame.height * 0.65)
        view.layer.cornerRadius = 40.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var secoundView: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 40.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.frame = CGRect(x: self.firstView.frame.origin.x, y: self.firstView.frame.origin.y + self.firstView.frame.height + 5, width: self.view.frame.width, height: self.view.frame.height * 0.4)
        return view
    }()
    
    lazy var thirdView: UIView = {
        let view: UIView = UIView()
        view.layer.cornerRadius = 40.0
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.frame = CGRect(x: self.secoundView.frame.origin.x, y: self.secoundView.frame.origin.y + self.secoundView.frame.height + 5, width: self.view.frame.width, height: self.view.frame.height * 0.38)
        return view
    }()
    
    var avaterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.sizeToFit()
        return label
    }()
    
    var ageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.sizeToFit()
        label.text = "Age"
        return label
    }()
    
    var residenceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.sizeToFit()
        label.text = "住所"
        return label
    }()
    
    var genderImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "man").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue
        return imageView
    }()
    
    private var introLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.sizeToFit()
        label.text = "自己紹介"
        return label
    }()
    
    var introTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        return label
    }()
    
    private var profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "プロフィール"
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var basicInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "基本情報"
        return label
    }()
    
    private var nickNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.text = "ニックネーム"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        return label
    }()
    
    var nickNameTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    private var thirdAgeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "年齢"
        return label
    }()
    
    var thirdAgeTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    private var thirdResidenceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "居住区"
        return label
    }()
    
    var thirdResidenceTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var hobbyAndJobsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "趣味・仕事"
        return label
    }()
    
    private var hobbyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "趣味"
        return label
    }()
    
    var hobbyTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    private var jobsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "仕事"
        return label
    }()
    
    var jobsTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(firstView)
        self.firstView.addSubview(avaterImageView)
        self.firstView.addSubview(nameLabel)
        self.firstView.addSubview(ageLabel)
        self.firstView.addSubview(residenceLabel)
        self.firstView.addSubview(genderImage)
        
        self.scrollView.addSubview(secoundView)
        self.secoundView.addSubview(introLabel)
        self.secoundView.addSubview(introTextLabel)
        
        self.scrollView.addSubview(thirdView)
        self.thirdView.addSubview(profileLabel)
        self.thirdView.addSubview(basicInfoLabel)
        self.thirdView.addSubview(nickNameLabel)
        self.thirdView.addSubview(nickNameTextLabel)
        self.thirdView.addSubview(thirdAgeLabel)
        self.thirdView.addSubview(thirdAgeTextLabel)
        self.thirdView.addSubview(thirdResidenceLabel)
        self.thirdView.addSubview(thirdResidenceTextLabel)
        self.thirdView.addSubview(hobbyAndJobsLabel)
        self.thirdView.addSubview(hobbyLabel)
        self.thirdView.addSubview(hobbyTextLabel)
        self.thirdView.addSubview(jobsLabel)
        self.thirdView.addSubview(jobsTextLabel)
        
        
        avaterImageView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.firstView)
            make.width.equalTo(self.firstView.frame.width)
            make.height.equalTo(self.firstView.frame.height * 0.8)
        }
        
        nameLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.avaterImageView.snp.bottom).offset(30)
            make.left.equalTo(self.firstView).offset(screen.width * 0.1)
        }
        
        ageLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.nameLabel)
            make.left.equalTo(self.nameLabel.snp.right).offset(10)
        }
        
        residenceLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.nameLabel)
            make.left.equalTo(self.ageLabel.snp.right).offset(10)
        }
        
        genderImage.snp.makeConstraints{ (make) in
            make.top.equalTo(self.nameLabel)
            make.right.equalTo(self.firstView).offset(screen.width * -0.05)
            make.size.equalTo(27)
        }
        
        introLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.secoundView).offset(25)
            make.left.equalTo(self.secoundView).offset(40)
        }
        
        introTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.introLabel.snp.bottom).offset(10)
            make.left.equalTo(self.introLabel)
            make.right.equalTo(self.secoundView).offset(-40)
        }
        
        profileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.thirdView).offset(25)
            make.left.equalTo(self.thirdView).offset(40)
        }
        
        basicInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileLabel.snp.bottom).offset(15)
            make.left.equalTo(self.profileLabel)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.basicInfoLabel.snp.bottom).offset(12)
            make.left.equalTo(self.basicInfoLabel).offset(5)
        }
        
        nickNameTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nickNameLabel)
            make.left.equalTo(nickNameLabel.snp.right).offset(50)
        }
        
        thirdAgeLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.left.equalTo(nickNameLabel)
        }
        
        thirdAgeTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.thirdAgeLabel)
            make.left.equalTo(self.nickNameTextLabel)
        }
        
        thirdResidenceLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(thirdAgeLabel.snp.bottom).offset(10)
            make.left.equalTo(self.nickNameLabel)
        }
        
        thirdResidenceTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdResidenceLabel)
            make.left.equalTo(thirdAgeTextLabel)
        }
        
        hobbyAndJobsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdResidenceLabel.snp.bottom).offset(15)
            make.left.equalTo(basicInfoLabel)
        }
        
        hobbyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hobbyAndJobsLabel.snp.bottom).offset(10)
            make.left.equalTo(self.nickNameLabel)
        }
        
        hobbyTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.hobbyLabel)
            make.left.equalTo(self.nickNameTextLabel)
        }
        
        jobsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.hobbyLabel.snp.bottom).offset(10)
            make.left.equalTo(self.nickNameLabel)
        }
        
        jobsTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.jobsLabel)
            make.left.equalTo(self.nickNameTextLabel)
        }
        
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
