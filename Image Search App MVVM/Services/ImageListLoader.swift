//
//  ImageListLoader.swift
//  Image Search App MVVM
//
//  Created by Yashika on 29/01/26.
//

import UIKit

enum ImageServiceError: Error{
    case noInternet
    case endOfData
    case error(Error)
}

protocol ImageListLoaderProtocol: AnyObject{
    func fetchImageList( for query: String, page: Int, completion: @escaping (Result<ImageApiResponse, ImageServiceError>) -> Void)
   func cancel()
}

class ImageListLoader: ImageListLoaderProtocol{
    
    private var currentDataTask: URLSessionDataTask?
    
    func fetchImageList(for query: String, page: Int, completion: @escaping (Result<ImageApiResponse, ImageServiceError>) -> Void){
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = """
        https://pixabay.com/api/?key=45834665-cd812607af12ca3f1bd5d4c19&q=\(encodedQuery)&image_type=photo&pretty=true&safesearch=true&per_page=50&page=\(page)
        """
        
        guard let url = URL(string: urlString)
        else{
            completion(.failure(.error(NSError(domain: "invalid url", code: 0))))
            return
        }
        
        currentDataTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let error{
                completion(.failure(.error(error)))
                return
            }
            
            guard let data else{
                completion(.failure(.error(NSError(domain: "invalid data", code: 0))))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode
            else{
                completion(.failure(.endOfData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ImageApiResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.error(error)))
            }
        }
        currentDataTask?.resume()
    }
    
    func cancel(){
        currentDataTask?.cancel()
    }
}
