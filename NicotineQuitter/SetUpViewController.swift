//
//  SetUpViewController.swift
//  NicotineQuitter
//
//  Created by PetersYuki on 1/3/19.
//  Copyright © 2019 PetersYuki. All rights reserved.
//

import UIKit

class SetUpViewController: UIViewController {
    
    let dataSource = ["1 day", "2 days", "3 days", "4 days", "5 days", "6 days", "7 days"]

    var daysPerPodString = "1 day"
    var daysPerPod = 1
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        if daysPerPodString == "1 day" {
            daysPerPod = 1
        }
        else if daysPerPodString == "2 days" {
            daysPerPod = 2
        }
        else if daysPerPodString == "3 days" {
            daysPerPod = 3
        }
        else if daysPerPodString == "4 days" {
            daysPerPod = 4
        }
        else if daysPerPodString == "5 days" {
            daysPerPod = 5
        }
        else if daysPerPodString == "6 days" {
            daysPerPod = 6
        }
        else {
            daysPerPod = 7
        }
        
        performSegue(withIdentifier: "SetUpToHits", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HitsViewController
        vc.daysPerPod = self.daysPerPod
        vc.isNew = true
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        daysPerPodString = dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
}

