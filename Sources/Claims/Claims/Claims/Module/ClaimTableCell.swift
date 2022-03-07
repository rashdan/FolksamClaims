//
//  CaseTableViewCell.swift
//  FolksamApp
//
//  Created by Johan Torell on 2021-01-28.
//

import UIKit

class ClaimTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var poirntte: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title _: String) {
//        titleLabel.text = title
    }
}
