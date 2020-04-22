//
//  CollectionCell.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/03.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
// コレクションセルのUI
class CollectionCell: UICollectionViewCell {
    
    let screen: CGRect = UIScreen.main.bounds
    
    var NameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.sizeToFit()
        return label
    }()
    
    lazy var ImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.cornerRadius = 80.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var HobbyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        label.sizeToFit()
        return label
    }()
    
    var IntroductionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        label.font = label.font.withSize(13)
        label.numberOfLines = 3
        return label
    }()
    
    func setup() {
        contentView.addSubview(ImageView)
        contentView.addSubview(NameLabel)
        contentView.addSubview(HobbyLabel)
        contentView.addSubview(IntroductionLabel)
        
        ImageView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView).offset(20)
            make.size.height.equalTo(160)
            make.size.width.equalTo(160)
        }
        
        NameLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(ImageView.snp.bottom)
            make.left.equalTo(self.ImageView)
            make.right.equalTo(self.ImageView.snp.centerX)
        }
        
        HobbyLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(ImageView.snp.bottom)
            make.right.equalTo(self.ImageView)
            make.left.equalTo(self.ImageView.snp.centerX)
        }
        
        IntroductionLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(self.ImageView)
            make.top.equalTo(NameLabel.snp.bottom)
            make.right.equalTo(self.ImageView)
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
