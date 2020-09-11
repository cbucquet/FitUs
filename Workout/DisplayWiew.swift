//
//  DisplayWiew.swift
//  Workout
//
//  Created by Charles on 2/22/18.
//  Copyright © 2018 charles. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

var workoutsToPoints = [0:0 , 1:3 , 2:2 , 3:1 , 4:0 , 5:0 , 6:2, 7:0]

class DisplayWiew: UIViewController {
    var didAlreadySubmit = false
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var workoutBtnOut: UIButton!
    var currentNB = 0
    var currentPoints = 0
    var cDate = ""
    @IBOutlet weak var standBtnOut: UIButton!
    @IBAction func standBtnAct(_ sender: Any) {
       // UIApplication.shared.open(URL(string : "https://docs.google.com/spreadsheets/d/15rzHyh884BZYle-5i2VwhkEWp9TLuN66hGzkG8fsZFs/edit#gid=0")!, options: [:], completionHandler: { (status) in
            
        //})
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        workoutBtnOut.setTitle("I worked out today \n(at least 30 minutes)", for: UIControlState.normal)
        workoutBtnOut.layer.cornerRadius = 5
        workoutBtnOut.layer.borderWidth = 1
        workoutBtnOut.layer.borderColor = UIColor.white.cgColor
        workoutBtnOut.titleLabel?.textAlignment = NSTextAlignment.center

        
        standBtnOut.setTitle(" View Standings ", for: UIControlState.normal)
        standBtnOut.layer.cornerRadius = 5
        standBtnOut.layer.borderWidth = 1
        standBtnOut.backgroundColor = UIColor.white
        standBtnOut.layer.borderColor = UIColor.init(red: 27/255, green: 132/255, blue: 251/255, alpha: 1).cgColor
        
        
        
        titleLbl.text = "Welcome back, \(nameOfLogger)"
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cDate = formatter.string(from: date)
        
        if UserDefaults.standard.bool(forKey: "didAlreadySubmit") == true{
            if UserDefaults.standard.string(forKey: "cDate") == cDate{
                didAlreadySubmit = true
                
            }
            else{
                didAlreadySubmit = false
                UserDefaults.standard.set(didAlreadySubmit, forKey: "didAlreadySubmit")
            }
        }
        else{
            didAlreadySubmit = false
        }
        
        
        
        Database.database().reference().queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let arrayOfName = nameOfLogger.lowercased().components(separatedBy: " ")

                for (name, array) in snapshot.value as! [String:[AnyObject]]{
                    if name == "\(arrayOfName[0])_\(arrayOfName[1])"{
                        self.currentNB = array[2] as! Int
                       self.currentPoints = array[3] as! Int
                        self.nWLbl.text = "\(self.currentPoints ?? 0) point(s)"
                    
                    }
                }
            }
            
            
        })
        
        
    }

    @IBAction func workoutBtnAct(_ sender: Any) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                if self.didAlreadySubmit == false{
                    let fullName = nameOfLogger.lowercased().components(separatedBy: " ")
                    var  personLogin = [Any]()
                    let newNB = self.currentNB + 1
                    
                    personLogin.append(fullName[0])
                    personLogin.append(fullName[1])
                    personLogin.append(newNB)
                    personLogin.append((self.currentPoints + workoutsToPoints[newNB]!) ?? 0)
                    
                    do {
                        try Database.database().reference().child("\(fullName[0])_\(fullName[1])").setValue(personLogin)
                    }
                    catch{
                        
                    }
                    
                    self.didAlreadySubmit = true
                    switch newNB {
                    case 1:
                        self.notif(title: "Congratulations!", message: "You have completed your first workout! You are being rewarded with 3 points. Come back tomorrow to get more points!")
                    case 2:
                        self.notif(title: "Good Work!", message: "You have completed your second workout! You win 2 points. Come back tomorrow to get more points!")
                    case 3:
                        self.notif(title: "Hooray!", message: "You are on a roll, that's your third workout this week. You get 1 point. Come back tomorrow to get more points!")
                    case 4:
                        self.notif(title: "Congratulations!", message: "That's your fourth workout this week. You are 2 short from getting the 2 point bonus for this week. Come back tomorrow to get more points!")
                    case 5:
                        self.notif(title: "Good Work!", message: "That's your fifth workout this week. You are 1 short from getting the 2 point bonus for this week. Come back tomorrow to get more points!")
                    case 6:
                        self.notif(title: "Hooray!", message: "That's your sixth workout this week whic means you have won the 2 points bonus! Come back tomorrow to get more points!")
                    case 7:
                        self.notif(title: "Wow!", message: "That's your seventh workout this week. Congratulations on making a perfect week. Come back next week to continue with the workouts!")
                    default:
                        self.notif(title: "Congratulations!", message: "You have completed a workout! Come back tomorrow to get more points!")
                    }
                    UserDefaults.standard.set(self.didAlreadySubmit, forKey: "didAlreadySubmit")
                    UserDefaults.standard.set(self.cDate, forKey: "cDate")
                }
                else{
                    self.notif(title: "Error", message: "It looks like you have already worked out today. Come back tomorrow to improve your workout time!")
                }
            } else {
                print("Not connected")
                self.notif(title: "No Connection", message: "Please check your internet connection and try again")
            }
        })
        
        
    }
    @IBOutlet weak var nWLbl: UILabel!
    
    func notif(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
