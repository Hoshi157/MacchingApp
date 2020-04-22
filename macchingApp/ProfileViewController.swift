//
//  PostViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

// tabbarのprofile確認画面
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let userDb = Firestore.firestore().collection("users")
    let userDefault = UserDefaults.standard
    var name:String?
    var uid:String?
    let screen:CGRect = UIScreen.main.bounds
    var photoImage: UIImage!
    
    lazy var avaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avaterImageTapAction(_:))))
        imageView.layer.cornerRadius = 75.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.sizeToFit()
        label.sizeToFit()
        return label
    }()
    
    lazy var verificationButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("プロフィール確認", for: .normal)
        button.setTitleColor(UIColor.orange.withAlphaComponent(0.6), for: .normal)
        button.addTarget(self, action: #selector(verificationButtonAction(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private var goodImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "good").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 0.8045804795)
        return imageView
    }()
    
    private var goodCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.5)
        label.textAlignment = .center
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        return label
    }()
    
    private var genderImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    private var tweetLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "自己紹介"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    
    private var tweetTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.2963934075)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.textAlignment = .left
        return label
    }()
    
    private var onTweetLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "プロフィール"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    private var basicInfoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "基本情報"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private var nickNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "ニックネーム"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    private var nickNameTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var ageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "年齢"
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    private var ageTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var residenceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "居住地"
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    private var residenceTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var hobbyAndJobsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "趣味・職種"
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private var hobbyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "趣味"
        label.sizeToFit()
        return label
    }()
    
    private var hobbyTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private var jobsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.text = "職種"
        label.sizeToFit()
        return label
    }()
    
    private var jobsTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var accountButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), landscapeImagePhone: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(accountButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(avaterImageView)
        self.view.addSubview(verificationButton)
        self.view.addSubview(goodCountLabel)
        self.goodCountLabel.addSubview(goodImageView)
        self.view.addSubview(genderImage)
        self.view.addSubview(tweetLabel)
        self.view.addSubview(tweetTextLabel)
        self.tweetTextLabel.addSubview(onTweetLabel)
        self.view.addSubview(profileLabel)
        self.view.addSubview(basicInfoLabel)
        self.view.addSubview(nickNameLabel)
        self.view.addSubview(nickNameTextLabel)
        self.view.addSubview(ageLabel)
        self.view.addSubview(ageTextLabel)
        self.view.addSubview(residenceLabel)
        self.view.addSubview(residenceTextLabel)
        self.view.addSubview(hobbyAndJobsLabel)
        self.view.addSubview(hobbyLabel)
        self.view.addSubview(hobbyTextLabel)
        self.view.addSubview(jobsLabel)
        self.view.addSubview(jobsTextLabel)
        
        self.navigationItem.rightBarButtonItem = accountButton
        //　タップしたらキーボードが閉じる処理
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = .white
        
        nameLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.avaterImageView).offset(60)
            make.left.equalTo(screen.width * 0.5)
            make.right.equalTo(self.view).offset(-10)
        }
        
        avaterImageView.snp.makeConstraints{ (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(95)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        verificationButton.snp.makeConstraints{ (make) in
            make.left.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        goodImageView.snp.makeConstraints{ (make) in
            make.left.equalTo(self.goodCountLabel)
            make.top.equalTo(self.goodCountLabel).offset(3)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        goodCountLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(self.avaterImageView).offset(20)
            make.top.equalTo(self.avaterImageView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.right.equalTo(self.avaterImageView).offset(-20)
        }
        
        genderImage.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.goodCountLabel)
            make.left.equalTo(self.goodCountLabel.snp.right).offset(10)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        tweetLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.goodCountLabel.snp.bottom).offset(20)
            make.left.equalTo(self.goodCountLabel.snp.left)
        }
        
        tweetTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(tweetLabel.snp.bottom).offset(5)
            make.right.equalTo(self.view).offset(-50)
            make.left.equalTo(tweetLabel).offset(15)
            make.height.equalTo(100)
        }
        
        onTweetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.tweetTextLabel).offset(3)
            make.left.equalTo(self.tweetTextLabel).offset(3)
            make.right.equalTo(self.tweetTextLabel).offset(3)
        }
        
        profileLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(tweetTextLabel.snp.bottom).offset(20)
            make.left.equalTo(self.tweetLabel)
        }
        
        basicInfoLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(profileLabel.snp.bottom).offset(10)
            make.left.equalTo(self.profileLabel)
        }
        
        nickNameLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.basicInfoLabel.snp.bottom).offset(7)
            make.left.equalTo(self.basicInfoLabel).offset(5)
        }
        
        nickNameTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.nickNameLabel)
            make.left.equalTo(self.nickNameLabel.snp.right).offset(50)
        }
        
        
        ageLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.nickNameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.nickNameLabel)
        }
        
        ageTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.ageLabel)
            make.left.equalTo(self.nickNameTextLabel)
        }
        
        residenceLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.ageLabel.snp.bottom).offset(5)
            make.left.equalTo(self.ageLabel)
        }
        
        residenceTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.residenceLabel)
            make.left.equalTo(self.ageTextLabel)
        }
        
        hobbyAndJobsLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.residenceLabel.snp.bottom).offset(7)
            make.left.equalTo(self.basicInfoLabel)
        }
        
        hobbyLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.hobbyAndJobsLabel.snp.bottom).offset(7)
            make.left.equalTo(self.residenceLabel)
        }
        
        hobbyTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.hobbyLabel)
            make.left.equalTo(self.residenceTextLabel)
        }
        
        jobsLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.hobbyLabel.snp.bottom).offset(5)
            make.left.equalTo(self.hobbyLabel)
        }
        
        jobsTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(self.jobsLabel)
            make.left.equalTo(self.hobbyTextLabel)
        }
        self.title = "プロフィール"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ローカルに自分の名前が保存されている場合、ラベルに表示
        if userDefault.string(forKey: "name") != nil{
            name = userDefault.string(forKey: "name")
            nameLabel.text = name
        }else{
            name = "アカウント未作成"
            nameLabel.text = name
        }
        // 画像はData型でローカルに保存されている
        if userDefault.data(forKey: "image") != nil {
            photoImage = userDefault.takeOutImage(fokey: "image")
            avaterImageView.image = photoImage
        }else {
            avaterImageView.image = #imageLiteral(resourceName: "no_Image")
            photoImage = #imageLiteral(resourceName: "no_Image")
        }
        if userDefault.string(forKey: "uid") != nil{
            self.uid = userDefault.string(forKey: "uid")
        }
        if (userDefault.string(forKey: "selfIntroTextView") != nil) {
            let text: String = userDefault.string(forKey: "selfIntroTextView")!
            onTweetLabel.text = text
        }else {
            onTweetLabel.text = ""
        }
        if (userDefault.string(forKey: "gender") != nil) {
            let man = "男"
            if (man == userDefault.string(forKey: "gender")) {
                let image = #imageLiteral(resourceName: "man").withRenderingMode(.alwaysTemplate)
                genderImage.image = image
                genderImage.tintColor = .blue
            }else {
                let image = #imageLiteral(resourceName: "woman").withRenderingMode(.alwaysTemplate)
                genderImage.image = image
                genderImage.tintColor = .red
            }
        }else {
            genderImage.image = #imageLiteral(resourceName: "account")
        }
        if (userDefault.string(forKey: "age") != nil) {
            ageTextLabel.text = userDefault.string(forKey: "age")
        }else {
            ageTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "residence") != nil) {
            residenceTextLabel.text = userDefault.string(forKey: "residence")
        }else {
            residenceTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "jobs") != nil) {
            jobsTextLabel.text = userDefault.string(forKey: "jobs")
        }else {
            jobsTextLabel.text = "未選択"
        }
        if (userDefault.string(forKey: "hobby") != nil) {
            hobbyTextLabel.text = userDefault.string(forKey: "hobby")
        }else {
            hobbyTextLabel.text = "未入力"
        }
        if (userDefault.string(forKey: "nickName") != nil) {
            nickNameTextLabel.text = userDefault.string(forKey: "nickName")
        }else {
            nickNameTextLabel.text = "未入力"
        }
        if (self.uid != nil) {
            userDb.document(self.uid!).collection("good").getDocuments(){ querySnapshot, error in
                guard let documets = querySnapshot?.documents else {
                    return
                }
                self.goodCountLabel.text = String(documets.count)
            }
        }else {
            self.goodCountLabel.text = "0"
        }
    }
    // アカウント移動
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC: accountViewController = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: true)
    }
    //画像タップ処理
    @objc func avaterImageTapAction(_ image:UITapGestureRecognizer) {
        let personContenerVC = personContenerViewController()
        personContenerVC.modalPresentationStyle = .fullScreen
        self.present(personContenerVC, animated: true)
    }
    // プロフィールボタンタップ処理
    @objc func verificationButtonAction(_ button: UIButton) {
        let personContenerVC = personContenerViewController()
        personContenerVC.modalPresentationStyle = .fullScreen
        self.present(personContenerVC, animated: true)
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

//　UIImageとData型に変換
extension UserDefaults {
    func setImageToData(image: UIImage, forKey: String) {
        let nsData: Data? = image.pngData()
        self.set(nsData, forKey: "image")
    }
    
    func takeOutImage(fokey: String) -> UIImage {
        let data: Data? = self.data(forKey: fokey)
        let image: UIImage = UIImage(data: data!)!
        return image
    }
}

