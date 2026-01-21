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
    
    private var requestID = UUID()
    
    var descriptionText: String{
        //return imageInfo.tags.split(separator: ",").first.map(String.init) ?? "Error while extracting description"
        imageInfo.tags
    }
    
    var likesText: String {
        "Likes: \(imageInfo.likes)"
    }
    
    init(imageInfo: ImageInfo) {
       self.imageInfo = imageInfo
       //self.url = imageInfo.previewURL
       self.url = imageInfo.largeImageURL
    }
    
    
}






//class CustomCellViewModel{
//    var imageInfo: ImageInfo
//    var url: URL
//    var currentImageURL: URL?
//    var image: UIImage?
//    var onImageUpdated: ((UIImage?)->Void)?
//    
//    var descriptionText: String {
//        let description = imageInfo.tags.split(separator: ",").first ?? "Error"
//        return String(description)
//    }
//
//    var likesText: String {
//        return "Likes: \(imageInfo.likes)"
//    }
//    
//    private var imageTask: URLSessionDataTask?
//    
//    init(imageInfo: ImageInfo) {
//        self.imageInfo = imageInfo
//        //self.url = imageInfo.previewURL
//        self.url = imageInfo.largeImageURL
//    }
//    
//    func fetchImage(completion: @escaping (UIImage?)->Void){
//        
//        currentImageURL = url
//        
//        if let cachedImage = ImageCache.shared.getImage(for: url){
//            completion(cachedImage)
//            return
//        }
//        
//      
//        if var existingCompletions = ImageCache.shared.loadingResponses[url] {
//            existingCompletions.append(completion)
//            ImageCache.shared.loadingResponses[url] = existingCompletions
//            return
//        } else {
//            ImageCache.shared.loadingResponses[url] = [completion]
//        }
//        
////        let resp = ImageCache.shared.appendCompletion(completion, for: url)
////        if resp{
////            return
////        }
//
//       print("starting image download at: ", url)
//        
//        let localVariableURL = url //this should result in a copy of `url`
//        
//        
//        //download if not cached
//        imageTask = URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
//            
//            if let error{
//                print("encountered an error: ", error)
//                return
//            }
//            
//            guard
//                let data,
//                let image = UIImage(data: data)
//            else {
//                print("could not download data")
//                return
//            }
//            
////            DispatchQueue.main.async{
////                ImageCache.shared.insert(image, for: localVariableURL)
////                let completions = ImageCache.shared.removeCompletion(for: localVariableURL)
////                DispatchQueue.main.async{
////                    completions?.forEach {
////                        $0(image)
////                    }
////
////                }
////            }
//            
//            
//            //insert image into cache
//            ImageCache.shared.insert(image, for: localVariableURL)
//
//            //extract all completition blocks for that url
//            let completions = ImageCache.shared.loadingResponses[localVariableURL]
//            ImageCache.shared.loadingResponses[localVariableURL] = nil
//            
//            
//            //let completions = ImageCache.shared.removeCompletion(for: localVariableURL)
//            
////            if let self = self {
////                if self.currentImageURL == localVariableURL {
////                    DispatchQueue.main.async{
////                        completions?.forEach {
////                            $0(image)
////                        }
////
////                    }
////                }
////            } else {
////                print("could not download data")
////            }
//      
//            if self?.currentImageURL == localVariableURL {
//                print("yashika: model is still alive")
//                DispatchQueue.main.async{
//                    completions?.forEach {
//                        $0(image)
//                    }
//                }
//            }
//            else{
//                print("yashiika04")
//            }
//        }
//        
//        imageTask?.resume()
//    }
//    
//    func cancel() {
//            imageTask?.cancel()
//    }
//    
//}
