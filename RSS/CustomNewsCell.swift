//
//  Untitled.swift
//  RSS
//
//  Created by kübra sağlam on 8.05.2025.
//

import UIKit

class CustomNewsCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var detailButtonTapped: (() -> Void)?

    @IBAction func detailButtonPressed(_ sender: UIButton) {
        detailButtonTapped?()
    }
}
