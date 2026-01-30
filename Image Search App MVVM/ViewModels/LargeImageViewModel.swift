//
//  PreviewViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import Foundation
import UIKit

protocol LargeImageViewModelProtocol: AnyObject {
    var largeImageUrl: URL { get }
    var descriptionText: String { get }
    var likeText: String { get }
        
    func loadImage(completion: @escaping (UIImage?) -> Void)
}

class LargeImageViewModel: LargeImageViewModelProtocol{
    
    private var imageLoader: ImageLoaderProtocol
    
    let largeImageUrl: URL
    let descriptionText : String
    let likeText : String
    
    init(imageInfo: ImageInfo, imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.largeImageUrl = imageInfo.largeImageURL
        self.descriptionText = imageInfo.tags
        self.likeText = "\(imageInfo.likes) likes"
        self.imageLoader = imageLoader
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void){
            imageLoader.loadImage(from: largeImageUrl) { image, _ in
                completion(image)
            }
        }
}
