//
//  AuthViewModel.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import Foundation

class AuthViewModel {
    
    weak var delegate: AuthViewModelDelegate?
    
    init() {
    }
    
    func isValidInputs(inputs: [String]) -> String? {
        
        var warningMessage: String? = ""
        
        if !isValidEmail(inputs[0]) {
            warningMessage! += "* email введен не верно"
        }
        
        return warningMessage
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func checkLogin(inputs: [String]) {
                
        guard let url = URL(string: Constants.urlStringForCheckLogin) else {
            self.delegate?.onAuth(success: false, error: "Невозможно создать URL")
            return
        }
        
//        let input = AuthInput(email: "dd.dd@dd.dd",
//                              password: "123")
        
        let input = AuthInput(email: inputs[0],
                              password: inputs[1])
        
        guard let jsonData = try? JSONEncoder().encode(input) else {
            self.delegate?.onAuth(success: false, error: "Невозможно преобразовать модель в данные JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.delegate?.onAuth(success: false, error: "Ошибка при вызове POST")
                return
            }
            guard let data = data else {
                self.delegate?.onAuth(success: false, error: "Не получили данные")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                self.delegate?.onAuth(success: false, error: "HTTP-запрос не выполнен")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.delegate?.onAuth(success: false, error: "Невозможно преобразовать данные в объект JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    self.delegate?.onAuth(success: false, error: "Невозможно преобразовать объект JSON в данные Pretty JSON")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    self.delegate?.onAuth(success: false, error: "Не удалось вывести JSON в String")
                    return
                }
                
                self.delegate?.onAuth(success: true, error: nil)
                print(prettyPrintedJson)
            
            } catch {
                self.delegate?.onAuth(success: false, error: "Невозможно преобразовать данные JSON в String")
                return
            }
        }.resume()
    }
}

protocol AuthViewModelDelegate: AnyObject {
    
    func onAuth(success: Bool, error: String?)
}
