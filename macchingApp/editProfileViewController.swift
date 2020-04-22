//
//  editProfileViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/18.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import Firebase

// プロフィール編集画面
class editProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // profile画面のtableView表示列
    private let profileArray: [String] = ["性別", "年齢", "居住区", "仕事", "趣味", "ニックネーム"]
    
    // pickerViewの表示列
    private let genderArray: [String] = ["未選択","男", "女"]
    private let ageArray: [String] = [
        "未選択",
        "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
        "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
        "41", "42", "43", "44", "45", "46", "47", "48", "49", "50",
        "51", "52", "53", "54", "55", "56", "57", "58", "59", "60",
        "61", "62", "63", "64", "65", "66", "67", "68", "69", "70"
    ]
    private let residenceArray: [String] = [
        "未選択",
        "北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬",
        "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福島", "山梨", "長野",
        "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山",
        "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛", "高知", "福岡",
        "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"
    ]
    private let jobsArray: [String] = [
        "未選択",
        "営業", "販売,フード,アミューズメント", "医療・福祉", "企画・経営", "建築・土木",
        "ITエンジニア", "電気・電子・機械", "医薬・化学・素材", "コンサルタント・金融",
        "不動産専門職", "クリエイティブ", "技能工・設備・配送", "農業", "公共サービス",
        "管理・事務", "美容・ブライダル・ホテル", "保育・教育", "WEB・インターネット"
    ]
    
    // picker選択した行数をtableViewに表示するための変数
    private var currentGender: String?
    private var currentAge: String?
    private var currentResidence: String?
    private var currentJobs: String?
    
    var currentHobby: String?
    var currentNickname: String?
    // 自己紹介文を保存
    private var selfInfoText: String?
    
    // tableViewの選択した行番号
    private var pickerIndexPath: IndexPath!
    
    var photoImage: UIImage!
    let userDefault = UserDefaults.standard
    // ログインしているか認証する
    var uid: String?
    var usersDB = Firestore.firestore().collection("users")
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.2)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var avaterOnLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "写真がありません"
        return label
    }()
    
    lazy var dismissButtonItem: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cross"), landscapeImagePhone: #imageLiteral(resourceName: "cross"), style: .done, target: self, action: #selector(dismissButtonAction(_:)))
        button.tintColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        return button
    }()
    
    lazy var avaterImage: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var avaterEditButton: MDCRaisedButton = {
        let button: MDCRaisedButton = MDCRaisedButton()
        button.setTitle("プロフィール写真を編集", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25.0
        button.layer.masksToBounds = true
        button.setTitleColor( #colorLiteral(red: 1, green: 0.5979574633, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(avaterEditAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private let selfIntroLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "自己紹介文"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var selfIntroTextLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6)
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfIntroLabelTapAction(_:))))
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        
        return label
    }()
    
    private var onSelfTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private var onSelfImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "back_right")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let profileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "プロフィール"
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 45
        return tableView
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.26)
        return pickerView
    }()
    
    lazy var pickerToolBar: UIToolbar = {
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        toolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        return toolBar
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneButtonAction(_:)))
        return button
    }()
    
    lazy var canselButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(canselButtonAction(_:)))
        return button
    }()
    
    private var flexible: UIBarButtonItem = {
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        return space
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(avaterImage)
        self.avaterImage.addSubview(avaterOnLabel)
        self.avaterImage.addSubview(avaterEditButton)
        self.scrollView.addSubview(selfIntroLabel)
        self.scrollView.addSubview(selfIntroTextLabel)
        self.selfIntroTextLabel.addSubview(onSelfTextLabel)
        self.selfIntroTextLabel.addSubview(onSelfImageView)
        self.scrollView.addSubview(profileLabel)
        self.scrollView.addSubview(tableView)
        self.view.addSubview(pickerView)
        self.view.addSubview(pickerToolBar)
        self.title = "プロフィールを編集"
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        pickerToolBar.items = [canselButton, flexible, doneButton]
        
        // Do any additional setup after loading the view.
        
        avaterImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView)
            make.left.equalTo(self.scrollView)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height * 0.45)
        }
        
        avaterOnLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        avaterEditButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.avaterImage).offset(-20)
            make.height.equalTo(50)
        }
        
        selfIntroLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avaterImage.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(30)
        }
        
        selfIntroTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.selfIntroLabel.snp.bottom).offset(10)
            make.left.equalTo(self.selfIntroLabel).offset(10)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(200)
        }
        
        onSelfTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.selfIntroTextLabel).offset(2)
            make.left.equalTo(self.selfIntroTextLabel).offset(2)
            make.right.equalTo(self.selfIntroTextLabel)
        }
        
        onSelfImageView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(-5)
        }
        
        profileLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.selfIntroLabel)
            make.top.equalTo(self.selfIntroTextLabel.snp.bottom).offset(30)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(270)
        }
        
        // ログインしていたら一度プロフィールをfirebaseにpostする
        if (userDefault.string(forKey: "uid") != nil) {
            self.uid = userDefault.string(forKey: "uid")
            let selfIntroSt = userDefault.string(forKey: "selfIntroTextView")
            let genderSt = userDefault.string(forKey: "gender")
            let ageSt = userDefault.string(forKey: "age")
            let residenceSt = userDefault.string(forKey: "residence")
            let jobsSt = userDefault.string(forKey: "jobs")
            let hobbySt = userDefault.string(forKey: "hobby")
            let nickNameSt = userDefault.string(forKey: "nickName")
            
            let post = ["selfIntroTextView": selfIntroSt, "gender": genderSt, "age": ageSt, "residence": residenceSt, "jobs": jobsSt, "hobby": hobbySt, "nickName": nickNameSt]
            self.usersDB.document(self.uid!).updateData(post as [String : Any])
        }
        
        if (avaterImage.image != UIImage(named: "no_Image")) {
            avaterOnLabel.text = ""
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 初期値を入力する
        if (userDefault.string(forKey: "selfIntroTextView") != nil) {
            let text: String = userDefault.string(forKey: "selfIntroTextView")!
            onSelfTextLabel.text = text
        }else {
            onSelfTextLabel.text = ""
        }
        if (userDefault.string(forKey: "gender") != nil) {
            currentGender = userDefault.string(forKey: "gender")
        }else {
            currentGender = genderArray[0]
        }
        if (userDefault.string(forKey: "age") != nil) {
            currentAge = userDefault.string(forKey: "age")
        }else {
            currentAge = ageArray[0]
        }
        if (userDefault.string(forKey: "residence") != nil) {
            currentResidence = userDefault.string(forKey: "residence")
        }else {
            currentResidence = residenceArray[0]
        }
        if (userDefault.string(forKey: "jobs") != nil) {
            currentJobs = userDefault.string(forKey: "jobs")
        }else {
            currentJobs = jobsArray[0]
        }
        if (userDefault.string(forKey: "hobby") != nil) {
            currentHobby = userDefault.string(forKey: "hobby")
        }else {
            currentHobby = "未選択"
        }
        if (userDefault.string(forKey: "nickName") != nil) {
            currentNickname = userDefault.string(forKey: "nickName")
        }else {
            currentNickname = "未選択"
        }
        if (userDefault.data(forKey: "image") != nil) {
            let image = userDefault.takeOutImage(fokey: "image")
            self.avaterImage.image = image
        }else {
            self.avaterImage.image = #imageLiteral(resourceName: "no_Image")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    // 画像ボタンタップアクション
    @objc func avaterEditAction(_ button: MDCRaisedButton) {
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
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userDefault.setImageToData(image: photoImage, forKey: "image")
        self.avaterImage.image = photoImage
        self.dismiss(animated: true, completion: nil)
        alertAction(title: "保存しました")
        // firestoreに画像を投げる
        if (self.uid != nil) {
            let imageData = photoImage.jpegData(compressionQuality: 0.5)
            let imageString = imageData?.base64EncodedString(options: .lineLength64Characters)
            let post = ["image": imageString]
            usersDB.document(self.uid!).updateData(post as [String : Any])
        }
    }
    
    
    @objc func dismissButtonAction(_ button: UINavigationItem) {
        self.dismiss(animated: true, completion:{ () in
            
        })
    }
    
    @objc func selfIntroLabelTapAction(_ button: UITapGestureRecognizer) {
        let introVC = selfIntroViewController()
        self.navigationController?.pushViewController(introVC, animated: true)
        
    }
    
    // pickerボタン
    @objc func doneButtonAction(_ button: UINavigationItem) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.26)
            self.pickerToolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion:{ (Bool) in
            let cell = self.tableView.cellForRow(at: self.pickerIndexPath) as! CustomTableViewCell
            switch (self.pickerIndexPath.row) {
            case 0:
                print(cell.rightLabel.text!)
                self.userDefault.set(cell.rightLabel.text!, forKey: "gender")
                if (self.uid != nil) {
                    self.usersDB.document(self.uid!).updateData(["gender":cell.rightLabel.text!])
                }
            case 1:
                print(cell.rightLabel.text!)
                self.userDefault.set(cell.rightLabel.text!, forKey: "age")
                if (self.uid != nil) {
                    self.usersDB.document(self.uid!).updateData(["age": cell.rightLabel.text!])
                }
            case 2:
                print(cell.rightLabel.text!)
                self.userDefault.set(cell.rightLabel.text!, forKey: "residence")
                if (self.uid != nil) {
                    self.usersDB.document(self.uid!).updateData(["residence": cell.rightLabel.text!])
                }
            case 3:
                print(cell.rightLabel.text!)
                self.userDefault.set(cell.rightLabel.text!, forKey: "jobs")
                self.usersDB.document(self.uid!).updateData(["jobs": cell.rightLabel.text!])
            default:
                print("")
            }
            self.alertAction(title: "保存しました")
        })
    }
    
    @objc func canselButtonAction(_ button: UINavigationItem) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height * 0.26)
            self.pickerToolBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        }, completion: nil)
    }
    
    // tableViewの設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = profileArray[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        
        switch (indexPath.row) {
        case 0:
            cell.rightLabel.text = currentGender
        case 1:
            cell.rightLabel.text = currentAge
        case 2:
            cell.rightLabel.text = currentResidence
        case 3:
            cell.rightLabel.text = currentJobs
        case 4:
            cell.rightLabel.text = currentHobby
        case 5:
            cell.rightLabel.text = currentNickname
        default:
            print("error")
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 選択したtableViewの列番号を格納
        pickerIndexPath = indexPath
        // pickerViewの更新
        pickerView.reloadAllComponents()
        print(indexPath.row)
        
        // tableViewを選択したらpickerViewを表示
        if (indexPath.row < 4) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.26, width: self.view.frame.width, height: self.view.frame.height * 0.26)
                self.pickerToolBar.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height * 0.26 - 40, width: self.view.frame.width, height: 40)
            }, completion: nil)
        }else {
            
            // text編集画面へnavigation
            let vc = profileNavigationViewController()
            vc.indexRowInt = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // pickerの設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerIndexPath != nil) {
            switch (pickerIndexPath.row) {
            case 0:
                return genderArray.count
            case 1:
                return ageArray.count
            case 2:
                return residenceArray.count
            case 3:
                return jobsArray.count
            default:
                return 0
            }
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerIndexPath.row) {
        case 0:
            return genderArray[row]
        case 1:
            return ageArray[row]
        case 2:
            return residenceArray[row]
        case 3:
            return jobsArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at: pickerIndexPath) as! CustomTableViewCell
        switch (pickerIndexPath.row) {
        case 0:
            cell.rightLabel.text = genderArray[row]
            currentGender = genderArray[row]
        case 1:
            cell.rightLabel.text = ageArray[row]
            currentAge = ageArray[row]
        case 2:
            cell.rightLabel.text = residenceArray[row]
            currentResidence = residenceArray[row]
        case 3:
            cell.rightLabel.text = jobsArray[row]
            currentJobs = jobsArray[row]
        default:
            cell.rightLabel.text = ""
        }
    }
    
    func alertAction(title: String){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
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
