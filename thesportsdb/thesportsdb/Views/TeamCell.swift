//
//  TeamCell.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import UIKit
import AlamofireImage

class TeamCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        badgeImageView.af_cancelImageRequest()
        badgeImageView.image = nil
    }
}

// MARK: - Setup
extension TeamCell {
    
    func styleSetup() {
        badgeImageView.layer.borderWidth = 0.5
        badgeImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
