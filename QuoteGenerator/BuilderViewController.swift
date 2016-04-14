//
//  BuilderViewController.swift
//  QuoteGenerator
//
//  Created by Monica Mollica on 2016-04-13.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

protocol BuilderViewControllerDelegate: class {
    func newComp(comp: Composition)
}

class BuilderViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var xibView: UIView!
    
    // MARK: Properties
    
    var composition = Composition()
    weak var delegate: BuilderViewControllerDelegate?
    
    // MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let objects = NSBundle.mainBundle().loadNibNamed("QuoteView", owner: nil, options: [:]),
            let view = objects.first as? QuoteView {
            view.authorLabel.alpha = 0
            view.quoteLabel.alpha = 0
            view.photoImageView.alpha = 0
            xibView.addSubview(view)
            xibView.clipsToBounds = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func getQuoteButtonPressed(sender: AnyObject) {
        getQuote()
    }
   
    @IBAction func getPhotoButtonPressed(sender: AnyObject) {
        getPhoto()
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
        self.delegate!.newComp(composition)
    }
    
    // MARK: Segue
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "return" {
//            let controller = segue.destinationViewController as! QuoteListViewController
//            controller.compositions.append(self.composition)
//        }
//    }
    
    // MARK: Helper Functions
    
    func getQuote() {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://api.forismatic.com/api/1.0/?method=getQuote&lang=en&format=json")
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            if let data = data, let quoteDictionary = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: String] {
                
                self.composition.quote.author = quoteDictionary["quoteAuthor"] as String!
                self.composition.quote.quote = quoteDictionary["quoteText"] as String!
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let view = self.xibView.subviews.first as? QuoteView! {
                        view.authorLabel.text = self.composition.quote.author
                        view.quoteLabel.text = self.composition.quote.quote
                        view.authorLabel.alpha = 1
                        view.quoteLabel.alpha = 1
                    }
                })
            }
        }
        task.resume()
    }
    
    func getPhoto() {
        let session = NSURLSession.sharedSession()
        let url = NSURL.init(string: "https://unsplash.it/list")
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            if let data = data, let object = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! [AnyObject] {
                
                let photoArray = object as Array!
                
                let randomNumber = arc4random_uniform(UInt32(photoArray.count)) + 1
                let rN = Int(randomNumber)
                
                let photoDictionary = photoArray[rN]
                
                self.composition.photo.url = photoDictionary["post_url"] as! String!
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let session = NSURLSession.sharedSession()
                    let url = NSURL(string: "https://unsplash.it/300/400?image=" + String(rN))
                    let imageTask = session.dataTaskWithURL(url!) { (data, response, error) in
                        
                        if let tempImage = UIImage(data: data!) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.composition.photo.image = tempImage
                                
                                if let view = self.xibView.subviews.first as? QuoteView! {
                                    
                                    view.photoImageView.image = self.composition.photo.image
                                    view.photoImageView.alpha = 1
                                }
                            })
                        }
                    }
                    imageTask.resume()
                })
            }
        }
        task.resume()
    }
}