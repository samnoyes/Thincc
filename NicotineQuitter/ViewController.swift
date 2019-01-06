//
//  ViewController.swift
//  NicotineQuitter
//
//  Created by PetersYuki on 1/3/19.
//  Copyright © 2019 PetersYuki. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var hasPrevious = false
    var canContinue = false

    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
    }
    
    @IBAction func startProgram(_ sender: Any) {
        performSegue(withIdentifier: "mainToSetUp", sender: self)
    }
    
    @IBAction func continueProgram(_ sender: Any) {
        performSegue(withIdentifier: "mainToHits", sender: self)
    }
    
    
    
    @IBAction func saveData(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity1", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)

        newEntity.setValue(hasPrevious, forKey: "hasPrevious")

        do {
            try context.save()
            print("saved")
        }
        catch {
            print("failed to save")
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                hasPrevious = data.value(forKey: "hasPrevious") as! Bool
            }
        }
        catch {
            print("Failed")
        }
    }
    
}

