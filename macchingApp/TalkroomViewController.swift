//
//  TalkroomViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import Firebase

class TalkroomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var talkRooms = [MytalkroomCell]()
    let userDefault = UserDefaults.standard
    var uid:String?
    let usersDb = Firestore.firestore().collection("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.talkRooms = []
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if userDefault.string(forKey: "uid") != nil{
            uid = userDefault.string(forKey: "uid")
            
            usersDb.document(uid!).collection("already").getDocuments(){queryDocuments,error in
                if queryDocuments != nil{
                    print("talkroomを表示する")
                    guard let documens = queryDocuments?.documents else{return}
                    documens.forEach{diff in
                        let targetIdandRoomId = diff.data() as? Dictionary<String,String>
                        for (id,roomId) in targetIdandRoomId!{
                            self.usersDb.document(id).getDocument(){document,error in
                                guard let documentOp = document else{return}
                                let targetName = documentOp.data()!["name"] as? String
                                let RoomId = roomId
                                let talkRoomCell = MytalkroomCell(name:targetName!,targetId:RoomId)
                                self.talkRooms.append(talkRoomCell)
                                print("viewDidload\(self.talkRooms)")
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.talkRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        cell.textLabel?.text = self.talkRooms[indexPath.row].name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetUid = talkRooms[indexPath.row].targetId
        let messageView = self.storyboard?.instantiateViewController(withIdentifier: "Message") as? MessageViewController
        messageView?.targetRoomId = targetUid
        self.present(messageView!,animated: true)
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
