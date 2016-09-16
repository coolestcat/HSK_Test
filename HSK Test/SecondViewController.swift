//
//  SecondViewController.swift
//  HSK Test
//
//  Created by Alvin Leung on 2015-01-26.
//  Copyright (c) 2015 Alvin Leung. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    let transitionManager = TransitionManager()
    let downTransitionManager = DownTransitionManager()
    var han = "Label1"
    var tra = "Label2"
    var pin = "Label3"
    var eng = "Label4"
    var jyu = "Label5"
    var colour = 0
    var count = 0
    
    @IBOutlet weak var hanLabel: UILabel!
    
    @IBOutlet weak var traLabel: UILabel!
    
    @IBOutlet weak var pinLabel: UILabel!
    
    @IBOutlet weak var engLabel: UILabel!
    
    @IBOutlet weak var jyuLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        recognizer.direction = .Left
        self.view.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view, typically from a nib.
        
        let secondRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        secondRecognizer.direction = .Up
        self.view.addGestureRecognizer(secondRecognizer)
        
        hanLabel.text = han
        traLabel.text = tra
        pinLabel.text = pin
        engLabel.text = eng
        jyuLabel.text = jyu
        
        if (self.colour == 0){
            self.view.backgroundColor = UIColor.whiteColor()
        }
        else if (self.colour == 1){
            self.view.backgroundColor = UIColor.yellowColor()
        }
        else{
            self.view.backgroundColor = UIColor.greenColor()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Second2First") {
            var svc = segue.destinationViewController as ViewController
            svc.transitioningDelegate = self.transitionManager
            svc.count = self.count
        }
        if (segue.identifier == "Second2Third") {
            var svc = segue.destinationViewController as ThirdViewController
            svc.transitioningDelegate = self.downTransitionManager
            svc.han = self.han
            svc.tra = self.tra
            svc.pin = self.pin
            svc.eng = self.eng
            svc.jyu = self.jyu
            svc.colour = self.colour
            svc.count = self.count
        }
    }
    
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("Second2First", sender: self)
    }
    
    func swipeUp(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("Second2Third", sender: self)
    }
    
    
    
}

