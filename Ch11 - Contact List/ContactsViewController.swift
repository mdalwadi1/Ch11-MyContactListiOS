//
//  ContactsViewController.swift
//  Ch11 - Contact List
//
//  Created by user216619 on 9/16/22.
//

import UIKit

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {
    
    //variable holds info about Contact entity being edited
    // ? = variable is optional (may not be value associated with it)
    // ^ could also use nil, but it's not a pointer to nonexistent object; it's absence of value (can be used with tuples/struct values)
    var currentContact: Contact?
    //sets up reference to AppDelegate that will be used to access CoreData functionality
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeEditMode(self)
        // Do any additional setup after loading the view.
        
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip,
                                         txtPhone, txtCell, txtEmail]
        for textfield in textFields {
            textfield.addTarget(self,
                                action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        }
    }
    
    func dateChanged(date: Date) {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        //sets the date passed in from calling controller to birthday property in currentContact
        currentContact?.birthday = date
        //sets up date formatter & formats date using short style (MM/DD/YYYY)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        //formatted date is set on label on Contacts screen
        lblBirthdate.text = formatter.string(from: date)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //if no currentContact object, code first uses appDelegate variable to get reference to Managed Object Context (file that stores data)
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.contactName = txtName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipCode = txtZip.text
        currentContact?.cellNumber = txtCell.text
        currentContact?.phoneNumber = txtPhone.text
        currentContact?.email = txtEmail.text
        return true
    }
    
    @objc func saveContact() {
        //saves object to database
        appDelegate.saveContext()
        //change scene from editing to viewing mode
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Disposes of any resources that can be recreated
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtPhone, txtCell, txtEmail]
        
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(self.saveContact))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        //Get existing contentInset for scrollView & set bottom property to be height of keyboard
        //Content Inset = distance of ScrollView's contents from ScrollView's edges
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //first checks to see which segue initiated call to method
        if(segue.identifier == "segueContactDate") {
            //gets reference to destination ViewController (DateViewController)
            let dateController = segue.destination as! DateViewController
            //sets delegate for DateController to be ContactsController (self)
            //DateController can call dateChanged() method in ContactsController
            dateController.delegate = self
        }
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
