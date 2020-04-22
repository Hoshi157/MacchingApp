//
//  goodTableViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
// いいね画面の設定
class goodTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let screen = UIScreen.main.bounds
    let userDefault = UserDefaults.standard
    let userDB = Firestore.firestore().collection("users")
    var goodArray = [goodTableArray]()
    
    lazy var accountButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), landscapeImagePhone: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(accountButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    lazy var tableview: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height), style: .plain)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableview)
        self.navigationItem.rightBarButtonItem = accountButton
        
        self.title = "お相手から"
        self.view.backgroundColor = .white
        
        if (self.userDefault.string(forKey: "uid") != nil) {
            let uid = self.userDefault.string(forKey: "uid")
            Firestore.firestore().collection("users").document(uid!).collection("good").addSnapshotListener { (querySnapshot, error) in
                self.goodArray = []
                guard let documents = querySnapshot?.documents else {
                    return
                }
                print(documents)
                // goodボタンがなかったときは何もしない
                if (documents.isEmpty == true) {
                    return
                }else {
                    // goodボタンの相手のIDを取得
                    documents.forEach{ diff in
                        let targetDic = diff.data() as? Dictionary<String,String>
                        for (Id,_) in targetDic! {
                            self.userDB.document(Id).getDocument(){ (document, error) in
                                guard let documentOp = document else {
                                    return
                                }
                                let name = documentOp.data()!["name"] as? String
                                let image = documentOp.data()!["image"] as? String
                                let goodCell = goodTableArray(name: name!, image: image!, uid: Id)
                                self.goodArray.append(goodCell)
                                
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = goodArray[indexPath.row].name
        let imageString = goodArray[indexPath.row].image
        let imageData = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        cell.imageView?.image = imageData?.resize(size: CGSize(width: 60, height: 60))
        
        let cellBackView: UIView = UIView()
        cellBackView.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        cell.selectedBackgroundView = cellBackView
        
        return cell
    }
    
    // セルをタップしてらgoodボタンを押した相手のプロフィールへ移動する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let targetId = goodArray[indexPath.row].uid
        let otherVC = otherContenerViewController()
        otherVC.cellTagetUid = targetId
        self.present(otherVC, animated: true)
        tableview.deselectRow(at: indexPath, animated: true)
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
