//
//  SettingsViewController.swift
//  Ch11 - Contact List
//
//  Created by user216619 on 9/16/22.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
        
    //array of items that will show up in Picker View
    //needs to declared at class level because will be accessed in several methods in class
    let sortOrderItems: Array<String> = ["ContactName", "City", "Birthday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set up SettingsViewController as data source for Picker View
        pckSortField.dataSource = self;
        //set View Controller as delegate for Picker View
        //when actions are taken on Picker View, specific methods called in View Controller --> View Controller conforms to UIPickerViewDelegate
        pckSortField.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the UI based on values in UserDefaults
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
        
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        //Forces synchronization saving
        settings.synchronize()
    }

    // MARK: UIPickerViewDelegate Methods
        
    // Returns # of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    // Returns # of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
        
    //Sets the value that is shown for each row in the picker
    //most crucial method for setting up PickerView bc makes data show up
    //system will make repeated calls to this method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
            -> String? {
                return sortOrderItems[row]
    }
        
    //If the user chooses from the pickerview, it calls this function;
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
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
