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
        
        let viewModelData = ["Калготки", "Трусы", "Носки", "(Прочее)"]
        let viewModelDataObservable = Observable.just(viewModelData)
        viewModelDataObservable.bind(to: pickerCategoryList.rx.items){row, element, view in
            let label = UILabel()
            label.font = UIFont(name: "a_BosaNova", size: 15)
            label.textAlignment = .center
            label.text = element
            return label
        }.disposed(by: disposeBag)
        
        categoryButton.rx.tap.bind{
            self.pickerCategoryList.isHidden = !self.pickerCategoryList.isHidden
        }.disposed(by: disposeBag)
        
        pickerCategoryList.rx.itemSelected.subscribe(onNext: {index in
            self.categoryButton.setTitle(viewModelData[index.row], for: .normal)
            self.newCategoryField.isHidden = (viewModelData[index.row] == "(Прочее)") ? false : true
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
