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
        navigationBarTuning()
        loadCategoryScreen()
    }
    
    func loadDataCategory(){
        
    }
    
    func navigationBarTuning(){
        // Надпись по центру панели
        let labelCenterName = UILabel()
        labelCenterName.text = "Носки"
        labelCenterName.backgroundColor = .clear
        labelCenterName.font = UIFont(name: "a_BosaNova", size: 18)
        labelCenterName.sizeToFit()
        navigationItem.titleView = labelCenterName
        
        // Обновление цвета кнопки назад
        self.navigationController?.navigationBar.tintColor = .black
        if let viewControllers = self.navigationController?.viewControllers {
            let previousVC: UIViewController? = viewControllers.count >= 2 ? viewControllers[viewControllers.count - 2] : nil
            previousVC?.title = ""
        }
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
    
    func loadCategoryScreen(){
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
            
            // Округление изображения одежды в ячейке
            cellClothes.photoClothes.image = item.pictureClothes
            cellClothes.photoClothes.layer.cornerRadius = cellClothes.photoClothes.frame.height/2
            cellClothes.photoClothes.layer.borderColor = UIColor.black.cgColor
            cellClothes.photoClothes.layer.borderWidth = 1
            
            // Cвязать теги одежды и коллекцию тегов ячейки
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
        onNext: {
            print("You selected: \($0.nameClothes)")
        }).disposed(by: disposeBag)
    }

}
