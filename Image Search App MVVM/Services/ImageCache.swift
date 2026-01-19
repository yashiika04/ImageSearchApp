//
//  ImageCache.swift
//  Image Search App MVVM
//
//  Created by Yashika on 14/01/26.
//

import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private let queue = DispatchQueue(label: "com.yourapp.imagecache.queue")
    
    var loadingResponses = [URL : [(UIImage?)-> Void]]()
    
    private init(){}
    
    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage,for url: URL) {
            cache.setObject(image, forKey: url as NSURL)
    }
    
//    func appendCompletion(_ completion: @escaping (UIImage?) -> Void, for url: URL)-> Bool{
//       // queue.sync{
//            if var existing = loadingResponses[url]{
//                existing.append(completion)
//                loadingResponses[url] = existing
//                return true
//            }else{
//                loadingResponses[url] = [completion]
//                return false
//            }
//       //}
//    }
//    
//    func removeCompletion(for url: URL)-> [(UIImage?)-> Void]?{
//       // return queue.sync{
//            let completions = loadingResponses[url]
//            loadingResponses[url] = nil
//            return completions
//       // }
//    }
    
}
