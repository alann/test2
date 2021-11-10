//
//  SettingsViewController.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import UIKit

class SettingsViewController: BaseViewController, SettingsViewModelDelegate {
        
    var settingsViewModel = SettingsViewModel()
    
    @IBOutlet var requiredTextFields: [UITextField]!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var birthplaceTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBOutlet weak var interestTopicsTableView: UITableView!
            
    lazy var imagePickerController = UIImagePickerController()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        
        if #available(iOS 14, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
    @IBAction func changeProfileImage(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { action in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { action in
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func onChangeProfileImage(success: Bool, error: String?) {
        
        DispatchQueue.main.async {
            if success {
                self.presentAlert(title: "Внимание!", message: error!)
            } else {
                self.presentAlert(title: "Внимание!", message: error!) //to do
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        var arrayOfInputs = [String]()

        for textField in requiredTextFields {

            if let text = textField.text, text.isEmpty {

                textField.attributedPlaceholder = NSAttributedString(
                    string: "Заполните поле",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                )
            }
            arrayOfInputs.append(textField.text!)
        }
        
        arrayOfInputs.append(middleNameTextField.text ?? "")
        arrayOfInputs.append(dateOfBirthTextField.text ?? "")
        arrayOfInputs.append(organizationTextField.text ?? "")
        arrayOfInputs.append(positionTextField.text ?? "")

        if let selectedRows = self.interestTopicsTableView.indexPathsForSelectedRows, selectedRows.count > 0 {
            settingsViewModel.updateProfile(inputs: arrayOfInputs)
        } else {
            presentAlert(title: "Внимание", message: "Необходимо выбрать хотя бы одну интересующую тему")
        }
    }
        
    func onUpdateProfile(success: Bool, error: String?) {
        
        DispatchQueue.main.async {
            if success {
                self.presentAlert(title: "Внимание!", message: error!)
            } else {
                self.presentAlert(title: "Внимание!", message: error!) //to do unwrap
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Профиль пользователя"
        
        dateOfBirthTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(donedatePicker(sender:)), for: .valueChanged)

        dateOfBirthTextField.text = datePicker.date.getFormattedDateForUser()
        dateOfBirthTextField.resignFirstResponder()
        
        settingsViewModel.delegate = self
    }
    
    @objc func donedatePicker(sender: UIDatePicker){
        dateOfBirthTextField.text = datePicker.date.getFormattedDateForUser()
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)

        if let pickedImage = info[.originalImage] as? UIImage, let imageData = pickedImage.jpegData(compressionQuality: 0.5) {
            let base64String = imageData.base64EncodedString()
            settingsViewModel.changeProfileImage(base64String: base64String, ext: ".jpeg")
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Constants.topics[indexPath.row].name
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        let selectedRows = tableView.indexPathsForSelectedRows
        settingsViewModel.selectedInterestTopics = selectedRows?.map { Constants.topics[$0.row]} ?? []
        print(settingsViewModel.selectedInterestTopics)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
    }
}
