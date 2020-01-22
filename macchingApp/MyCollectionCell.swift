//
//  MyCollectionCell.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/18.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import Foundation

class MyCollectionCell {
    
    var name:String?
    var uid:String?
    var image:String?
    
    init(name:String,uid:String,image:String) {
        self.name = name
        self.uid = uid
        self.image = image
    }
}
