//
//  ImageListViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import Foundation

class ImageListViewModel {
    
    private var imageData: [ImageInfo] = []
    
    //page tracking
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true
    
    //notify the view controller when data changes
    var onDataUpdated: (()-> Void)?
    //notify the state change
    var onLoadingStateChanged: ((Bool)->Void)?
    
    //fetch logic
    func fetchImageData(){
        
        guard !isFetching && hasMoreData else{
            return
        }
        
        isFetching = true
        onLoadingStateChanged?(true)
        
        guard let url = URL(string: "https://pixabay.com/api/?key=45834665-cd812607af12ca3f1bd5d4c19&q=yellow+flowers&image_type=photo&pretty=true&safesearch=true&per_page=50&page=\(currentPage)")
        else{
            isFetching = false
            onLoadingStateChanged?(false)
            return
        }
        
        //api call
        URLSession.shared.dataTask(with: url){ data, response, error in
            
//          self.isFetching = false -> updating via background thread

            
            if let error {
                print("encountered an error: ", error)
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onLoadingStateChanged?(false)
                }
                return
            }
            
            guard let data else{
                print("could not get data")
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onLoadingStateChanged?(false)
                }
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode
            else {
                print("Server error:", response ?? "")
                return
            }
            
            //decode json
            do{
                let response = try JSONDecoder().decode(ImageApiResponse.self, from: data)
                let images = response.hits
               
//                if images.isEmpty {
//                    self.hasMoreData = false
//                }else{
//                    self.imageData.append(contentsOf: images)
//                    self.currentPage += 1
//                }
                
                //dispatch queue notify on main thread
                DispatchQueue.main.async{
                    if images.isEmpty {
                        self.hasMoreData = false
                    }else{
                        self.imageData.append(contentsOf: images)
                        self.currentPage += 1
                    }
                    
                    self.isFetching = false
                    self.onLoadingStateChanged?(false)
                    self.onDataUpdated?()
                }
                
            }catch{
                DispatchQueue.main.async{
                    self.isFetching = false
                    self.onLoadingStateChanged?(false)
                }
                print(error)
            }
            
        }.resume()
    }
    
    //return rows in imageData
    func numberOfRows()->Int{
        return imageData.count
    }
    
    //return data at particular index
    func getCellVM(at index: Int)-> CustomCellViewModel {
        let info = imageData[index]
        //return CustomCellViewModel(imageURL: info.previewURL)
        return CustomCellViewModel(imageInfo: info)
    }
    
    
}

