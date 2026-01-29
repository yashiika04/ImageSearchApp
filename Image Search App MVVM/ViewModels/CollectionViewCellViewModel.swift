//
//  CollectionViewCellViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 23/01/26.
//

import Foundation
import UIKit

protocol CollectionViewCellViewModelProtocol: AnyObject{
    var url: URL { get }
    var imageInfo: ImageInfo { get }
    
    var descriptionText: String { get }
    var likesText: String { get }
}

class CollectionViewCellViewModel: CollectionViewCellViewModelProtocol{
    let imageInfo: ImageInfo
    let url: URL
    
    var descriptionText: String{
        imageInfo.tags
    }
    
    var likesText: String {
        "Likes: \(imageInfo.likes)"
    }
    
    init(imageInfo: ImageInfo) {
       self.imageInfo = imageInfo
       self.url = imageInfo.previewURL
    }
}
