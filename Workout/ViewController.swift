//
//  ViewController.swift
//  Workout
//
//  Created by Charles on 2/22/18.
//  Copyright © 2018 charles. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


var nameOfLogger = ""
class ViewController: UIViewController, UITextFieldDelegate {
    var listNames = [String:[AnyObject]]()
    @IBOutlet weak var NameLabel: UITextField!
    @IBAction func loginBtnAct(_ sender: Any) {
        login()
    }
   
    @IBAction func hideR(_ sender: Any) {
        //loginBtnOut.layer.borderColor = UIColor.clear.cgColor
        
    }
    @IBAction func rehide(_ sender: Any) {
        //loginBtnOut.layer.borderColor = UIColor.init(red: 27/255, green: 132/255, blue: 251/255, alpha: 1).cgColor
    }
    
    
    @IBOutlet weak var loginBtnOut: UIButton!
    @IBOutlet weak var titlePage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loginBtnOut.setTitle(" Login ", for: UIControlState.normal)
        loginBtnOut.layer.cornerRadius = 5
        loginBtnOut.layer.borderWidth = 1
        //loginBtnOut.layer.borderColor = UIColor.init(red: 27/255, green: 132/255, blue: 251/255, alpha: 1).cgColor
        loginBtnOut.layer.borderColor = UIColor.white.cgColor
        loginBtnOut.setTitleColor(.white, for: UIControlState.normal)
        loginBtnOut.backgroundColor = UIColor.init(red: 27/255, green: 132/255, blue: 251/255, alpha: 1)

        
        
        Database.database().reference().queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.listNames = snapshot.value as! [String:[AnyObject]]
            }
            
            
        })
        if UserDefaults.standard.string(forKey: "nameOfLogger") != nil{
            nameOfLogger = UserDefaults.standard.string(forKey: "nameOfLogger")!
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.performSegue(withIdentifier: "Login", sender: self)
            })
        }
        
        
    }

    
    
    func login(){

        var canLog = true
        let arrayOfName = NameLabel.text?.lowercased().components(separatedBy: " ")
        
        if NameLabel.text?.isEmpty != true{
            if arrayOfName!.count >= 2{
                for (name, array) in listNames{
                    if name ==  "\(arrayOfName![0])_\(arrayOfName![1])"{
                        canLog = false
                    }
                }
                if canLog == true{
                    var canGo = true
                    for char in NameLabel.text!{
                        if char == "%" || char == "." || char == "#" || char == "$" || char == "[" || char == "]" || char == "'"{
                            canGo = false
                        }
                    }
                    if canGo == true{
                        
                        let databaseRef = Database.database().reference()
                        var personLogin = [Any]()
                        let fullName = NameLabel.text?.lowercased().components(separatedBy: " ")
                        
                        
                        
                        personLogin.append(fullName![0])
                        personLogin.append(fullName![1])
                        personLogin.append(0)
                        personLogin.append(0)
                        
                        databaseRef.child("\(fullName![0])_\(fullName![1])").setValue(personLogin)
                        nameOfLogger = "\(fullName![0]) \(fullName![1])"
                        UserDefaults.standard.set(nameOfLogger, forKey: "nameOfLogger")
                        performSegue(withIdentifier: "Waiver", sender: self)

                    }
                    else{
                        notif(title: "Error", message: "An error occured. Please make sure you aren't using these symbols: %, ., #, $, [, ], or '")
                    }
                }
                    
                else{
                    notif(title: "Error", message: "Somebody is already using that name. Please change it or contact AssistantTeamFitChallenge@gmail.com for help.")
                }
            }
            else{
                notif(title: "Error", message: "Please enter a first and a last name.")
            }
            
        }
     
        
        
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func notif(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

