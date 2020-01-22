//
//  MessageViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class MessageViewController: MessagesViewController {
    
    var Messages:[MockMessage] = []
    let userDefoult = UserDefaults.standard
    var name:String?
    var uid:String?
    var roomId:String?
    var chatFlg:Bool?
    var targetUid:String?
    let db = Firestore.firestore()
    let userDb = Firestore.firestore().collection("users")
    var targetRoomId:String?
    var userTargetRoomId:String?
    let width = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Message:viewDidLoad")
        // Do any additional setup after loading the view.
        self.chatFlg = false
        
        if let layot = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout{
            layot.setMessageIncomingAvatarSize(.zero)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layot.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layot.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
        }
        
            messagesCollectionView.messagesDataSource = self
            messagesCollectionView.messagesLayoutDelegate = self
            messagesCollectionView.messagesDisplayDelegate = self
            messageInputBar.delegate = self
            messagesCollectionView.messageCellDelegate = self
        
        let navBar = UINavigationBar()
        navBar.frame = CGRect(x: 0, y: 50, width: width, height:60)
        navBar.barTintColor = .lightGray
        let navItem = UINavigationItem(title: "トーク")
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissButtonAction(_:)))
        navBar.pushItem(navItem, animated: true)
        self.view.addSubview(navBar)
        
        let edgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        messagesCollectionView.contentInset = edgeInsets
        messagesCollectionView.scrollIndicatorInsets = edgeInsets
        
        if userDefoult.string(forKey: "uid") != nil && userDefoult.string(forKey: "name") != nil && userDefoult.string(forKey: "targetUid") != nil{
            self.uid = userDefoult.string(forKey: "uid")
            self.name = userDefoult.string(forKey: "name")
            self.targetUid = userDefoult.string(forKey: "targetUid")
        }else{
            self.dismiss(animated: true, completion: nil)
            return
        }
                        
    }
    
    @objc func dismissButtonAction(_ button:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        messagesCollectionView.reloadData()
        
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidApper")
        
        if self.targetRoomId != nil {
            print("targetalready")
            self.targetalreadyGetroom()
        }else{
            self.getroom()
            print("getRoom")
        }
    }
    
    func getroom(){
        if self.targetUid != nil && self.uid != self.targetUid{
            self.getNewRoomKey()
        }
    }
    
    var count = 1
    func getNewRoomKey(){
        Firestore.firestore().collection("roomKey").document("roomKeyNumber").getDocument(){ documentSnaoshot,error in
            guard let data = documentSnaoshot?.data() else{return}
            if (data.count >= 1){
                self.count = (data["Number"] as! Int) + 1
            }
            Firestore.firestore().collection("roomKey").document("roomKeyNumber").setData(["Number":self.count])
            self.roomId = String(self.count)
            self.UpdateEachInfo()
        }
    }
    
    func UpdateEachInfo(){
        userDb.document(self.targetUid!).updateData(["inRoom":self.roomId!])
        userDb.document(self.uid!).updateData(["inRoom":self.roomId!])
        userDb.document(self.uid!).collection("already").addDocument(data: [self.targetUid!:self.roomId!])
        userDb.document(self.targetUid!).collection("already").addDocument(data: [self.uid!:self.roomId!])
        
        self.getMessage()
    }
    
    func getMessage(){
        self.chatFlg = true
        db.collection("rooms").document(self.roomId!).collection("chate").addSnapshotListener{ querySnapshot,error in
            guard let snapshots = querySnapshot else{return}
            snapshots.documentChanges.forEach{ diff in
                if diff.type == .added{
                    let chateDataOp = diff.document.data() as? Dictionary<String,String>
                    guard let chateData = chateDataOp else{return}
                    
                    let text = chateData["text"]
                    let from = chateData["from"]
                    let name = chateData["name"]
                    
                    let message = MockMessage(messageId: "", sender: Sender(senderId: from!, displayName: name!), sentDate: Date(), text: text!)
                    self.Messages.append(message)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
    }
    
    func targetalreadyGetroom(){
        if self.targetUid != nil && self.uid != self.targetUid{
            userDb.document(self.targetUid!).updateData(["inRoom":self.targetRoomId!])
            userDb.document(self.uid!).updateData(["inRoom":self.targetRoomId!])
            self.targetRoomIdGetMessage()
        }
    }
    
    func targetRoomIdGetMessage(){
        self.chatFlg = true
        db.collection("rooms").document(self.targetRoomId!).collection("chate").addSnapshotListener{ querySnaoshot,eroor in
            guard let snapshots = querySnaoshot else{return}
            snapshots.documentChanges.forEach{ diff in
                if diff.type == .added{
                    let chateDataOp = diff.document.data() as? Dictionary<String,String>
                    guard let chateData = chateDataOp else{return}
                    
                    let text = chateData["text"]
                    let from = chateData["from"]
                    let name = chateData["name"]
                    
                    let message = MockMessage(messageId: "", sender: Sender(senderId: from!, displayName: name!), sentDate: Date(), text: text!)
                    self.Messages.append(message)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
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



extension MessageViewController:MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: self.uid!, displayName: self.name!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return Messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Messages.count
    }
}



extension MessageViewController:MessageInputBarDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        if chatFlg == true{
            postData(text: text)
        }else{
            print("error")
        }
        inputBar.inputTextView.text = String()
    }
    
    func postData(text:String){
        let post = ["from":currentSender().senderId,"name":currentSender().displayName,"text":text]
        
        if self.roomId != nil{
            let chateDb = Firestore.firestore().collection("rooms").document(self.roomId!).collection("chate")
            chateDb.addDocument(data: post)
        }else{
            let chateTargetDb = Firestore.firestore().collection("rooms").document(self.targetRoomId!).collection("chate")
            chateTargetDb.addDocument(data: post)
        }
    }
}



extension MessageViewController:MessagesLayoutDelegate{
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0{
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
}
}


extension MessageViewController:MessagesDisplayDelegate{
        
        func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? .magenta : .yellow
        }
        
        func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
            
            let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
            return .bubbleTail(corner, .curved)
        }
        
    }
    


extension MessageViewController:MessageCellDelegate{
        
}




