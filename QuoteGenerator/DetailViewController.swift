//
//  DetailViewController.swift
//  QuoteGenerator
//
//  Created by Monica Mollica on 2016-04-13.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var xibView: UIView!
    
    // MARK: Properties
    
    var composition = Composition()
    var delegate = CompositionDelegate.self
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let objects = NSBundle.mainBundle().loadNibNamed("QuoteView", owner: nil, options: [:]),
            let view = objects.first as? QuoteView {
            
            view.photoImageView.image = composition.photo.image
            view.quoteLabel.text = composition.quote.quote
            view.authorLabel.text = composition.quote.author
            
            xibView.addSubview(view)
            xibView.clipsToBounds = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func publishButtonPressed(sender: AnyObject) {
        // Do publishing
    }
}