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
    let disposeBag = DisposeBag()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBarTuning()
        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Мой гардероб")
        loadMainMenu()
    }
    
    // CORE DATA
    class A{
        var name: String = ""
        init(_ s: String) {
            name = s
        }
    }
    
    // MARK: Привязка таблицы к данным, описание взаимодействия с пользователем
    func loadMainMenu(){
        
        // CORE DATA
        let recievedData : [A] = [A("loadingMenu.jpg"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png"),A("listClothes.png")]
        let viewModelData = Observable.just(recievedData)
        
        viewModelData.bind(to: collectionView.rx.items){
            collection, row, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "mainScreenCell", for: IndexPath.init(row: row, section: 0)) as! MainScreenCell
            
            cell.imageView?.image = UIImage(named: item.name)
            cell.label.text = item.name
            return cell
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(A.self).subscribe(
            onNext: {selectedItem in
                let categoryScreenViewController = UIStoryboard(name: "CategoryScreen", bundle: nil).instantiateViewController(withIdentifier: "CategoryScreenID") as? CategoryScreenViewController
                
                if let categoryScreen = categoryScreenViewController{
                    self.navigationController?.pushViewController(categoryScreen, animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
    
    // MARK: Обработка действий с левым боковым меню
    @objc func loadMenuFromMainScreen(){
        AppDelegate.appDelegateLink.rootViewController.loadingMenuScreen(sourceLoading: "barButton", distanceSwiped: 240, endStatus: nil)
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
