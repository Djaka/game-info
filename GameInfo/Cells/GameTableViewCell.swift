//
//  GameTableViewCell.swift
//  GameInfo
//
//  Created by Djaka Permana on 04/06/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var ratingLogo: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleGameLabel: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    @IBOutlet weak var platformStackView: UIStackView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
