//
//  CastamCollection.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/03.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation

class CastamCollection {
    // コレクションセル(配列)は名前、ID,画像を保持
    var name:String?
    var uid:String?
    var image:String?
    var hobby: String?
    var introText: String?
    
    init(name:String,uid:String,image:String, hobby: String?, introText: String?) {
        
        self.name = name
        self.uid = uid
        self.image = image
        self.hobby = hobby
        self.introText = introText
    }
}
