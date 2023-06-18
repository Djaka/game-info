//
//  GameTableViewCell.swift
//  GameInfo
//
//  Created by Djaka Permana on 04/06/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    var removeGame: (() -> Void)?
    var saveGame: (() -> Void)?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var ratingLogo: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleGameLabel: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    @IBOutlet weak var platformStackView: UIStackView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var gameModel: GameModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true

        favoriteView.layer.borderWidth = 1
        favoriteView.layer.masksToBounds = false
        favoriteView.layer.borderColor = UIColor(hex: "#635985").cgColor
        favoriteView.layer.cornerRadius = favoriteView.frame.height/2
        favoriteView.clipsToBounds = true

    }

    func configureCell(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    @IBAction func favoriteButtonTap(_ sender: Any) {
        guard let gameModel = gameModel else {
            return
        }
        
        if gameModel.isFavorite ?? false {
            self.removeGame?()
        } else {
            self.saveGame?()
        }
    }
}
