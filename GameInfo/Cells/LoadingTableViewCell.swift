//
//  LoadingTableViewCell.swift
//  GameInfo
//
//  Created by Djaka Permana on 04/06/23.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
