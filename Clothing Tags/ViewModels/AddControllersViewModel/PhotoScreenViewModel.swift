//
//  PhotoScreenViewModel.swift
//  Clothing Tags
//
//  Created by Alexey Taran on 20.08.2020.
//  Copyright © 2020 Alexey Taran. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos

class PhotoScreenViewModel{
    lazy var listPhotoInformation = [PHAsset]()
    lazy var imageStorage = [UIImageView]()
    lazy var imageSubject = BehaviorRelay(value: [UIImageView]())
    var sizeImageStorageBeforeDownloading: Int = 0
    
    // MARK: API-Загрузка библиотеки фото
    func getImageFromLibrary(countLoadedPhotos : Int = 10,
                             completionClosure : @escaping (Result<[UIImageView], ErrorPhotoScreen>)->Void){
        var imagesInformationLocal = [PHAsset]()
        var imagesResultLocal = [UIImageView]()
        sizeImageStorageBeforeDownloading = imageStorage.count
        
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        DispatchQueue.global().async {
            // Однократная инициализация списка информации о фотографиях
            if self.listPhotoInformation.count == 0{
                assets.enumerateObjects{(object, count, stop) in
                    self.listPhotoInformation.append(object)
                }
                self.listPhotoInformation.reverse()
            }
            imagesInformationLocal = Array(self.listPhotoInformation[self.imageStorage.count...(self.imageStorage.count + countLoadedPhotos)])
        
            let imageManager = PHCachingImageManager()
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            if imagesInformationLocal.count != 0 {
                imagesInformationLocal.map{object in
                    let sizeImage = CGSize(width: 200, height: 200)
                    imageManager.requestImage(for: object, targetSize: sizeImage, contentMode: .aspectFit, options: imageOptions){
                            image, _ in
                        guard let convertedImage = image else{
                            completionClosure(.failure(ErrorPhotoScreen(errorMessage: "Ошибка конвертирования изображения!")))
                            return
                        }
                        imagesResultLocal.append(UIImageView(image: convertedImage))
                    }
                }
            }
            imagesResultLocal.map{self.imageStorage.append($0)}
            completionClosure(.success(imagesResultLocal))
        }
    }
    
}
