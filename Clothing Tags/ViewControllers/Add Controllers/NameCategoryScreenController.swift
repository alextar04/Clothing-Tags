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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadTapRecognizer()
        loadNamePartScreen()
        loadCategoryPartScreen()
        loadNextButtonPart()
    }
    
    
    
    func loadTapRecognizer(){
        let gestureRecognizerHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.actionForHideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizerHideKeyboard)
    }
    
    // MARK: Загрузка части для названия одежды
    func loadNamePartScreen(){
        
    }
    
    // MARK: Загрузка части для категории
    func loadCategoryPartScreen(){
        newCategoryField.isHidden = true
        
        
        let viewModelData = Observable.just(["(ПУСТО)", "Калготки", "Трусы", "Носки", "(Прочее)"])
        viewModelData.bind(to: pickerCategoryList.rx.itemTitles){row, element in
            return element
        }.disposed(by: disposeBag)
        
        categoryButton.rx.tap.bind{
            self.pickerCategoryList.isHidden = !self.pickerCategoryList.isHidden
        }
        
        pickerCategoryList.rx.itemSelected.subscribe(onNext: {index, value in
            self.categoryButton.titleLabel?.text = String(index)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Загрузка части для кнопки перехода к дальнейшему окну
    func loadNextButtonPart(){
        let clothesInstance = Clothes.getInstance()
        clothesInstance?.name = nameClothes.text
        
        
        nextScreenButton.rx.tap.bind{
            print("Загрузить новое окно!")
        }
    }
    
    @objc func actionForHideKeyboard() {
        self.view.endEditing(true)
    }
    
}
