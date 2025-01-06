//
//  GalleryViewModel.swift
//  Live It
//
//  Created by Muniyaraj on 24/08/24.
//

import Photos
import UIKit
import Combine

public typealias PHAssetPublisher = AnyPublisher<Bool, Error>

struct GalleyPhotos {
    var selected: Bool
    var asset: PHAsset
}

final class GalleryViewModel: BaseObject{
    private var fetchResult: PHFetchResult<PHAsset>?
    private let imageManager = PHCachingImageManager()
    private let fetchOptions: PHFetchOptions
    private var pageNumber = 0
    let pageSize = 30
    
    var fetchedLastData: Bool = false
    
    public var currentResult: [GalleyPhotos] = [] // to collectionView dataSource

    private var imageCache = NSCache<NSNumber, UIImage>()
    
    override init() {
        fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
    
    func fetchPhotos() -> PHAssetPublisher {
        return Future<Bool, Error> { [weak self] promise in
            PHPhotoLibrary.requestAuthorization { status in
                debugPrint("Photo Gallery Authorized Status : \(status)")
                guard status == .authorized else {
                    DispatchQueue.main.async {
                        promise(.failure(NSError(domain: "GalleryError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Access Denied"])))
                    }
                    return
                }
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    
                    // Load fetchResult if it is nil
                    if self.fetchResult == nil {
                        let allPhotos = PHAsset.fetchAssets(with: .image, options: self.fetchOptions)
                        self.fetchResult = allPhotos
                        
                        debugPrint("All photos count : \(allPhotos.count)")
                    }
                    
                    // Fetch a subset of assets based on pagination
                    let startIndex = self.pageNumber * self.pageSize
                    let endIndex = min(startIndex + self.pageSize, self.fetchResult?.count ?? 0)
                    
                    guard startIndex < endIndex else {
                        DispatchQueue.main.async {
                            promise(.success(true))
                        }
                        return
                    }
                    
                    let assetsToFetch = self.fetchResult?.objects(at: IndexSet(integersIn: startIndex..<endIndex)) ?? []
                    
                    self.currentResult.append(contentsOf: assetsToFetch.compactMap{ GalleyPhotos(selected: false, asset: $0)} )
                                        
                    debugPrint("currentResult count : \(self.currentResult.count)")
                    
                    // Ensure the promise is fulfilled on the main thread
                    DispatchQueue.main.async {
                        promise(.success(true))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    
    func requestImage(for asset: PHAsset, targetSize: CGSize,contentMode: PHImageContentMode = .aspectFit,isLoadCache: Bool = true) -> Future<UIImage?, Error> {
        return Future { [weak self] promise in
            guard let assetIdentifier = asset.localIdentifier as String? else {
                print("Error: Invalid PHAsset or missing localIdentifier")
                promise(.success(nil))
                return
            }
            let assetKey = NSNumber(value: assetIdentifier.hash)

            if let cachedImage = self?.imageCache.object(forKey: assetKey), isLoadCache {
                DispatchQueue.main.async {
                   promise(.success(cachedImage))
                }
                return
            }
            
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            if !isLoadCache{
                options.deliveryMode = .highQualityFormat
            }
            options.resizeMode = !isLoadCache ? .exact : .fast
            
            
            // imageManager.startCachingImages(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil)


            self?.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options/*nil*/) { [weak self] (image, _) in
                if let image = image, isLoadCache {
                    self?.imageCache.setObject(image, forKey: assetKey)
                }
                DispatchQueue.main.async {
                    promise(.success(image))
                }
            }
        }
    }
    
    func asset(at index: Int) -> PHAsset? {
        return fetchResult?.object(at: index)
    }
    
    func numberOfAssets() -> Int {
        return fetchResult?.count ?? 0
    }
    
    func loadMorePhotos() -> PHAssetPublisher {
        pageNumber += 1
        return fetchPhotos()
            .eraseToAnyPublisher()
    }
    func removeCache(){
        imageCache.removeAllObjects()
        debugPrint("Received memory warning - cleared cache")
    }
}
