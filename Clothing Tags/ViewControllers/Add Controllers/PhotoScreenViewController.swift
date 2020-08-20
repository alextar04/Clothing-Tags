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

class PhotoScreenViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBOutlet weak var buttonNewPicture: UIButton!
    
    @IBOutlet weak var collectionExistingPhotos: UICollectionView!
    @IBOutlet weak var heightPhotoColleciton: NSLayoutConstraint!
    @IBOutlet weak var loadingCollectionWheel: UIActivityIndicatorView!
    @IBOutlet weak var loadingCollectionWheelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonNextScreen: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var offsetFromBottomScrollView: NSLayoutConstraint!
    
    lazy var photoController = UIImagePickerController()
    lazy var currentSelectedIndex : IndexPath! = nil
    lazy var currentSelectedPhoto : UIImageView? = nil
    
    var nameScreen : String = ""
    var viewModel = PhotoScreenViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BaseSettings.navigationBarTuning(navigationController: self.navigationController,
                                         navigationItem: navigationItem,
                                         nameTop: nameScreen)
        baseSettingsPhotoController()
        loadNewPicturePart()
        
        baseSettingsScrollingSettings()
        loadListPhotoPart()
        
        setSettingsNextButton()
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
        }).disposed(by: self.disposeBag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else{
            fatalError("Ошибка получения фотографии")
        }
        currentSelectedPhoto = UIImageView(image: editedImage)
        // Обновление фона кнопки новой фотографии
        buttonNewPicture.setBackgroundImage(currentSelectedPhoto?.image, for: .normal)
        if let index = self.currentSelectedIndex{
            let cell = self.collectionExistingPhotos.cellForItem(at: index) as! ScreenPhotosCell
            cell.selectedBorder.isHidden = true
            currentSelectedIndex = nil
        }
        
        loadNextScreen()
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Настройка скролящийся площади для появление колеса загрузки
    func baseSettingsScrollingSettings(){
        scrollView.rx.didScroll.subscribe(onNext: {
            if self.loadingCollectionWheel.isHidden == true{
                let scrollOffset = self.scrollView.contentOffset.y
                
                let startCollection = self.collectionExistingPhotos.frame.minY +
                    UIApplication.shared.statusBarFrame.height +
                    (self.navigationController?.navigationBar.frame.height)!
                
                let heightCollection = self.heightPhotoColleciton.constant
                let offsetTable = startCollection + heightCollection - self.view.frame.height

                if scrollOffset >= offsetTable + 48{
                    print("Надо ставить колесико!")
                    self.loadingCollectionWheelConstraint.constant = self.collectionExistingPhotos.frame.maxY - 35
                    self.loadingCollectionWheel.isHidden = false
                    self.loadListPhotoPart()
                }
            }
        }).disposed(by: self.disposeBag)
    }

    // MARK: Размещение коллекции фотографий
    func loadListPhotoPart(){
        viewModel.getImageFromLibrary{ result in
            switch result{
                case .success(let recievedData):
                    
                    var sumWidthOfCellsInString = 0.0
                    var countCellsInString = 0
                    while sumWidthOfCellsInString < Double(self.collectionExistingPhotos.frame.width) {
                        sumWidthOfCellsInString += (113.0 + 10.0)
                        countCellsInString += 1
                    }
                    let countStringsCollection : Int = Int(ceil(CGFloat(self.viewModel.sizeImageStorageBeforeDownloading + recievedData.count) / CGFloat(countCellsInString)))
                
                    DispatchQueue.main.async{
                        self.heightPhotoColleciton.constant = (123.0 * CGFloat(countStringsCollection)) + 55
                        self.loadingCollectionWheel.isHidden = true
                        self.collectionExistingPhotos.isHidden = false
                        
                        // Привязка требуется лишь единожды при инициализации
                        if self.viewModel.sizeImageStorageBeforeDownloading == 0{
                            self.viewModel.imageSubject.accept(self.viewModel.imageStorage)
                            self.viewModel.imageSubject.asObservable().bind(to: self.collectionExistingPhotos.rx.items){
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
                                    cell.selectedBorder.isHidden = false
                                    self.currentSelectedIndex = selectedIndex
                                    self.currentSelectedPhoto = cell.imageFromGallery
                                    
                                    self.buttonNewPicture.setBackgroundImage(nil, for: .normal)
                                    
                                }).disposed(by: self.disposeBag)
                        }else{
                            self.viewModel.imageSubject.accept(self.viewModel.imageStorage)
                        }
                }
                case .failure(let error):
                    print("Ошибка \(error.errorMessage)")
            }
        }
    }
    
    
    // MARK: Настройка кнопки "Далее"
    func setSettingsNextButton(){
        buttonNextScreen.rx.tap.bind{
            self.loadNextScreen()
        }
    }
    
    // MARK: Загрузка нового экрана
    func loadNextScreen(){
        if nameScreen == "Выбор одежды"{
            ClotheS.getInstance()?.photoClothes = currentSelectedPhoto
            let tagPhotoScreenViewController = UIStoryboard(name: "PhotoScreen", bundle: nil).instantiateViewController(withIdentifier: "PhotoScreenID") as? PhotoScreenViewController
            tagPhotoScreenViewController?.nameScreen = "Выбор бирки"
            
            if let tagPhotoScreen = tagPhotoScreenViewController{
                self.navigationController?.pushViewController(tagPhotoScreen, animated: true)
            }
        }
        
        if nameScreen == "Выбор бирки"{
            ClotheS.getInstance()?.photoTag = currentSelectedPhoto
            let inputNameAndCategoryViewController = UIStoryboard(name: "NameCategoryScreen", bundle: nil).instantiateViewController(withIdentifier: "NameCategoryScreenID") as? NameCategoryScreenController
            inputNameAndCategoryViewController?.nameScreen = "Выбор названия и категории"
            
            if let inputInformationScreen = inputNameAndCategoryViewController{
                self.navigationController?.pushViewController(inputInformationScreen, animated: true)
            }
        }
        
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
