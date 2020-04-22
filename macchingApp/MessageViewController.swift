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
// チャット画面
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
    // チャットしたルーム番号を保持(履歴があれば)
    var targetRoomId:String?
    var userTargetRoomId:String?
    let screen: CGRect = UIScreen.main.bounds
    
    lazy var naviBar: UINavigationBar = {
        let navBar: UINavigationBar = UINavigationBar()
        navBar.frame = CGRect(x: 0, y: 50, width: screen.width, height: 60)
        navBar.barTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.25)
        navBar.tintColor = .orange
        navBar.setValue(true, forKey: "hidesShadow")
        return navBar
    }()
    
    lazy var naviItem: UINavigationItem = {
        let navItem: UINavigationItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_left"), landscapeImagePhone: #imageLiteral(resourceName: "back_left"), style: .plain, target: self, action: #selector(dismissButtonAction(_:)))
        return navItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(messagesCollectionView)
        naviBar.pushItem(naviItem, animated: false)
        self.view.addSubview(naviBar)
        
        let edgeInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        messagesCollectionView.contentInset = edgeInsets
        messagesCollectionView.scrollIndicatorInsets = edgeInsets
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.2462275257)
        self.chatFlg = false
        
        if let layot = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layot.setMessageIncomingAvatarSize(.zero)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layot.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layot.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
        }
        // 自分のID、名前、チャット相手のIDを取得
        if userDefoult.string(forKey: "uid") != nil && userDefoult.string(forKey: "name") != nil && userDefoult.string(forKey: "targetUid") != nil {
            self.uid = userDefoult.string(forKey: "uid")
            self.name = userDefoult.string(forKey: "name")
            self.targetUid = userDefoult.string(forKey: "targetUid")
            self.title = "チャット (ログイン)"
        }else{
            self.dismiss(animated: false, completion: nil)
            return
        }
        
    }
    
    @objc func dismissButtonAction(_ button: UIBarButtonItem){
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
            // チャット履歴があれば
            print("targetalready")
            self.targetalreadyGetroom()
        }else{
            // チャット履歴がなければ
            self.getroom()
            print("getRoom")
        }
    }
    
    func getroom(){
        if self.targetUid != nil && self.uid != self.targetUid{
            self.getNewRoomKey()
        }
    }
    // 新しいルームナンバーを取得
    var count = 1
    func getNewRoomKey(){
        // firebaseのルームナンバーを更新
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
    // ここでチャット履歴を保持
    func UpdateEachInfo(){
        userDb.document(self.targetUid!).updateData(["inRoom":self.roomId!])
        userDb.document(self.uid!).updateData(["inRoom":self.roomId!])
        userDb.document(self.uid!).collection("already").addDocument(data: [self.targetUid!:self.roomId!])
        userDb.document(self.targetUid!).collection("already").addDocument(data: [self.uid!:self.roomId!])
        
        self.getMessage()
    }
    // チャット開始(新しい相手との)
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
        if self.targetUid != nil && self.uid != self.targetUid {
            // 自分と相手のルームナンバーを同じにする
            userDb.document(self.targetUid!).updateData(["inRoom":self.targetRoomId!])
            userDb.document(self.uid!).updateData(["inRoom":self.targetRoomId!])
            self.targetRoomIdGetMessage()
        }
    }
    // チャット開始(履歴がある相手との)
    func targetRoomIdGetMessage(){
        self.chatFlg = true
        // 追加されるたびイベント発火
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



extension MessageViewController: InputBarAccessoryViewDelegate {
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
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 1, green: 0.7573645695, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}



extension MessageViewController:MessageCellDelegate{
    
}




