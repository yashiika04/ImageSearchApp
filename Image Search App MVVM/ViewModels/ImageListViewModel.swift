//
//  ImageListViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import Foundation

enum RequestState {
    case loading
    case error(Error)
    case noInternet
    case success
    case endOfData
}

class ImageListViewModel {
    
    private var imageData: [ImageInfo] = []
    private var currentDataTask: URLSessionDataTask?
    
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true
    private var currentQuery: String = "yellow flowers" //default
    var onStateChanged: ((RequestState)->Void)?
    
    func fetchImageData(){
        
        guard !isFetching && hasMoreData else{
            return
        }
        
        isFetching = true
        onStateChanged?(.loading)
    
        
        let encodedQuery = currentQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let urlString = """
        https://pixabay.com/api/?key=45834665-cd812607af12ca3f1bd5d4c19&q=\(encodedQuery)&image_type=photo&pretty=true&safesearch=true&per_page=50&page=\(currentPage)
        """

        guard
            let url = URL(string: urlString)
        else {
            isFetching = false
            onStateChanged?(.error(NSError(domain: "invalid url", code: 0)))
            return
        }
    
        currentDataTask = URLSession.shared.dataTask(with: url){ data, response, error in
         
            if let error {
                print("encountered an error: ", error)
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onStateChanged?(.error(error))
                   
                }
                return
            }
            
            guard let data else{
                print("could not get data")
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onStateChanged?(.error(NSError(domain: "invalid data", code: 0)))
               
                }
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode
            else {
                DispatchQueue.main.sync{
                    self.hasMoreData = false
                    self.onStateChanged?(.endOfData)
                }
                return
            }
            
            do{
                let response = try JSONDecoder().decode(ImageApiResponse.self, from: data)
                let images = response.hits
                
                DispatchQueue.main.async{
                    if images.isEmpty {
                        self.hasMoreData = false
                        self.isFetching = false
                        self.onStateChanged?(.endOfData)
                    }else{
                        self.imageData.append(contentsOf: images)
                        self.currentPage += 1
                    }
                    
                    self.isFetching = false
                    self.onStateChanged?(.success)
                }
                
            }catch{
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onStateChanged?(.error(error))
                }
                print(error)
            }
        }
        currentDataTask?.resume()
    }

    func search(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        
        //cancel previous url data task
        currentDataTask?.cancel()
        ImageLoader.shared.cancelAll()
        
        currentQuery = trimmed
        
        currentPage = 1
        hasMoreData = true
        isFetching = false
        
        imageData.removeAll()
        
        fetchImageData()
        
    }
    
    func numberOfRows()->Int{
        return imageData.count
    }
    
    func getCellVM(at index: Int)-> CustomCellViewModel {
        let info = imageData[index]
        return CustomCellViewModel(imageInfo: info)
    }

}

