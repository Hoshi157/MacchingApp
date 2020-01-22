//
//  PostViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/16.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
import IBAnimatable

class PostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var nameLabal: AnimatableLabel!
    @IBOutlet weak var avaterImage: AnimatableImageView!
    @IBOutlet weak var profirleTextView: AnimatableTextView!
    @IBOutlet weak var postButton: AnimatableButton!
    @IBOutlet weak var dismissButton: AnimatableButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var PhotoImage:UIImage!
    let userDb = Firestore.firestore().collection("users")
    let userDefault = UserDefaults.standard
    var name:String?
    let storageRootRef = Storage.storage().reference()
    let storageimageRef = Storage.storage().reference().child("images")
    var uid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:))))
        
        if userDefault.string(forKey: "uid") != nil{
            self.uid = userDefault.string(forKey: "uid")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if PhotoImage != nil{
            avaterImage.image = PhotoImage
        }else{
            PhotoImage = UIImage(named: "No Image")
            avaterImage.image = PhotoImage
        }
        
        
        if userDefault.string(forKey: "name") != nil{
            name = userDefault.string(forKey: "name")
            nameLabal.text = name
        }else{
            name = "??"
            nameLabal.text = name
        }
        
        
        avaterImage.isUserInteractionEnabled = true
        avaterImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ImageTapAction(_:))))
        postButton.addTarget(self, action: #selector(PostButtonAction(_:)), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dissmissButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func viewTapAction(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func PostButtonAction(_ button:UIButton){
        
        let imageData = PhotoImage.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        let post = ["name":name!,"text":self.profirleTextView.text!,"inRoom":"0","image":imageString]
        
        if userDefault.string(forKey: "uid") != nil{
            let uid = userDefault.string(forKey: "uid")
            userDb.document(uid!).setData(post)
        }
        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(homeViewController!,animated: true)
    }
    
    @objc func dissmissButtonAction(_ button:UIButton){
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.present(homeViewController!,animated: true)
    }
    
    
    @objc func ImageTapAction(_ sender:UITapGestureRecognizer){
        
        let aleatController = UIAlertController(title: "アバターを表示する", message: "選択してください", preferredStyle: .alert)
        
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
        PhotoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.avaterImage.image = PhotoImage
        self.dismiss(animated: true, completion: nil)
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
