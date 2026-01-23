//
//  PreviewViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import Foundation
import UIKit

class LargeImageViewModel {
    
    let largeImageUrl: URL
    let descriptionText : String
    let likeText : String
    
    init(imageInfo: ImageInfo) {
        self.largeImageUrl = imageInfo.largeImageURL
        self.descriptionText = imageInfo.tags
        self.likeText = "\(imageInfo.likes) likes"
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void){
            ImageLoader.shared.loadImage(from: largeImageUrl) { image, _ in
                completion(image)
            }
        }
}
