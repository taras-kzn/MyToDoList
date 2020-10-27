//
//  ListTableViewCell.swift
//  MyToDoList
//
//  Created by admin on 17.10.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        textLabel?.text = "это строка"
        textLabel?.textColor = .white
    }
}

extension ListTableViewCell {
    static var reuseId: String {
        return String(describing: "ListTableViewCell")
    }
}
