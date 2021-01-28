//
//  RepositoryCell.swift
//  iOS-ArchitectureDemo
//
//  Created by Lingye Han on 2021/1/28.
//

import UIKit

extension UITableViewCell {
    class var className: String {
        return String(describing: self)
    }
}

class RepositoryCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var starsCountLabel: UILabel!
    
    func setName(_ name: String) {
        nameLabel.text = name
    }

    func setDescription(_ description: String) {
        descriptionLabel.text = description
    }

    func setStarsCountTest(_ starsCountText: String) {
        starsCountLabel.text = starsCountText
    }
}
