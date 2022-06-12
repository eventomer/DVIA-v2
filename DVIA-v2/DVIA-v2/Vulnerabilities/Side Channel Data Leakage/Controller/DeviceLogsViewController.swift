//
//  DeviceLogsViewController.swift
//  DVIA - Damn Vulnerable iOS App (damnvulnerableiosapp.com)
//  Created by Prateek Gianchandani on 16/12/17.
//  Copyright © 2018 HighAltitudeHacks. All rights reserved.
//  You are free to use this app for commercial or non-commercial purposes
//  You are also allowed to use this in trainings
//  However, if you benefit from this project and want to make a contribution, please consider making a donation to The Juniper Fund (www.thejuniperfund.org/)
//  The Juniper fund is focusing on Nepali workers involved with climbing and expedition support in the high mountains of Nepal. When a high altitude worker has an accident (death or debilitating injury), the impact to the family is huge. The juniper fund provides funds to the affected families and help them set up a sustainable business.
//  For more information,  visit www.thejuniperfund.org
//  Or watch this video https://www.youtube.com/watch?v=HsV6jaA5J2I
//  And this https://www.youtube.com/watch?v=6dHXcoF590E
 


import UIKit
import os.log

struct LoginUserInput: Codable {
    let name: String?
    let password: String?
    let phone: String?
    let email: String?
}

class DeviceLogsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneNoTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Device Logs"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if nameTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true || phoneNoTextField.text?.isEmpty ?? true || emailTextField.text?.isEmpty ?? true {
            DVIAUtilities.showAlert(title: "Error", message: "One or more input fields is empty.", viewController: self)
            return
        }
        signUpButton.setTitle("Signing Up ...", for: .normal)
        let user = LoginUserInput(
            name: nameTextField.text,
            password: passwordTextField.text,
            phone: phoneNoTextField.text,
            email: emailTextField.text
        )
        DVIAUtilities.showAlert(title: "Success", message: "User signed up successfully, look for the logs now", viewController: self)
        if let jsonData = try? JSONEncoder().encode(user), let jsonString = String(data: jsonData, encoding: .utf8) {
            logger.log("Saved user info: \(jsonString)")
        }
        self.signUpButton.setTitle("Sign Up", for: .normal)
    }
}
