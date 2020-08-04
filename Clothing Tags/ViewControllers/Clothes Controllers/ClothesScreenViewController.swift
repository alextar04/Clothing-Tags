//
//  ClothesScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 03.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClothesScreenViewController: UIViewController {
    
    @IBOutlet weak var photoClothes: UIImageView!
    @IBOutlet weak var photoTag: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    @IBOutlet weak var yandexButton: UIButton!
    
    @IBOutlet weak var nameClothes: UILabel!
    @IBOutlet weak var dateReminding: UILabel!
    
    @IBOutlet weak var tagsTable: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //navigationBarTuning()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Одежда")
        loadClothesScreen()
    }

    
    // CORE DATA
    class TagData{
        var descriptionTag : String = ""
        var pictureTag : UIImage!
        init(_ name : String, _ picture : UIImage) {
            descriptionTag = name
            pictureTag = picture
        }
    }
    
    func loadClothesScreen(){
        
        photoClothes.image = UIImage(named: "facebookLogo.png")!
        photoTag.image = UIImage(named: "facebookLogo.png")!
        
        // Округление кнопок для публикации в заметках соцсети
        [facebookButton, vkButton, yandexButton].map{
            $0!.imageView?.roundingImageCell(newPicture: nil)
        }
        
        // CORE DATA
        let recievedData : [TagData] = [
            TagData("Полоскайте белье под температурой 30 градусов на бережной стирке", UIImage(named: "tags.png")!),
            TagData("Теннисные носки", UIImage(named: "facebookLogo.png")!),
            TagData("Теннисные носки", UIImage(named: "tags.png")!),
            TagData("Теннисные носки", UIImage(named: "tags.png")!),
            TagData("Теннисные носки", UIImage(named: "tags.png")!),
        ]
        
        // Получение высоты таблицы
        tableHeightConstraint.constant = tagsTable.rowHeight * CGFloat(recievedData.count)
        let viewModelData = Observable.just(recievedData)
        viewModelData.bind(to: tagsTable.rx.items){
            table, row, item in
            let cell = table.dequeueReusableCell(withIdentifier: "tagDescriptionCell", for: IndexPath.init(row: row, section: 0)) as! TagDescriptionCell
        
            cell.tagImage.image = item.pictureTag
            cell.tagDescription.text = item.descriptionTag
            return cell
        }.disposed(by: disposeBag)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        print("Меня решили удалить!")
    }
    
    @IBAction func reminderSwitchPressed(_ sender: Any) {
        print("Изменили ползунок")
    }
    
}
