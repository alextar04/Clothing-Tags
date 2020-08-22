//
//  CategoryScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 31.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryScreenViewController: UIViewController {
    @IBOutlet weak var tableClothes: UITableView!
    let disposeBag = DisposeBag()
    var idCategory: Int? = nil
    var nameCategory: String? = nil
    var viewModel: CategoryScreenViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameCategory!)
        self.viewModel = CategoryScreenViewModel(idCategory: idCategory!)
        loadCategoryTable()
    }
    
    func loadCategoryTable(){
        
        let recievedDataTags = (viewModel?.convertSetStickersToImageArray())!
        Observable.just(viewModel!.clothes).bind(to: tableClothes.rx.items){
            table, row, item in
            let cellClothes = table.dequeueReusableCell(withIdentifier: "categoryScreenCell", for: IndexPath.init(row: row, section: 0)) as! CategoryScreenCell
            
            cellClothes.nameClothes.text = item.name
            cellClothes.tagsCollection.dataSource = nil
            cellClothes.photoClothes.roundingImageCell(newPicture: UIImage(data: item.photoClothes!))
            
            // Cвязывание теги одежды и коллекцию тегов ячейки
            let tagsData = Observable.just(recievedDataTags[row])
            tagsData.bind(to: cellClothes.tagsCollection.rx.items){
                collection, place, image in
                let cellTag = collection.dequeueReusableCell(withReuseIdentifier: "tagCategoryCell", for: IndexPath(row: place, section: 0)) as! TagCategoryCell
                
                cellTag.tagImage.image = image
                return cellTag
            }.disposed(by: self.disposeBag)
            
            return cellClothes
        }.disposed(by: disposeBag)
        
        tableClothes.rx.modelSelected(Clothes.self).subscribe(
        onNext: {selectedItem in
            let clothesScreenViewController = UIStoryboard(name: "ClothesScreen", bundle: nil).instantiateViewController(withIdentifier: "ClothesScreenID") as? ClothesScreenViewController
            clothesScreenViewController?.idClothes = Int(selectedItem.id)
            clothesScreenViewController?.nameScreen = selectedItem.name
            
            if let clothesScreen = clothesScreenViewController{
                self.navigationController?.pushViewController(clothesScreen, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
