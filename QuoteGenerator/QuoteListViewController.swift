//
//  QuoteListViewController.swift
//  QuoteGenerator
//
//  Created by Monica Mollica on 2016-04-13.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

import UIKit

class QuoteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BuilderViewControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var compositions = [Composition]()
    
    // MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        createTokenComposition()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        tableView.reloadData()
//    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return compositions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quoteCell", forIndexPath: indexPath) as! QuoteTableViewCell
        
        let composition = compositions[indexPath.row]
        cell.photoImageView.image = composition.photo.image
        cell.authorLabel.text = composition.quote.author + ":"
        cell.quoteLabel.text = composition.quote.quote
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            compositions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            //
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = sender as! NSIndexPath! {
                let composition = compositions[indexPath.row]
                let controller = segue.destinationViewController as! DetailViewController
                controller.composition = composition
            }
        } else if segue.identifier == "addComposition" {
            let controller = segue.destinationViewController as! BuilderViewController
            controller.delegate = self
        }
    }
    
    // MARK: BuilderProtocol
    
    func newComp(comp: Composition) {
        compositions.append(comp)
        
        tableView.reloadData()
    }
    
    // MARK: Helper Methods
    
    func createTokenComposition() {
        let composition = Composition()
        composition.quote.quote = "I like Fingerband"
        composition.quote.author = "Tiago"
        composition.photo.url = "random url"
        composition.photo.image = UIImage(named: "download.jpeg")!
        compositions.append(composition)
    }
    
}