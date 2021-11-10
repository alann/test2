//
//  SettingsViewModel.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import Foundation

class SettingsViewModel {
    
    weak var delegate: SettingsViewModelDelegate?

    var selectedInterestTopics: [InterestTopic] = []
    
    init() {
        
    }
    
    func changeProfileImage(base64String: String, ext: String) {
        
        guard let url = URL(string: Constants.urlStringForUploadAvatar) else {
            self.delegate?.onChangeProfileImage(success: false, error: "Невозможно создать URL")
            return
        }
        
        let input = SetAvatarInput(base64: base64String, ext: ext)
        
        guard let jsonData = try? JSONEncoder().encode(input) else {
            self.delegate?.onChangeProfileImage(success: false, error: "Невозможно преобразовать модель в данные JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.delegate?.onChangeProfileImage(success: false, error: "Ошибка при вызове POST")
                return
            }
            guard let data = data else {
                self.delegate?.onChangeProfileImage(success: false, error: "Не получили данные")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                self.delegate?.onChangeProfileImage(success: false, error: "HTTP-запрос не выполнен")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.delegate?.onChangeProfileImage(success: false, error: "Невозможно преобразовать данные в объект JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    self.delegate?.onChangeProfileImage(success: false, error: "Невозможно преобразовать объект JSON в данные Pretty JSON")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    self.delegate?.onChangeProfileImage(success: false, error: "Не удалось вывести JSON в String")
                    return
                }
                
                self.delegate?.onChangeProfileImage(success: true, error: "Загрузка фото профиля прошла успешно")

                print(prettyPrintedJson)

            } catch {
                self.delegate?.onChangeProfileImage(success: false, error: "Невозможно преобразовать данные JSON в String")
                return
            }
        }.resume()
    }
    
    func updateProfile(inputs: [String]) {
        
        guard let url = URL(string: Constants.urlStringForUpdateProfile) else {
            self.delegate?.onUpdateProfile(success: false, error: "Невозможно создать URL")
            return
        }
        
        if (inputs[0].count == 0) || (inputs[1].count == 0) || (inputs[2].count == 0) {
            self.delegate?.onUpdateProfile(success: false, error: "Заполните обязательные поля")
        }
        
        let input = ProfileInput(lastName: inputs[0],
                                 firstName: inputs[1],
                                 middleName: inputs[3],
                                 birthplace: inputs[2],
                                 dateOfBirth: inputs[4],
                                 organization: inputs[5],
                                 position: inputs[6],
                                 topics: selectedInterestTopics)
        
        guard let jsonData = try? JSONEncoder().encode(input) else {
            self.delegate?.onUpdateProfile(success: false, error: "Невозможно преобразовать модель в данные JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                self.delegate?.onUpdateProfile(success: false, error: "Ошибка при вызове POST")
                return
            }
            guard let data = data else {
                self.delegate?.onUpdateProfile(success: false, error: "Не получили данные")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                self.delegate?.onUpdateProfile(success: false, error: "HTTP-запрос не выполнен")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.delegate?.onUpdateProfile(success: false, error: "Невозможно преобразовать данные в объект JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    self.delegate?.onUpdateProfile(success: false, error: "Невозможно преобразовать объект JSON в данные Pretty JSON")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    self.delegate?.onUpdateProfile(success: false, error: "Не удалось вывести JSON в String")
                    return
                }
                
                print(prettyPrintedJson)
                
                self.delegate?.onUpdateProfile(success: true, error: "Профиль успешно обновлен")
            } catch {
                self.delegate?.onUpdateProfile(success: false, error: "Невозможно преобразовать данные JSON в String")
                return
            }
        }.resume()
    }
}

protocol SettingsViewModelDelegate: AnyObject {
    
    func onChangeProfileImage(success: Bool, error: String?)

    func onUpdateProfile(success: Bool, error: String?)
}

