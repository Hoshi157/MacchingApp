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
    
    init(name:String,uid:String,image:String) {
        
        self.name = name
        self.uid = uid
        self.image = image
    }
}
