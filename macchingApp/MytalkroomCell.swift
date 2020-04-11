//
//  MytalkroomCell.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation

class MytalkroomCell{
    var name:String?
    // チャットしたルームナンバーを保持
    var targetId:String?
    var image: String?
    
    init(name:String,targetId:String, image: String){
        self.name = name
        self.targetId = targetId
        self.image = image
    }
}
