//
//  StandingsView.swift
//  Workout
//
//  Created by Charles on 3/7/18.
//  Copyright © 2018 charles. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase



var previousAthletes = [String:[AnyObject]]()


class StandingsView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    var athletesNameBest = [String]()
    @IBOutlet weak var tableNotView: UITableView!
    var athletes = [String:[AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        Database.database().reference().queryOrderedByKey().observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
                self.athletes = snapshot.value as! [String:[AnyObject]]
                let athletes2 = self.athletes.sorted(by: {Int("\($0.value[3])")! > Int("\($1.value[3])")!})
                
                
                for val in athletes2{
                    self.athletesNameBest.append("\(val.value[0])_\(val.value[1])")
                    
                }
                self.tableNotView.reloadData()
                
            }
            
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDef")
        if indexPath.row == 0{
            (cell?.viewWithTag(1) as! UILabel).text = "Rank"
            (cell?.viewWithTag(2) as! UILabel).text = "Name"
            (cell?.viewWithTag(3) as! UILabel).text = "Points"
        }
        else{
            (cell?.viewWithTag(1) as! UILabel).text = "#\(indexPath.row)"
            (cell?.viewWithTag(2) as! UILabel).text = "\(athletes[athletesNameBest[indexPath.row - 1]]![0]) \(athletes[athletesNameBest[indexPath.row - 1]]![1])"
            (cell?.viewWithTag(3) as! UILabel).text = "\(athletes[athletesNameBest[indexPath.row - 1]]![3])"
            
            if "\(athletes[athletesNameBest[indexPath.row - 1]]![0]) \(athletes[athletesNameBest[indexPath.row - 1]]![1])" == nameOfLogger {
                print(indexPath.row)
                cell?.backgroundColor = UIColor.init(red: 1.0, green: 90/255, blue: 90/255, alpha: 1.0)
            }
            else{
                cell?.backgroundColor = UIColor.white

            }
            
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        


        
        return cell!
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletes.count + 1
        
    }
    
    
    
    
    
}


extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
