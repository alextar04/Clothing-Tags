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

class TagChooseScreenController: UIViewController{
    @IBOutlet weak var nextScreenButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nameScreen : String = ""
    var listSelectedIndexStickers = [IndexPath]()
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
    
    struct ImageStickerData {
        var image : UIImage
    }
    
    struct SectionOfImageStickerData : SectionModelType{
        
        typealias Item = TagChooseScreenController.ImageStickerData
        var items: [Item]
        
        init(original: Self, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    
    // MARK: Загрузка таблицы значков на бирках
    func loadTableOfStickers(){
        let sections = [SectionOfImageStickerData(header: "First", items: [ImageStickerData(image: UIImage(named: "tags.png")!)]),
                        SectionOfImageStickerData(header: "Second", items: [ImageStickerData(image: UIImage(named: "tags.png")!)])]
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfImageStickerData>(configureCell: {
            dataSource, collection, index, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "ScreenChooseTagCell", for: index) as! ScreenChooseTagCell
            cell.imageSticker.image = item.image
            cell.selectedBorder.isHidden = true
            return cell
        })
        dataSource.titleForHeaderInSection
        
        Observable.just(sections).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        /* let observableData = Observable.just([SectionModel(model: "title", items: [1,2,3])])
        observableData.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        */
        
        /*Observable.just(viewModelData).bind(to: self.collectionView.rx.items){
                collection, row, item in
                let cell = collection.dequeueReusableCell(withReuseIdentifier: "ScreenChooseTagCell", for: IndexPath.init(row: row, section: 0)) as! ScreenChooseTagCell
            
                    cell.imageSticker.image = item.image
                    cell.selectedBorder.isHidden = true
                
                    return cell
        }.disposed(by: self.disposeBag)*/
        
    }
    
    
    // MARK: Действия для выбора/отмены значка для бирки
    func actionSelectingOfSticker(){
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
    }
    
    func actionNextScreen(){
        nextScreenButton.rx.tap.bind{
            // Загрузим страницу одежды
            // Отчистим стек предыдущих экранов
        }.disposed(by: disposeBag)
    }
}

/*
extension TagChooseScreenController.SectionOfImageStickerData{
    init() {}
    
    init(header: String, items: [TagChooseScreenController.ImageStickerData]) {
        self.init(original: TagChooseScreenController.SectionOfImageStickerData(), items: items)
        self.header = header
    }
}*/
