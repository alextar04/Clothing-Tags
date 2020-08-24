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


protocol Dialog {
    func createSocialNetwork()->SocialNetwork
}

extension Dialog{
    // 1 - Кнопка соцсети
    // 2 - Иконка Диалога
    // 3 - Название Диалога
    // 4 - Кнопка "Опубликовать"
    func initDialog(socialNetworkButton: UIButton,
                    iconSocialNetworkView: UIImageView,
                    nameSocialNetworkView: UILabel,
                    publishButton: UIButton,
                    subscription: inout Disposable?){
        let socialNetwork = createSocialNetwork()
        
        socialNetworkButton.imageView?.image = socialNetwork.getLogo().image
        nameSocialNetworkView.text = socialNetwork.getName()
        iconSocialNetworkView.image = socialNetwork.getLogo().image
        
        subscription = publishButton.rx.tap.bind{
            socialNetwork.sendClothesInformationToServer()
        }
        //.disposed(by: disposeBagSended)
    }
}


class FacebookDialog: Dialog{
    func createSocialNetwork() -> SocialNetwork {
        return Facebook()
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
    func sendClothesInformationToServer()->publishResponse
}

class Facebook: SocialNetwork{
    var name: String
    var logo: UIImageView
    
    init() {
        self.name = "Facebook"
        self.logo = UIImageView(image: UIImage(named: "facebookLogo.png"))
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLogo() -> UIImageView {
        return self.logo
    }
    
    func sendClothesInformationToServer()->publishResponse{
        print("Послали от FB")
        return publishResponse.successPublish
    }
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
    
    func sendClothesInformationToServer()->publishResponse{
        print("Послали от VK")
        return publishResponse.successPublish
    }
}


class Yandex: SocialNetwork{
    var name: String
    var logo: UIImageView
    
    init() {
        self.name = "Яндекс"
        self.logo = UIImageView(image: UIImage(named: "yandexLogo.png"))
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLogo() -> UIImageView {
        return self.logo
    }
    
    func sendClothesInformationToServer()->publishResponse{
        print("Послали от YA")
        return publishResponse.successPublish
    }
}

enum publishResponse: String{
    case successAutorization = "Успешная авторизация!"
    case failrueAutorization = "Ошибка авторизации!"
    case emptyAutorization = "Заполните поля логина и пароля!"
    case successPublish = "Успешная публикация в заметках!"
    case failruePublish = "Ошибка! Публикация не была добавлена"
}

