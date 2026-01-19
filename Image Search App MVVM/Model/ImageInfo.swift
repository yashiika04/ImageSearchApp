//
//  ImageInfo.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import Foundation


struct ImageInfo: Codable {
    let previewURL: URL
    let largeImageURL: URL
    let likes: Int
    let tags: String
}
