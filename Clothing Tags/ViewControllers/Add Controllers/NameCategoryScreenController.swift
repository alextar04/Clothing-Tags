//
//  NameCategoryScreenController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 11.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NameCategoryScreenController : UIViewController{
    
    @IBOutlet weak var nameClothes: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var pickerCategoryList: UIPickerView!
    @IBOutlet weak var newCategoryField: UITextField!
    
    @IBOutlet weak var nextScreenButton: UIButton!
    
    var nameScreen : String = ""
    let viewModel = NameCategoryViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadTapRecognizer()
        loadCategoryPartScreen()
        loadNextButtonPart()
    }
    
    
    // MARK: Загрузка части для скрытия клавиатуры
    func loadTapRecognizer(){
        let gestureRecognizerHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.actionForHideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizerHideKeyboard)
    }
    
    // MARK: Загрузка части для категории
    func loadCategoryPartScreen(){
        newCategoryField.isHidden = true
        
        Observable.just(viewModel.category).bind(to: pickerCategoryList.rx.items){row, element, view in
            let label = UILabel()
            label.font = UIFont(name: "a_BosaNova", size: 15)
            label.textAlignment = .center
            label.text = element.name
            return label
        }.disposed(by: disposeBag)
        
        categoryButton.rx.tap.bind{
            self.pickerCategoryList.isHidden = !self.pickerCategoryList.isHidden
        }.disposed(by: disposeBag)
        
        pickerCategoryList.rx.itemSelected.subscribe(onNext: {index in
            self.categoryButton.setTitle(self.viewModel.category[index.row].name, for: .normal)
            self.newCategoryField.isHidden = (self.viewModel.category[index.row].name == "(Прочее)") ? false : true
        }).disposed(by: disposeBag)
        
    }
    
    // ЭТОТ ПОЗОР ПЕРЕПИСАТЬ СО СТРОИТЕЛЕМ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // MARK: Загрузка части для кнопки перехода к дальнейшему окну
    func loadNextButtonPart(){
        nextScreenButton.rx.tap.bind{
            let clothesInstance = ClotheS.getInstance()
            clothesInstance?.name = self.nameClothes.text
            clothesInstance?.category = self.categoryButton.titleLabel?.text == "(Прочее)" ? self.newCategoryField.text : self.categoryButton.titleLabel?.text
            
            
            let chooseTagScreenController = UIStoryboard(name: "TagChooseScreen", bundle: nil).instantiateViewController(withIdentifier: "ChooseTagScreenID") as? TagChooseScreenController
            chooseTagScreenController?.nameScreen = "Выбор значков на бирке"
            
            if let chooseTagScreen = chooseTagScreenController{
                self.navigationController?.pushViewController(chooseTagScreen, animated: true)
            }
        }
    }
    
    @objc func actionForHideKeyboard() {
        self.view.endEditing(true)
    }
    
}
