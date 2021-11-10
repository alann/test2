//
//  AuthViewController.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import UIKit

class AuthViewController: BaseViewController, AuthViewModelDelegate {
    
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet var textFieldsCollection: [UITextField]!
    
    var authViewModel = AuthViewModel()
    
    @IBAction func authButtonPressed(_ sender: Any) {
        
        var arrayOfInputs = [String]()

        for textField in textFieldsCollection {

            if let text = textField.text, text.isEmpty {

                textField.attributedPlaceholder = NSAttributedString(
                    string: "Заполните поле",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            }
            arrayOfInputs.append(textField.text!)
        }

        if let error = authViewModel.isValidInputs(inputs: arrayOfInputs), error != "" {

            self.presentAlert(title: "Проверьте правильность ввода", message: error)
        } else {
            
            authViewModel.checkLogin(inputs: arrayOfInputs)
        }
    }
    
    func onAuth(success: Bool, error: String?) {
        
        DispatchQueue.main.async {
            if success {
                let settingsViewController = SettingsViewController.instantiate(fromAppStoryboard: .Settings)
                settingsViewController.settingsViewModel = SettingsViewModel()
                self.navigationController?.pushViewController(settingsViewController, animated: true)
            } else {
                self.presentAlert(title: "Внимание!", message: error!) //to do
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Экран авторизации"
        
        authViewModel.delegate = self
    }
}

