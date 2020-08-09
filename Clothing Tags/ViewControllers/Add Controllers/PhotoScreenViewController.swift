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
    @IBOutlet weak var heightPhotoColleciton: NSLayoutConstraint!
    
    lazy var photoController = UIImagePickerController()
    lazy var currentSelectedIndex : IndexPath! = nil
    lazy var imageStorage : [UIImageView] = []
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: "Выбор одежды")
        baseSettingsPhotoController()
        loadNewPicturePart()
        loadListPhotoPart()
        // Сделать колбэк через добавление в массив как в методичке!
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, flags: .barrier){
            print("Получилось")
        }
    }
    
    // MARK: Базовая настройка экрана, отвечающего за доступ к камере
    func baseSettingsPhotoController(){
        let backgroundColor = UIColor(red: 232.0/255.0, green: 246.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.photoController.view.backgroundColor = backgroundColor
        
        self.photoController.allowsEditing = true
        self.photoController.delegate = self
    }
    
    // MARK: Размещение функционала камеры
    func loadNewPicturePart(){
        buttonNewPicture.rx.tap.asObservable().subscribe(onNext: {
            self.photoController.sourceType = .camera
            self.present(self.photoController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else{
            fatalError("Ошибка получения фотографии")
        }
        
        loadNextScreen()
        picker.dismiss(animated: true, completion: nil)
        // Паттерн Команда для кнопки далее и этого случая
    }
    
    // MARK: API-Загрузка библиотеки фото
    func getImageFromLibrary(countLoadedPhotos : Int = 10,
                             completionClosure : @escaping (Result<[UIImageView],                                        ErrorPhotoScreen>)->Void){
        var images = [PHAsset]()
        var imagesResult = [UIImageView]()
        
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        DispatchQueue.global().async {
            assets.enumerateObjects{(object, count, stop) in
                images.append(object)
            }
            images.reverse()
            images = Array(images[self.imageStorage.count...(self.imageStorage.count + countLoadedPhotos)])
        
            let imageManager = PHCachingImageManager()
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            if images.count != 0 {
                images.map{object in
                    //let sizeImage = CGSize(width: 1334, height: 750)
                    let sizeImage = CGSize(width: 500, height: 500)
                    imageManager.requestImage(for: object, targetSize: sizeImage, contentMode: .aspectFit, options: imageOptions){
                            image, _ in
                        guard let convertedImage = image else{
                            completionClosure(.failure(ErrorPhotoScreen(errorMessage: "Ошибка конвертирования изображения!")))
                            return
                        }
                        imagesResult.append(UIImageView(image: convertedImage))
                    }
                }
            }
            completionClosure(.success(imagesResult))
        }
    }
    
    // MARK: Размещение коллекции фотографий
    func loadListPhotoPart(){
        getImageFromLibrary{ result in
            switch result{
                case .success(let recievedData):
                    let countCellsInString = self.view.frame.width / 118.0
                    let countStringsCollection : Int = Int(ceil(CGFloat(recievedData.count) / countCellsInString))
                    recievedData.map{self.imageStorage.append($0)}
                    
                    DispatchQueue.main.async {
                        self.heightPhotoColleciton.constant = 125.0 * CGFloat(countStringsCollection)
                        let viewModelData = Observable.just(self.imageStorage)
                        viewModelData.bind(to: self.collectionExistingPhotos.rx.items){
                            collection, row, item in
                            let cell = collection.dequeueReusableCell(withReuseIdentifier: "PhotoScreenCell", for: IndexPath.init(row: row, section: 0)) as! ScreenPhotosCell
                        
                                cell.imageFromGallery.image = item.image
                                cell.selectedBorder.isHidden = true
                            
                                return cell
                        }.disposed(by: self.disposeBag)
                        
                        self.collectionExistingPhotos.rx.itemSelected.subscribe(
                        onNext: {selectedIndex in
                            // Отмена выделения старой ячейки
                            if let index = self.currentSelectedIndex{
                                let cell = self.collectionExistingPhotos.cellForItem(at: index) as! ScreenPhotosCell
                                cell.selectedBorder.isHidden = true
                            }
                            // Выделение новой ячейки
                            let cell = self.collectionExistingPhotos.cellForItem(at: selectedIndex) as! ScreenPhotosCell
                            print(cell.selectedBorder.isHidden)
                            cell.selectedBorder.isHidden = false
                            self.currentSelectedIndex = selectedIndex
                            
                        }).disposed(by: self.disposeBag)
                    }
                case .failure(let error):
                    print("Ошибка \(error.errorMessage)")
            }
        }
    }
    
    func loadNextScreen(){
        print("Загрузка нового экрана")
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

struct ErrorPhotoScreen : Error {
    let errorMessage : String
}
