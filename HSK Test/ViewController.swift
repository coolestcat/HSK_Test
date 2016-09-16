//
//  ViewController.swift
//  HSK Test
//
//  Created by Alvin Leung on 2015-01-26.
//  Copyright (c) 2015 Alvin Leung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var words = [NSManagedObject]()
    var sameLengthWords = [NSManagedObject]()
    let transitionManager = TransitionManager()
    
    var r : Int = -1
    var thisH = "hh"
    var thisP = "pp"
    var thisE = "ee"
    var thisT = "tt"
    var thisJ = "jj"
    var count : Int = 0
    var allSeen : Int = 0
    var colour = 0
    
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Word")
        var error: NSError?
        var thisWordNum = 0
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("FirstTime") == nil || allSeen == 1){
            let fetchedResults =
            managedContext.executeFetchRequest(fetchRequest,
                error: &error) as [NSManagedObject]?

            if let results = fetchedResults {
                words = results
            } else {
                println("Could not fetch \(error), \(error!.userInfo)")
            }
            thisWordNum = Int(arc4random_uniform(UInt32(words.count)))
        }
        else{
            var seenOrNot = Int(arc4random_uniform(5))
            if (seenOrNot > 2){
                let pred = NSPredicate(format: "cc = %i", 0)
                fetchRequest.predicate = pred
                
                let fetchedResults =
                managedContext.executeFetchRequest(fetchRequest,
                    error: &error) as [NSManagedObject]?
                
                if let results = fetchedResults {
                    words = results
                } else {
                    println("Could not fetch \(error), \(error!.userInfo)")
                }
                
                if words.count == 1 {
                    allSeen = 1
                }
                thisWordNum = Int(arc4random_uniform(UInt32(words.count)))
            }
            else{
                let pred = NSPredicate(format: "cc > %i", 0)
                fetchRequest.predicate = pred
                
                let fetchedResults =
                managedContext.executeFetchRequest(fetchRequest,
                    error: &error) as [NSManagedObject]?
                
                if let results = fetchedResults {
                    words = results
                } else {
                    println("Could not fetch \(error), \(error!.userInfo)")
                }
                
                thisWordNum = Int(arc4random_uniform(UInt32(words.count)))
                
            }
        }
        
        self.count = self.count + 1
        
        self.r = Int(arc4random_uniform(4))
        
        thisH = words[thisWordNum].valueForKey("h") as String
        thisP = words[thisWordNum].valueForKey("p") as String
        thisE = words[thisWordNum].valueForKey("e") as String
        thisT = words[thisWordNum].valueForKey("t") as String
        thisJ = words[thisWordNum].valueForKey("j") as String
    
        var thisLeng : Int = words[thisWordNum].valueForKey("leng") as Int
        bigLabel.text = thisH
        
        //increase the seen count
        var ccc = words[thisWordNum].valueForKey("cc") as Int
        var newc = ccc + 1
        words[thisWordNum].setValue(newc, forKey: "cc")
        managedContext.save(&error)

        let fr = NSFetchRequest(entityName:"Word")
        
        fr.returnsObjectsAsFaults = false;
        
        let resultPredicate1 = NSPredicate(format: "leng = %i", thisLeng)
        
        fr.predicate = resultPredicate1
        
        var err: NSError?
        
        let res =
        managedContext.executeFetchRequest(fr,
            error: &err) as [NSManagedObject]?
        
        if let realres = res{
            sameLengthWords = realres
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        var otherPs = NSMutableSet()
        
        if sameLengthWords.count > 3{
            while otherPs.count != 3{
                var toAdd = Int(arc4random_uniform(UInt32(sameLengthWords.count)))
                if toAdd != thisWordNum{
                    otherPs.addObject(toAdd)
                }
            }
        }
        else{
            while otherPs.count != 3{
                var toAdd = Int(arc4random_uniform(UInt32(words.count)))
                if toAdd != thisWordNum{
                    otherPs.addObject(toAdd)
                }
            }
        }
        
        var otherPsArray = [Int]()
        for thing in otherPs{
            otherPsArray.append(thing as Int)
        }
        
        //turn background yellow or white (or green):
        if (ccc == 0){
            self.view.backgroundColor = UIColor.whiteColor()
            self.colour = 0
        }
        else if (ccc > 0 && ccc < 4){// 5?
            self.view.backgroundColor = UIColor.yellowColor()
            self.colour = 1
        }
        else{
            self.view.backgroundColor = UIColor.greenColor()
            self.colour = 2
        }
        
        var p1 : String
        var p2 : String
        var p3 : String
        
        if sameLengthWords.count > 3 {
            p1 = sameLengthWords[otherPsArray[0]].valueForKey("p") as String
            p2 = sameLengthWords[otherPsArray[1]].valueForKey("p") as String
            p3 = sameLengthWords[otherPsArray[2]].valueForKey("p") as String
        }
        else {
            p1 = words[otherPsArray[0]].valueForKey("p") as String
            p2 = words[otherPsArray[1]].valueForKey("p") as String
            p3 = words[otherPsArray[2]].valueForKey("p") as String
        }

        
        if r == 0 {
            firstButton.setTitle(thisP, forState: UIControlState.Normal)
            secondButton.setTitle(p1, forState: UIControlState.Normal)
            thirdButton.setTitle(p2, forState: UIControlState.Normal)
            fourthButton.setTitle(p3, forState: UIControlState.Normal)
        }
        else if r == 1{
            firstButton.setTitle(p1, forState: UIControlState.Normal)
            secondButton.setTitle(thisP, forState: UIControlState.Normal)
            thirdButton.setTitle(p2, forState: UIControlState.Normal)
            fourthButton.setTitle(p3, forState: UIControlState.Normal)
        }
        else if r == 2{
            firstButton.setTitle(p1, forState: UIControlState.Normal)
            secondButton.setTitle(p2, forState: UIControlState.Normal)
            thirdButton.setTitle(thisP, forState: UIControlState.Normal)
            fourthButton.setTitle(p3, forState: UIControlState.Normal)
        }
        else{
            firstButton.setTitle(p1, forState: UIControlState.Normal)
            secondButton.setTitle(p2, forState: UIControlState.Normal)
            thirdButton.setTitle(p3, forState: UIControlState.Normal)
            fourthButton.setTitle(thisP, forState: UIControlState.Normal)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "First2Second") {
            var svc = segue.destinationViewController as SecondViewController;
            svc.pin = thisP
            svc.han = thisH
            svc.tra = thisT
            svc.eng = thisE
            svc.jyu = thisJ
            svc.transitioningDelegate = self.transitionManager
            svc.count = self.count
            svc.colour = self.colour
        }
    }
    
    @IBAction func firstButtonAct(sender: AnyObject) {
        if self.r == 0 {
            performSegueWithIdentifier("First2Second", sender: nil)
        }
    }
    
    @IBAction func secondButtonAct(sender: AnyObject) {
        if self.r == 1 {
            performSegueWithIdentifier("First2Second", sender: nil)
        }
    }
    
    @IBAction func thirdButtonAct(sender: AnyObject) {
        if self.r == 2 {
            performSegueWithIdentifier("First2Second", sender: nil)
        }
    }
    
    @IBAction func fourthButtonAct(sender: AnyObject) {
        if self.r == 3 {
            performSegueWithIdentifier("First2Second", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

