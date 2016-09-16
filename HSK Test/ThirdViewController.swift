//
//  ThirdViewController.swift
//  HSK Test
//
//  Created by Alvin Leung on 2015-01-27.
//  Copyright (c) 2015 Alvin Leung. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ThirdViewController: UIViewController{
    
    let upTransitionManager = UpTransitionManager()
    var words = [NSManagedObject]()
    var notseenwords = [NSManagedObject]()
    var seenwords = [NSManagedObject]()
    
    var han = "Label1"
    var tra = "Label2"
    var pin = "Label3"
    var eng = "Label4"
    var jyu = "Label5"
    var colour = 0
    var count = 0
    
    @IBOutlet weak var notSeenLabel: UILabel!
    
    
    @IBOutlet weak var seenLabel: UILabel!
    
    
    @IBOutlet weak var masteredLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        recognizer.direction = .Down
        self.view.addGestureRecognizer(recognizer)
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var fetchRequest = NSFetchRequest(entityName:"Word")
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            words = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        var allCount : Int = words.count
        
        var freq = NSFetchRequest(entityName:"Word")
        let pred = NSPredicate(format: "cc = %i", 0)
        freq.predicate = pred
        
        let frestwo =
        managedContext.executeFetchRequest(freq,
            error: &error) as [NSManagedObject]?
        
        if let restwo = frestwo {
            notseenwords = restwo
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

        var notSeenCount : Int = notseenwords.count
        
        
        var freqtwo = NSFetchRequest(entityName:"Word")
        let predtwo = NSPredicate(format: "cc > %i", 0)
        let predtwotwo = NSPredicate(format: "cc < %i", 4)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([predtwo!, predtwotwo!])
        freqtwo.predicate = compound
        
        let fresthree =
        managedContext.executeFetchRequest(freqtwo,
            error: &error) as [NSManagedObject]?
        
        if let resthree = fresthree {
            seenwords = resthree
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        var seenCount : Int = seenwords.count
        
        var masteredCount : Int = allCount - notSeenCount - seenCount
        
        notSeenLabel.text = String(notSeenCount) + "/" + String(allCount)
        seenLabel.text = String(seenCount) + "/" + String(allCount)
        masteredLabel.text = String(masteredCount) + "/" + String(allCount)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Third2Second") {
            var svc = segue.destinationViewController as SecondViewController
            svc.transitioningDelegate = self.upTransitionManager
            svc.han = self.han
            svc.tra = self.tra
            svc.pin = self.pin
            svc.eng = self.eng
            svc.jyu = self.jyu
            svc.colour = self.colour
            svc.count = self.count
        }
    }
    
    func swipeDown(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("Third2Second", sender: self)
    }

    
    
}