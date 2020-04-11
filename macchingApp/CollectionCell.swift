//
//  CollectionCell.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/03.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit

class CollectionCell: UICollectionViewCell {
    
    var NameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        label.textAlignment = .center
        return label
    }()
    
    var ImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    func setup(){
        contentView.addSubview(ImageView)
        contentView.addSubview(NameLabel)
        
        NameLabel.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview()
            make.width.equalTo(contentView.bounds.width)
            make.height.equalTo(30)
        }
        
        ImageView.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
