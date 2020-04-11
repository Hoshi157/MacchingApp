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

class PostViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let userDb = Firestore.firestore().collection("users")
    let userDefault = UserDefaults.standard
    var name:String?
    var uid:String?
    let screen:CGRect = UIScreen.main.bounds
    var photoImage: UIImage!
    
    private var backImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 1, green: 0.6968444496, blue: 0, alpha: 0.25)
        return imageView
    }()
    
    lazy var avaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avaterImageTapAction(_:))))
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        return label
    }()
    
    private var profirleTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.7)
        return textView
    }()
    
    lazy var postButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("投稿する", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(PostButtonAction(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 7.0
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var accountButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), landscapeImagePhone: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(accountButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.addSubview(backImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(profirleTextView)
        self.view.addSubview(postButton)
        self.view.addSubview(avaterImageView)
        
        self.navigationItem.leftBarButtonItem = accountButton
        //　タップしたらキーボードが閉じる処理
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:))))
        self.view.backgroundColor = .white
        
        nameLabel.snp.makeConstraints{ (make) in
            make.width.equalTo(200)
            make.height.equalTo(35)
            make.top.equalTo(avaterImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        avaterImageView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view).offset(120)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        backImageView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: screen.height / 2, right: 0))
        }
        
        profirleTextView.snp.makeConstraints{ (make) in
            make.top.equalTo(backImageView.snp.bottom).offset(20)
            make.right.equalTo(self.view).offset(-50)
            make.left.equalTo(self.view).offset(50)
            make.bottom.equalTo(self.view).offset(-250)
        }
        
        postButton.snp.makeConstraints{ (make) in
            make.top.equalTo(profirleTextView.snp.bottom).offset(40)
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        // ログイン判定
        if userDefault.string(forKey: "uid") != nil {
            self.navigationItem.title = "投稿 (ログイン)"
        }else {
            self.navigationItem.title = "投稿 (ログアウト)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ローカルに自分の名前が保存されている場合、ラベルに表示
        if userDefault.string(forKey: "name") != nil{
            name = userDefault.string(forKey: "name")
            nameLabel.text = name
        }else{
            name = "??"
            nameLabel.text = name
        }
        // 画像はData型でローカルに保存されている
        if userDefault.data(forKey: "image") != nil {
            photoImage = userDefault.takeOutImage(fokey: "image")
            avaterImageView.image = photoImage
        }else {
            avaterImageView.image = #imageLiteral(resourceName: "No Image")
            photoImage = #imageLiteral(resourceName: "No Image")
        }
        
        if userDefault.string(forKey: "uid") != nil{
            self.uid = userDefault.string(forKey: "uid")
        }
    }
    // アカウント移動
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC: accountViewController = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        present(accountVC, animated: false)
    }
    
    @objc func viewTapAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    // 投稿ボタン処理
    @objc func PostButtonAction(_ button:UIButton) {
        // 押したときアニメーションする
        UIView.animate(withDuration: 0.1, animations: {()
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
        // uidでログイン状態か判定
        if userDefault.string(forKey: "uid") == nil {
            alertAction(text: "アカウントを作成してください")
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            return
        }
        // firebaseに投げるため変数へ
        let imageData = photoImage.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        let post = ["name":name!,"text":self.profirleTextView.text!,"inRoom":"0","image":imageString]
        if userDefault.string(forKey: "uid") != nil{
            let uid = userDefault.string(forKey: "uid")
            // firebaseに保存する
            userDb.document(uid!).setData(post)
        }
        button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        //　投稿後、アラート表示
        let alertcontroller = UIAlertController(title: "投稿しました", message: "", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
        alertcontroller.addAction(closeAction)
        present(alertcontroller, animated: true)
    }
    //画像タップ処理
    @objc func avaterImageTapAction(_ image:UITapGestureRecognizer) {
        avaterImageView.alpha = 0.9
        let aleatController = UIAlertController(title: "自分のアバターを設定する", message: "選択してください", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker,animated: true)
            }
        }
        aleatController.addAction(cameraAction)
        
        let photoAction = UIAlertAction(title: "アルバム", style: .default) { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker,animated: true)
            }}
        aleatController.addAction(photoAction)
        
        let canselAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        aleatController.addAction(canselAction)
        self.present(aleatController,animated: true)
        avaterImageView.alpha = 1.0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userDefault.setImageToData(image: photoImage, forKey: "image")
        self.avaterImageView.image = photoImage
        self.dismiss(animated: true, completion: nil)
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
