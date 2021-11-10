//
//  RegistrationViewController.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import UIKit

class RegistrationViewController: BaseViewController, RegistrationViewModelDelegate {
        
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var textFieldsCollection: [UITextField]!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var registrationViewModel = RegistrationViewModel()
        
    @IBAction func showHidePassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func showHideConfirmPassword(_ sender: Any) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        
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

        if let error = registrationViewModel.isValidInputs(inputs: arrayOfInputs), error != "" {

            self.presentAlert(title: "Проверьте правильность ввода", message: error)
        } else {
            
            registrationViewModel.registerUser(inputs: arrayOfInputs)
            
        }
    }
    
    func onRegister(success: Bool, error: String?) {
        
        DispatchQueue.main.async {
            
            if success {
                
                let authViewController = AuthViewController.instantiate(fromAppStoryboard: .Auth)
                authViewController.authViewModel = AuthViewModel()
                self.navigationController?.pushViewController(authViewController, animated: true)
            } else {
                
                self.presentAlert(title: "Внимание!", message: error!) //to do
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
