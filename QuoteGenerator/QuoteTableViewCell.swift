//
//  QuoteTableViewCell.swift
//  QuoteGenerator
//
//  Created by Monica Mollica on 2016-04-13.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    // MARK: Functions

    override func awakeFromNib() {
        super.awakeFromNib()
        //
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //
    }
}