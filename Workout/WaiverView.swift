//
//  WaiverView.swift
//  Workout
//
//  Created by Charles on 3/18/18.
//  Copyright © 2018 charles. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
class WaiverView: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "nameOfLogger")
        var child = nameOfLogger.components(separatedBy: " ")
        if child.count >= 2{
            Database.database().reference().child("\(child[0])_\(child[1])").removeValue()
        }
        performSegue(withIdentifier: "backWaiver", sender: self)
    }
    
    @IBAction func AcceptBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Waiver", message: "I have read and agreed to the waiver", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Agree", style: UIAlertActionStyle.cancel, handler: { action in
            self.performSegue(withIdentifier: "AcceptWaiver", sender: self)

        }))
        self.present(alert, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
