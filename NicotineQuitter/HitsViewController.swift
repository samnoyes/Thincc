//
//  HitsViewController.swift
//  NicotineQuitter
//
//  Created by PetersYuki on 1/3/19.
//  Copyright © 2019 PetersYuki. All rights reserved.
//

import UIKit
import CoreData

class HitsViewController: UIViewController {
    
    var isNew = false
    
    var startYear = 0
    var startMonth = 0
    var startDay = 0
    
    var currentYear = 0
    var currentMonth = 0
    var currentDay = 0
    
    // set back to 1
    var dayOfProgram = 1
    // day of program last time user logged in
    var lastDayOfProgram = 1
    
    // we're only going to store startTime. startTime is a var because we reassign it in getData()
    var startTime = Date().description
    
    let currentTime = Date().description
    
    // this should be set to daysPerPod from the SetUpViewController in the segue
    var daysPerPod = 1
    let hitsPerPod = 200
    lazy var hitsLeft = hitsPerPod / daysPerPod
    
    @IBOutlet weak var hitsLeftLabel: UILabel!
    @IBOutlet weak var dayOfProgramLabel: UILabel!
    @IBOutlet weak var congratsLabel: UILabel!
    
    override func viewDidLoad() {
        // if this is a continuation
        if isNew == false {
            print("Is not NEW")
            getData()
            parseCurrentTime(date: currentTime)
            
            getDayOfProgram(startYearLocal: startYear, startMonthLocal: startMonth, startDayLocal: startDay, currentYearLocal: currentYear, currentMonthLocal: currentMonth, currentDayLocal: currentDay)
            
            // if the last time user used app was yesterday
            if dayOfProgram != lastDayOfProgram {
                // if last day user used program was within 7-day window
                if lastDayOfProgram <= 7 {
                    hitsLeft = (hitsPerPod / daysPerPod) - ((dayOfProgram - 1) * ((hitsPerPod / daysPerPod) / 7))
                }
                    // show "Congratulations for completing the program!" if user hits continue even though they're done
                else {
                    congratsLabel.isHidden = false
                }
            }
            
        }
        // if this is new (just clicked begin program)
        else {
            hitsLeft = hitsPerPod / daysPerPod
            startTime = Date().description
            print("Is new")
            parseStartDate(date: startTime)
        }
        
        // if the user is done with the 7-day program
        if dayOfProgram > 7 {
            hitsLeft = 0
            dayOfProgramLabel.text = "DONE"
            congratsLabel.isHidden = false
        }
        
        hitsLeftLabel.text = String(hitsLeft)
        dayOfProgramLabel.text = String(dayOfProgram)
        print("Start year is \(startYear)")
        print("Current year is \(currentYear)")

        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func parseStartDate(date: String) {
        let space = date.split(separator: " ")
        let dash = space[0].split(separator: "-")
        
        if let startYearLocal = Int(dash[0]), let startMonthLocal = Int(dash[1]), let startDayLocal = Int(dash[2])  {
            
            startYear = startYearLocal
            startMonth = startMonthLocal
            startDay = startDayLocal
            
            print("Start year, month, and day saved!")
            print("Start year is: \(startYear), start month is \(startMonth), start day is \(startDay)")
        }
        else {
            print("Start year does not exist")
        }
        
    }

    func parseCurrentTime(date: String) {
        let space = date.split(separator: " ")
        let dash = space[0].split(separator: "-")
        
        if let currentYearLocal = Int(dash[0]), let currentMonthLocal = Int(dash[1]), let currentDayLocal = Int(dash[2])  {
            
            currentYear = currentYearLocal
            currentMonth = currentMonthLocal
            currentDay = currentDayLocal
            
            print("Start year, month, and day saved!")
            print("Current year is: \(currentYear), current month is \(currentMonth), current day is \(currentDay)")
        }
        else {
            print("Start year does not exist")
        }
        
    }
    
    func getDayOfProgram(startYearLocal: Int, startMonthLocal: Int, startDayLocal: Int, currentYearLocal: Int, currentMonthLocal: Int, currentDayLocal: Int) {
        
        if (startYearLocal == currentYearLocal) {
            dayOfProgram = (currentDayLocal - startDayLocal) + 1
        }
        else {
            if (startMonthLocal == 12 && currentMonthLocal == 1) {
                dayOfProgram = (31 - startDayLocal) + currentDayLocal + 1
            }
            else {
                // in the case user hasn't been on a for a while
                dayOfProgram = 999
            }
        }
    }
    
    @IBAction func finishSession(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(hitsLeft, forKey: "hitsLeft")
        newEntity.setValue(daysPerPod, forKey: "daysPerPod")
        newEntity.setValue(startYear, forKey: "startYear")
        newEntity.setValue(startMonth, forKey: "startMonth")
        newEntity.setValue(startDay, forKey: "startDay")
        newEntity.setValue(dayOfProgram, forKey: "dayOfProgram")


        
        do {
            try context.save()
            print("saved")
        }
        catch {
            print("failed to save")
        }
        performSegue(withIdentifier: "hitsToMain", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! ViewController
//        vc.hasPrevious = true
//    }
    
    @IBAction func tookHit(_ sender: Any) {
        if hitsLeft > 0 {
            hitsLeft -= 1
            hitsLeftLabel.text = String(hitsLeft)
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                hitsLeft = data.value(forKey: "hitsLeft") as! Int
                daysPerPod = data.value(forKey: "daysPerPod") as! Int
                startYear = data.value(forKey: "startYear") as! Int
                startMonth = data.value(forKey: "startMonth") as! Int
                startDay = data.value(forKey: "startDay") as! Int
                lastDayOfProgram = data.value(forKey: "dayOfProgram") as! Int

            }
        }
        catch {
            print("Failed")
        }
    }
}
