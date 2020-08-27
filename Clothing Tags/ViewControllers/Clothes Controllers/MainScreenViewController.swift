//
//  MainScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 15.07.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nameScreen: String = "Мой гардероб"
    var viewModel = MainScreenViewModel()
    let disposeBag = DisposeBag()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen,
                                         viewController: self)
        loadMainMenu()
    }
    
    // MARK: Привязка таблицы к данным, описание взаимодействия с пользователем
    func loadMainMenu(){
        Observable.just(viewModel.categories).bind(to: collectionView.rx.items){
            collection, row, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "mainScreenCell", for: IndexPath.init(row: row, section: 0)) as! MainScreenCell
            
            cell.imageView?.image = UIImage(data: item.photo!)
            cell.imageView.roundingRect()
            cell.label.text = item.name
            return cell
        }.disposed(by: disposeBag)
        
        // Выбор определенной категории одежды
        collectionView.rx.modelSelected(Category.self).subscribe(
            onNext: {selectedItem in
                let categoryScreenViewController = UIStoryboard(name: "CategoryScreen", bundle: nil).instantiateViewController(withIdentifier: "CategoryScreenID") as? CategoryScreenViewController
                categoryScreenViewController?.idCategory = Int(selectedItem.id)
                categoryScreenViewController?.nameCategory = selectedItem.name
                
                if let categoryScreen = categoryScreenViewController{
                    self.navigationController?.pushViewController(categoryScreen, animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
    
    @IBAction func swipeDetected(_ sender: UIPanGestureRecognizer) {
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
