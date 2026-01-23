//
//  CustomCellViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 14/01/26.
//

import Foundation
import UIKit

class CustomCellViewModel{
    
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
