//
//  SocialNetwork.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 22.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftSMTP


protocol Dialog {
    func createSocialNetwork()->SocialNetwork
}

extension Dialog{
    // 1 - Кнопка конкретной соцсети
    // 2 - Иконка Диалога
    // 3 - Название Диалога
    // 4 - Кнопка "Опубликовать"
    // 5 - Индикатор статуса публикации
    // 6 - Статус публикации
    func initDialog(socialNetworkButton: UIButton,
                    iconSocialNetworkView: UIImageView,
                    nameSocialNetworkView: UILabel,
                    publishButton: UIButton,
                    wheelSavePublish: UIActivityIndicatorView,
                    statusPublish: UILabel,
                    loginEdit: UITextField,
                    passwordEdit: UITextField,
                    nameClothes: String,
                    descriptionStickers: String,
                    subscription: inout Disposable?){
        let socialNetwork = createSocialNetwork()
        
        socialNetworkButton.imageView?.image = socialNetwork.getLogo().image
        nameSocialNetworkView.text = socialNetwork.getName()
        iconSocialNetworkView.image = socialNetwork.getLogo().image
        
        subscription = publishButton.rx.tap.bind{
            if loginEdit.text == "" || passwordEdit.text == ""{
                statusPublish.text = publishResponse.emptyAutorization.rawValue
                statusPublish.isHidden = false
            }else{
                wheelSavePublish.isHidden = false
                socialNetwork.sendClothesInformationToServer(username: loginEdit.text!, password: passwordEdit.text!, nameClothes: nameClothes, body: descriptionStickers){ status in
                        statusPublish.text = status.rawValue
                        statusPublish.isHidden = false
                        wheelSavePublish.isHidden = true
                    }
            }
        }
    }
}


class VKDialog: Dialog{
    func createSocialNetwork() -> SocialNetwork {
        return VK()
    }
}

class YandexDialog: Dialog{
    func createSocialNetwork() -> SocialNetwork {
        return Yandex()
    }
}

protocol SocialNetwork {
    func getName()->String
    func getLogo()->UIImageView
    func sendClothesInformationToServer(username: String, password: String, nameClothes: String, body: String, callback: @escaping (publishResponse)->Void)->Void
}


class VK: SocialNetwork{
    var name: String
    var logo: UIImageView
    
    init() {
        self.name = "VK"
        self.logo = UIImageView(image: UIImage(named: "vkLogo.png"))
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLogo() -> UIImageView {
        return self.logo
    }
    
    func sendClothesInformationToServer(username: String, password: String, nameClothes: String, body: String, callback: @escaping (publishResponse)->Void)->Void{
        
        // 1. Получение токена для доступа к заметкам
        let vkAppId = "3140623"
        let vkAppSecretKey = "VeWdmVclDCtn6ihuP1nt"
        
        var token: String? = ""
        let getTokenUrl = try! "https://oauth.vk.com/token?grant_type=password&client_id=\(vkAppId)&client_secret=\(vkAppSecretKey)&username=\(username)&password=\(password)".asURL()
        
        AF.request(getTokenUrl, method: .post).responseJSON{responseToken in
            switch responseToken.result{
            case .success(let Json):
                token = (Json as! NSDictionary).object(forKey: "access_token") as? String
                if token == nil{
                    DispatchQueue.main.async {
                        callback(.failrueAutorization)
                    }
                    return
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    callback(.failrueAutorization)
                }
                return
            }
            
            // 2. Публикация заметки в социальной сети
            let publishNoteUrl = "https://api.vk.com/method/notes.add?title=\(nameClothes)&text=\(body)&access_token=\(token!)&v=5.122"
            let encodedPublishNoteUrl = publishNoteUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            AF.request(encodedPublishNoteUrl!, method: .post).responseJSON{ responsePublish in
                switch responsePublish.result{
                case .success(let Json):
                    DispatchQueue.main.async {
                        callback(.successPublish)
                    }
                    return
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        callback(.failruePublish)
                    }
                    return
                }
            }
        }
    }
}


class Yandex: SocialNetwork{
    var name: String
    var logo: UIImageView
    
    init() {
        self.name = "Яндекс. Почта"
        self.logo = UIImageView(image: UIImage(named: "yandexLogo.png"))
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLogo() -> UIImageView {
        return self.logo
    }
    
    func sendClothesInformationToServer(username: String, password: String, nameClothes: String, body: String, callback: @escaping (publishResponse)->Void)->Void{
        
        let sender = Mail.User(email: username)
        let reciever = Mail.User(email: username)
        
        let smtp = SMTP(
            hostname: "smtp.yandex.ru",
            email: username,
            password: password
        )
        
        let letter = Mail(from: sender, to: [reciever], subject: nameClothes, text: body)
        
        smtp.send(letter){ error in
            if let error = error{
                DispatchQueue.main.async {
                    callback(.failrueAutorization)
                }
                return
            }
            DispatchQueue.main.async {
                callback(.successPublish)
            }
            return
        }
    }
}

enum publishResponse: String{
    case successAutorization = "Успешная авторизация!"
    case failrueAutorization = "Ошибка авторизации!"
    case emptyAutorization = "Поля логина или пароля пусты!"
    case successPublish = "Успешная публикация!"
    case failruePublish = "Ошибка публикации!"
}

