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
    var nameScreen: String = ""
    @IBOutlet weak var tagTable: UITableView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        loadStickersTable()
    }
    
    // CORE DATA
    struct SectionOfImageStickerData{
      var header: String
      var items: [TagData]
    }
    var stickersData = [SectionOfImageStickerData]()
    
    // MARK: Загрузка таблицы со стикерами на тэгах
    func loadStickersTable(){
        var listRecievedStickers = [TagData]()
        for i in 0...23{
            listRecievedStickers.append(TagData(String(i), UIImage(named: "add.png")!))
        }
        stickersData = [SectionOfImageStickerData(header: "First", items: Array(listRecievedStickers[0...5])),
                            SectionOfImageStickerData(header: "Second", items: Array(listRecievedStickers[6...11])),
                            SectionOfImageStickerData(header: "Third", items: Array(listRecievedStickers[12...17])),
                            SectionOfImageStickerData(header: "Fourth", items: Array(listRecievedStickers[18...23]))
        ]
        
        // Конфигурация содержимого для ячеек таблицы
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfImageStickerData>(configureCell: {
            dataSource, table, index, item in
            let cell = table.dequeueReusableCell(withIdentifier: "TagDescriptionGalleryCell", for: index) as! TagDescriptionGalleryCell
            cell.tagDescription.text = item.descriptionTag
            cell.tagImage.image = item.pictureTag
            return cell
        })
        
        // Связывание данных и таблицы
        Observable.just(stickersData).bind(to: tagTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        // Установка делегата для установки кастомной шапки секции
        tagTable.rx.setDelegate(self)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .tagCollectionHeaderColor
        label.font = UIFont(name: "a_BosaNova", size: 17)
        label.text = " \(stickersData[section].header)"
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
    init(original: TagsCollectionController.SectionOfImageStickerData, items: [TagData]) {
        self = original
        self.items = items
    }
}
