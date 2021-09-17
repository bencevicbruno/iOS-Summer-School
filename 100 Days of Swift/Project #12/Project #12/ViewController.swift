//
//  ViewController.swift
//  Project #12
//
//  Created by Bruno Benčević on 8/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        defaults.set(25, forKey: "Age")
        defaults.setValue(true, forKey: "UserFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.setValue("Paul Hudson", forKey: "name")
        defaults.setValue(["hello", "there"], forKey: "arraz")
        
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBool = defaults.bool(forKey: "UserFaceID")
        // ratata
        
        let savedArraz = defaults.object(forKey: "arraz") as? [String] ?? [String]()
        // same with dicts
    
    }
}
