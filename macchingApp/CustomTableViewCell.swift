//
//  CustomTableViewCell.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/04/19.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import SnapKit
// プロフィール編集画面のカスタムセル
class CustomTableViewCell: UITableViewCell {
    
    var rightLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.text = "ピッカー"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .orange
        label.sizeToFit()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(rightLabel)
        
        
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-40)
            make.height.equalTo(self.frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
