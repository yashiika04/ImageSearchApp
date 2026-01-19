//
//  ImageAPIResponse.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import Foundation


struct ImageApiResponse: Codable {
    let hits: [ImageInfo]
}

