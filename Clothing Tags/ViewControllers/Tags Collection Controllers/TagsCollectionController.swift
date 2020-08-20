//
//  TagsCollectionController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TagsCollectionController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tagTable: UITableView!
    
    var nameScreen: String = ""
    let viewModel = TagsCollectionViewModel()
    var disposeBag = DisposeBag()
    
    // Вспомогательная структура для отображения данных в виде секции
    var stickersSectionalData = [SectionOfImageStickerData]()
    struct SectionOfImageStickerData{
        var header: String
        var items: [Sticker]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadStickersTable()
    }
    
    // MARK: Загрузка таблицы со стикерами на тэгах
    func loadStickersTable(){
        let recievedStickers = viewModel.stickers
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
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfImageStickerData>(configureCell: {
            dataSource, table, index, item in
            let cell = table.dequeueReusableCell(withIdentifier: "TagDescriptionGalleryCell", for: index) as! TagDescriptionGalleryCell
            cell.tagDescription.text = item.specification
            cell.tagImage.image = UIImage(data: item.image!)
            return cell
        })
        
        // Связывание данных и таблицы
        Observable.just(stickersSectionalData).bind(to: tagTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        // Установка делегата для установки кастомной шапки секции
        tagTable.rx.setDelegate(self)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .tagCollectionHeaderColor
        label.font = UIFont(name: "a_BosaNova", size: 17)
        label.text = " \(stickersSectionalData[section].header)"
        return label
    }
    
    @IBAction func swipeDetection(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: view).x
        var endStatus : Bool? = nil
        if sender.state == .began || sender.state == .changed{
            endStatus = false
        }
        if sender.state == .ended{
            endStatus = true
        }
        AppDelegate.appDelegateLink.rootViewController.loadingMenuScreen(sourceLoading: "swipe" ,distanceSwiped: Int(transition), endStatus: endStatus)
    }
}

extension TagsCollectionController.SectionOfImageStickerData: SectionModelType{
    init(original: TagsCollectionController.SectionOfImageStickerData, items: [Sticker]) {
        self = original
        self.items = items
    }
}
