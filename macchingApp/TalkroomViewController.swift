//
//  TalkroomViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase
// トークルーム
class TalkroomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var talkRooms = [MytalkroomCell]()
    let userDefault = UserDefaults.standard
    var uid:String?
    let usersDb = Firestore.firestore().collection("users")
    
    let screen = UIScreen.main.bounds.size
    
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        return tableView
    }()
    
    lazy var accountButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "account"), landscapeImagePhone: #imageLiteral(resourceName: "account"), style: .plain, target: self, action: #selector(accountButtonAction(_:)))
        button.tintColor = .orange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.talkRooms = []
        self.view.addSubview(tableView)
        self.navigationItem.leftBarButtonItem = accountButton
        // uidがローカルに保存していれば
        if userDefault.string(forKey: "uid") != nil {
            self.navigationItem.title = "トークルーム (ログイン)"
            uid = userDefault.string(forKey: "uid")
            // トークルーム作成
            DispatchQueue.global().async {
                self.usersDb.document(self.uid!).collection("already").getDocuments(){ queryDocuments,error in
                    if queryDocuments != nil{
                        print("talkroomを表示する")
                        guard let documens = queryDocuments?.documents else{return}
                        documens.forEach{ diff in
                            let targetIdandRoomId = diff.data() as? Dictionary<String,String>
                            // チャットした相手のIDとルームナンバーを取得
                            for (id,roomNumber) in targetIdandRoomId!{
                                self.usersDb.document(id).getDocument(){document,error in
                                    guard let documentOp = document else{return}
                                    let targetName: String? = documentOp.data()!["name"] as? String
                                    let RoomNumber: String = roomNumber
                                    let image: String? = documentOp.data()!["image"] as? String
                                    let talkRoomCell = MytalkroomCell(name: targetName!,targetId: RoomNumber,image: image!)
                                    self.talkRooms.append(talkRoomCell)
                                    print(self.talkRooms.count)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else {
            self.navigationItem.title = "トークルーム (ログアウト)"
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func accountButtonAction(_ button: UIBarButtonItem) {
        let accountVC: accountViewController = accountViewController()
        accountVC.modalPresentationStyle = .fullScreen
        let transition: CATransition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        present(accountVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.talkRooms.count)
        return self.talkRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.talkRooms[indexPath.row].name!
        
        let cellBackView: UIView = UIView()
        cellBackView.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        cell.selectedBackgroundView = cellBackView
        // 画像データはサブスレッドにて処理
        DispatchQueue.global().async {
            let imageString: String = self.talkRooms[indexPath.row].image!
            let image: UIImage? = UIImage(data: Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)!)
            DispatchQueue.main.async {
                if image! != UIImage(named: "No Image") {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    // セルをタップしたらチャット画面へ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetUid = talkRooms[indexPath.row].targetId
        let messageView = MessageViewController()
        messageView.modalPresentationStyle = .fullScreen
        messageView.targetRoomId = targetUid
        self.present(messageView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
