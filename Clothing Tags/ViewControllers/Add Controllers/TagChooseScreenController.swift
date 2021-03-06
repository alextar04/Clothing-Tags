//
//  TagChooseListController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 13.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

import RxDataSources
import Differentiator

class TagChooseScreenController: UIViewController{
    @IBOutlet weak var nextScreenButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nameScreen : String = ""
    var constructedClothes: Clothes? = nil
    var viewModel = TagChooseScreenViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen,
                                         viewController: nil)
        loadTableOfStickers()
        actionSelectingOfSticker()
        actionNextScreen()
        
    }
    
    // Вспомогательная структура для отображения стикеров с заголовками секций
    struct SectionOfImageStickerData{
        var header: String
        var items: [Sticker]
    }
    
    // MARK: Загрузка таблицы значков на бирках
    func loadTableOfStickers(){
        let recievedStickers = viewModel.stickers
        var stickersSectionalData = [SectionOfImageStickerData]()
        recievedStickers.map{ groupSticker in
            var groupForPaste = [Sticker]()
            var headerForPaste = groupSticker[0].category
            
            // Итерация по словарю группы
            groupSticker.map{
                groupForPaste.append($0)
            }
            
            let groupSection = SectionOfImageStickerData(header: headerForPaste!, items: groupForPaste)
            stickersSectionalData.append(groupSection)
        }
        
        
        // Конфигурация содержимого для ячеек таблицы
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfImageStickerData>(configureCell: {
            dataSource, collection, index, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "ScreenChooseTagCell", for: index) as! ScreenChooseTagCell
            cell.imageSticker.image = UIImage(data: item.image!)
            
            let searchedIndex = self.viewModel.listSelectedStickers.index(of: item)
            if searchedIndex == nil{
                cell.selectedBorder.isHidden = true
            }else{
                cell.selectedBorder.isHidden = false
            }
            
            return cell
            }
        )
        
        // Конфигурация названия секций для таблицы
        dataSource.configureSupplementaryView = {
            dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionID", for: indexPath) as? HeaderStickersCollection
            header?.nameSection.text = stickersSectionalData[indexPath.section].header
            return header!
        }
        
        
        Observable.just(stickersSectionalData).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    
    // MARK: Действия для выбора/отмены значка для бирки
    func actionSelectingOfSticker(){
        // Выбор значка
        self.collectionView.rx.itemSelected.subscribe(
        onNext: {selectedIndex in
            let cell = self.collectionView.cellForItem(at: selectedIndex) as! ScreenChooseTagCell
            // Отмена выделения двойным тапом
            if let existingIndex = self.viewModel.listSelectedIndexStickers.firstIndex(of: selectedIndex){
                print(cell.selectedBorder.isHidden)
                cell.selectedBorder.isHidden = true
                self.viewModel.listSelectedIndexStickers.remove(at: existingIndex)
            } else {
                // Выделение новой ячейки
                self.viewModel.listSelectedIndexStickers.append(selectedIndex)
                cell.selectedBorder.isHidden = false
            }
        }).disposed(by: self.disposeBag)
        
        // Добавление выбраных значков в список
        self.collectionView.rx.modelSelected(Sticker.self).subscribe(
            onNext: { item in
                let searchedIndex = self.viewModel.listSelectedStickers.index(of: item)
                if searchedIndex == nil{
                    self.viewModel.listSelectedStickers.append(item)
                }else{
                    self.viewModel.listSelectedStickers.remove(at: searchedIndex!)
                }
            }
        ).disposed(by: disposeBag)
    }
    
    func actionNextScreen(){
        nextScreenButton.rx.tap.bind{
            // Загрузим страницу одежды
            let clothesScreenViewController = UIStoryboard(name: "ClothesScreen", bundle: nil).instantiateViewController(withIdentifier: "ClothesScreenID") as? ClothesScreenViewController
            
            // Обновление БД
            self.constructedClothes = self.viewModel.addIdsStickersToClothes(clothes: self.constructedClothes!)
            self.viewModel.addOtherParametrsAndSave(clothes: self.constructedClothes!)
            
            // Конструирование экрана одежды
            clothesScreenViewController?.openFromCreationClothesScreen = true
            clothesScreenViewController?.idClothes = Int(self.constructedClothes!.id)
            clothesScreenViewController?.nameScreen = self.constructedClothes?.name
            
            if let clothesScreen = clothesScreenViewController{
                self.navigationController?.viewControllers = []
                AppDelegate.appDelegateLink.rootViewController.switchToClothesScreenFromAdding(controller: clothesScreen)
            }
        }.disposed(by: disposeBag)
    }
}

extension TagChooseScreenController.SectionOfImageStickerData: SectionModelType{
    init(original: TagChooseScreenController.SectionOfImageStickerData, items: [Sticker]) {
        self = original
        self.items = items
    }
}
