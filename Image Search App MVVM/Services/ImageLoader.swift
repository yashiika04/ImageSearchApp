//
//  ImageCache.swift
//  Image Search App MVVM
//
//  Created by Yashika on 14/01/26.
//

import UIKit

protocol ImageLoaderProtocol: AnyObject{
    func loadImage(from url: URL, completion: @escaping (UIImage?, URL)->Void)
    func cancelAll()
}

final class ImageLoader: ImageLoaderProtocol{
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private var loadingResponses = [URL : [(UIImage?, URL)-> Void]]()
    private var runningTask = [URL: URLSessionDataTask]()
    private let queue = DispatchQueue(label: "com.image.loader.queue", attributes: .concurrent)
    
    private init(){}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?, URL)->Void){
        //cells and view models never touch url session directly
        
        //check cache
        if let cached = cache.object(forKey: url as NSURL){
            completion(cached, url)
            return
        }
        
        // see if is alreading in loading
        var shouldStartDownload = false
        
        queue.sync(flags: .barrier){
            if loadingResponses[url] != nil{
                loadingResponses[url]?.append(completion)
            }
            else{
                loadingResponses[url] = [completion]
                shouldStartDownload = true
            }
        }
        
        //if already downloading, just wait
        guard shouldStartDownload else { return }
        
        
        print("started netwrok call for downloading")
       
        let localURL = URL(string: url.absoluteString)!
        let downloadTask = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            
            var image: UIImage? = nil
            
            if let error{
                print("faced this error during data task: ", error)
            }
            
            if let data{
                image = UIImage(data: data)
            }
            
            if image == nil{
                print("problem while image creation")
            }
            
            if let image {
                DispatchQueue.main.async {
                    self?.cache.setObject(image, forKey: url as NSURL)
                }
                
            }
            
            //fetch all waiting completions
            var completions: [(UIImage?, URL)->Void] = []
            
            self?.queue.sync(flags: .barrier){
                completions = self?.loadingResponses[url] ?? []
                self?.loadingResponses[url] = nil
                self?.runningTask[url] = nil
            }
 
            DispatchQueue.main.async{
                completions.forEach({ $0(image, localURL)})
            }
            
        }
        
        queue.sync(flags: .barrier){
            self.runningTask[url] = downloadTask
        }
        downloadTask.resume()
    }
    
    func cancelAll(){
        queue.sync(flags: .barrier){
            self.runningTask.values.forEach({ $0.cancel() })
            self.runningTask.removeAll()
            self.loadingResponses.removeAll()
        }
    }
    
}
