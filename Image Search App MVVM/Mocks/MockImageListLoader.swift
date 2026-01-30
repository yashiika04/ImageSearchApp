//
//  MockImageListLoader.swift
//  Image Search App MVVM
//
//  Created by Yashika on 30/01/26.
//

import Foundation

class MockImageListLoader: ImageListLoaderProtocol {
    
    private let totalPages: Int = 10
    private var isCancelled: Bool = false
    
    func fetchImageList( for query: String, page: Int, completion: @escaping (Result<ImageApiResponse, ImageServiceError>) -> Void) {
        
        guard !isCancelled else {
            return
        }
        
        // simulate end of data
        guard page <= totalPages
        else{
            print("entering else block")
            completion(.failure(.endOfData))
            return
        }
        print("current page: \(page)")
        
        let fileName = "page\(page)"
        
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decode = try? JSONDecoder().decode(ImageApiResponse.self, from: data)
        else {
            completion(.failure(.error(NSError(domain: "mock decode error", code: 0))))
            return
        }
        
        
        DispatchQueue.main.async{
            completion(.success(decode))
        }
    }
    
    func cancel() {
        isCancelled = true
    }
}
