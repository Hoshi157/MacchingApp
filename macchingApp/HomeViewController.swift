//
//  LoginViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/14.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import GuillotineMenu
import IBAnimatable
import Firebase

class HomeViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: DesignableNavigationBar!
    @IBOutlet weak var munuButton: UIBarButtonItem!
    let userDefault = UserDefaults.standard
    let userDb = Firestore.firestore().collection("users")
    
    var MyCollections = [MyCollectionCell]()
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MyCollections = []
            userDb.getDocuments {(querySnapshot,error) in
            guard let documens = querySnapshot?.documents else{return}
            print(documens)
            
            documens.forEach{ diff in
                print(diff.documentID)
                let name = diff.data()["name"] as! String
                let uid = diff.documentID
                let image = diff.data()["image"] as! String
                print(name)
                let mycollectionCell = MyCollectionCell(name:name, uid:uid, image:image)
                print(mycollectionCell)
                self.MyCollections.append(mycollectionCell)
                print(self.MyCollections)
                }
            self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        let menuController = self.storyboard?.instantiateViewController(withIdentifier: "menu")
        menuController?.modalPresentationStyle = .custom
        menuController?.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = self.navigationBar
        presentationAnimator.presentButton = sender as? UIButton
        present(menuController!,animated: true)
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

extension HomeViewController:UIViewControllerTransitioningDelegate,UICollectionViewDelegateFlowLayout{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.MyCollections.count)
        return self.MyCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! MyCastamClass
        cell.collectionCellNamelabel.text = MyCollections[indexPath.row].name
        let imageString = MyCollections[indexPath.row].image
        let image = UIImage(data:Data(base64Encoded:imageString!, options: .ignoreUnknownCharacters)!)
        cell.collectionCellImageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = self.view.bounds.width / 3
        return CGSize(width: cellSize - 10, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if userDefault.string(forKey: "adress") == nil || userDefault.string(forKey: "pass") == nil {
            alertAction(text: "アカウントを登録してください")
            return
        }
        let targetUid = MyCollections[indexPath.row].uid
        userDefault.set(targetUid, forKey: "targetUid")
        let uid = userDefault.string(forKey:"uid")
        
        let messageViewController = self.storyboard?.instantiateViewController(withIdentifier: "Message") as! MessageViewController
        Firestore.firestore().collection("users").document(uid!).collection("already").getDocuments(){querySnapshot,error in
            if querySnapshot != nil {
                guard let documents = querySnapshot?.documents else{return}
                for document in documents {
                    if document.data()[targetUid!] != nil{
                        let targetRoomId = document.data()[targetUid!]
                       print("targetRoomIdHome:\(targetRoomId!)")
                        messageViewController.targetRoomId = targetRoomId as? String
                        break
                    }
                    
                }
            }
            
        }
        
        self.present(messageViewController,animated: true,completion:nil)
    }
    
    func alertAction(text:String){
        let alertController = UIAlertController(title: "アラート", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
}
