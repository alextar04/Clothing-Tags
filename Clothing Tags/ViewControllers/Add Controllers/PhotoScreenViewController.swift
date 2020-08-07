//
//  PhotoScreenViewController.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 07.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class PhotoScreenViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var collectionExistingPhotos: UICollectionView!
    @IBOutlet weak var buttonNewPicture: UIButton!
    @IBOutlet weak var buttonNextScreen: UIButton!
    lazy var photoController = UIImagePickerController()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Выбор одежды")
        baseSettingsPhotoController()
        loadNewPicturePart()
        loadListPhotoPart()
        loadNextScreenPart()
    }
    
    // MARK: Базовая настройка объекта, отвечающего за фотографии
    func baseSettingsPhotoController(){
        let backgroundColor = UIColor(red: 232.0/255.0, green: 246.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        //self.galleryController.navigationItem.tintColor = backgroundColor
        self.photoController.view.backgroundColor = backgroundColor
        self.photoController.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
        [
            NSAttributedString.Key.font: UIFont(name: "a_BosaNova", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .normal)
        
        
        self.photoController.allowsEditing = true
        self.photoController.delegate = self
    }
    
    func loadNewPicturePart(){
        buttonNewPicture.rx.tap.asObservable().subscribe(onNext: {
            self.photoController.sourceType = .camera
            self.present(self.photoController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func loadListPhotoPart(){
        
        let recievedData : [UIImage] = [
            UIImage(), UIImage(), UIImage()
        ]
        
        var images : [PHAsset] = []
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
            images.append(object)
        })

        //In order to get latest image first, we just reverse the array
        images.reverse()

        
        let viewModelData = Observable.just(recievedData)
        viewModelData.bind(to: collectionExistingPhotos.rx.items){
            collection, row, item in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "PhotoScreenCell", for: IndexPath.init(row: row, section: 0)) as! ScreenPhotosCell
        
            cell.imageFromGallery.image = item
            return cell
        }.disposed(by: disposeBag)
        
        collectionExistingPhotos.rx.modelSelected(UIImage.self).subscribe(
        onNext: {selectedItem in
            // Выделение синим контура и ресайз фотографии при нажатии
        }).disposed(by: disposeBag)
    }
    
    func loadNextScreenPart(){
        
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
