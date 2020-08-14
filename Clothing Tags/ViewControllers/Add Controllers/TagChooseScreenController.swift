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
    var listSelectedIndexStickers = [IndexPath]()
    var listSelectedStickers = [TagData]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadTableOfStickers()
        actionSelectingOfSticker()
        actionNextScreen()
        
    }
    
    // CORE DATA
    struct SectionOfImageStickerData{
        var header: String
        var items: [TagData]
    }
    
    
    // MARK: Загрузка таблицы значков на бирках
    func loadTableOfStickers(){
        var listRecievedStickers = [TagData]()
        for i in 0...23{
            listRecievedStickers.append(TagData(String(i), UIImage(named: "add.png")!))
        }
        let stickersData = [SectionOfImageStickerData(header: "First", items: Array(listRecievedStickers[0...5])),
                            SectionOfImageStickerData(header: "Second", items: Array(listRecievedStickers[6...11])),
                            SectionOfImageStickerData(header: "Third", items: Array(listRecievedStickers[12...17])),
                            SectionOfImageStickerData(header: "Fourth", items: Array(listRecievedStickers[18...23]))
        ]
        
        
        // Конфигурация содержимого для ячеек таблицы
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfImageStickerData>(configureCell: {
            dataSource, collection, index, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "ScreenChooseTagCell", for: index) as! ScreenChooseTagCell
            cell.imageSticker.image = item.pictureTag
            cell.selectedBorder.isHidden = true
            return cell
            }
        )
        
        // Конфигурация названия секций для таблицы
        dataSource.configureSupplementaryView = {
            dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionID", for: indexPath) as? HeaderStickersCollection
            header?.nameSection.text = stickersData[indexPath.section].header
            return header!
        }
        
        
        Observable.just(stickersData).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    
    // MARK: Действия для выбора/отмены значка для бирки
    func actionSelectingOfSticker(){
        // Выбор значка
        self.collectionView.rx.itemSelected.subscribe(
        onNext: {selectedIndex in
            let cell = self.collectionView.cellForItem(at: selectedIndex) as! ScreenChooseTagCell
            // Отмена выделения двойным тапом
            if let existingIndex = self.listSelectedIndexStickers.firstIndex(of: selectedIndex){
                cell.selectedBorder.isHidden = true
                self.listSelectedIndexStickers.remove(at: existingIndex)
            } else {
                // Выделение новой ячейки
                self.listSelectedIndexStickers.append(selectedIndex)
                cell.selectedBorder.isHidden = false
            }
        }).disposed(by: self.disposeBag)
        
        // Добавление выбраных значков в список
        self.collectionView.rx.modelSelected(TagData.self).subscribe(
            onNext: { item in
                let searchedIndex = self.listSelectedStickers.index(of: item)
                if searchedIndex == nil{
                    self.listSelectedStickers.append(item)
                }else{
                    self.listSelectedStickers.remove(at: searchedIndex!)
                }
            }
        ).disposed(by: disposeBag)
    }
    
    
    
    func actionNextScreen(){
        nextScreenButton.rx.tap.bind{
            // Загрузим страницу одежды
            let clothesScreenViewController = UIStoryboard(name: "ClothesScreen", bundle: nil).instantiateViewController(withIdentifier: "ClothesScreenID") as? ClothesScreenViewController
            
            // CORE DATA
            let clothesLink = Clothes.getInstance()
            clothesLink!.tagCollection = self.listSelectedStickers
            
            // Установка значений в контроллер с одеждой
            clothesScreenViewController?.photoClothesData = clothesLink?.photoClothes
            clothesScreenViewController?.photoTagData = clothesLink?.photoTag
            let nameLabel = UILabel()
            nameLabel.text = clothesLink?.name
            clothesScreenViewController?.nameClothesData = nameLabel
            clothesScreenViewController?.recievedData = (clothesLink?.tagCollection)!
            // Обновление БД
            
            
            // Сделать страницу одежды корневой
            if let clothesScreen = clothesScreenViewController{
                self.navigationController?.pushViewController(clothesScreen, animated: true)
            }
           
           // Отчистим стек предыдущих экранов
            //self.navigationController?.popToRootViewController(animated: false)
        }.disposed(by: disposeBag)
    }
}

extension TagChooseScreenController.SectionOfImageStickerData: SectionModelType{
    init(original: TagChooseScreenController.SectionOfImageStickerData, items: [TagData]) {
        self = original
        self.items = items
    }
}
