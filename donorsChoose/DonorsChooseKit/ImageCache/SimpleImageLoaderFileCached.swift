//
//  SimpleImageLoaderFileCached.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

internal class SimpleImageLoaderFileCached: ObservableObject {
    
    private let enableCache = true
    
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    
    private var deluxCache: DeluxCache<String, UIImage>?
    
    private let imageKey: ImageKey?
    
    private(set) var isLoading = false
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(imageKey: ImageKey?, cache: DeluxCache<String, UIImage>? ) {
        self.imageKey = imageKey
        if enableCache {
            self.deluxCache = cache
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        
        guard !isLoading else {
            return
        }
        
        guard let imageKey = imageKey else {
            self.image = invalidImage
            return
        }
        
        if let localFileCachedImage = deluxCache?.readFromFileStorage( key: imageKey ) {
            self.image = localFileCachedImage
        }
        
//        guard let urlString = AmazonService.getPreSignedURL(.primary, S3DownloadKeyName: s3Key) else  {
//            return
//        }
        let urlString = imageKey
        
        guard let url = URL(string:urlString ) else {
            return
        }
        
        if let image = deluxCache?[imageKey] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.onStart() },
                receiveOutput: { [weak self] in self?.output($0) },
                receiveCompletion: { [weak self] _ in self?.onFinish() },
                receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    // rename to fetchOutput
    private func output(_ image: UIImage?) {
        guard let imageKey = imageKey else {
            return
        }
        
        image.map {
            deluxCache?[imageKey] = $0
        }
        
        if let image = image {
            //write it to the file storage so its there on startup
            deluxCache?.writeToFileStorage(key: imageKey, image:image )
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    var invalidImage:UIImage {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200))
        let cgImage = CIContext().createCGImage(CIImage(color: .gray), from: frame)!
        return UIImage(cgImage: cgImage)
    }
}

