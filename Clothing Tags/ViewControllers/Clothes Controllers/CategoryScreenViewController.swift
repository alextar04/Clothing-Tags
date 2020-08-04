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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CORE DATA
        loadDataCategory()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Носки")
        loadCategoryTable()
    }
    
    func loadDataCategory(){
        
    }
    
    // CORE DATA
    class ClothesData{
        var nameClothes : String = ""
        var pictureClothes : UIImage!
        init(_ name : String, _ picture : UIImage) {
            nameClothes = name
            pictureClothes = picture
        }
    }
    
    func loadCategoryTable(){
        // CORE DATA
        let recievedData : [ClothesData] = [
            ClothesData("Теннисные носки", UIImage(named: "loadingMenu.jpg")!),
            ClothesData("Теннисные носки", UIImage(named: "loadingMenu.jpg")!),
            ClothesData("Теннисные носки", UIImage(named: "loadingMenu.jpg")!),
            ClothesData("Теннисные носки", UIImage(named: "loadingMenu.jpg")!),
            ClothesData("Теннисные носки", UIImage(named: "loadingMenu.jpg")!),
        ]
        let recivedDataTags : [[UIImage]] = [[UIImage(named: "add.png")!,UIImage(named: "allert.png")!, UIImage(named: "tags.png")!], [UIImage(named: "add.png")!,UIImage(named: "allert.png")!, UIImage(named: "tags.png")!], [UIImage(named: "add.png")!,UIImage(named: "allert.png")!, UIImage(named: "tags.png")!], [UIImage(named: "add.png")!,UIImage(named: "allert.png")!, UIImage(named: "tags.png")!], [UIImage(named: "add.png")!,UIImage(named: "allert.png")!, UIImage(named: "tags.png")!]]
        
        
        let viewModelData = Observable.just(recievedData)
        viewModelData.bind(to: tableClothes.rx.items){
            table, row, item in
            let cellClothes = table.dequeueReusableCell(withIdentifier: "categoryScreenCell", for: IndexPath.init(row: row, section: 0)) as! CategoryScreenCell
            
            cellClothes.nameClothes.text = item.nameClothes
            cellClothes.tagsCollection.dataSource = nil
            cellClothes.photoClothes.roundingImageCell(newPicture: item.pictureClothes)
            
            // Cвязывание теги одежды и коллекцию тегов ячейки
            let tagsData = Observable.just(recivedDataTags[row])
            tagsData.bind(to: cellClothes.tagsCollection.rx.items){
                collection, place, image in
                let cellTag = collection.dequeueReusableCell(withReuseIdentifier: "tagCategoryCell", for: IndexPath(row: place, section: 0)) as! TagCategoryCell
                
                cellTag.tagImage.image = image
                return cellTag
            }.disposed(by: self.disposeBag)
            
            return cellClothes
        }.disposed(by: disposeBag)
        
        tableClothes.rx.modelSelected(ClothesData.self).subscribe(
        onNext: {selectedItem in
            let clothesScreenViewController = UIStoryboard(name: "ClothesScreen", bundle: nil).instantiateViewController(withIdentifier: "ClothesScreenID") as? ClothesScreenViewController
            
            if let clothesScreen = clothesScreenViewController{
                self.navigationController?.pushViewController(clothesScreen, animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
