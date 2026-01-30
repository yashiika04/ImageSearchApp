//
//  ImageListViewModel.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import Foundation

enum RequestState {
    case initalLoading
    case loadingNextPage
    case success
    case error(Error)
    case noInternet
    case endOfData
    case reset
}

protocol ImageListViewModelProtocol: AnyObject{
    var onStateChanged: ((RequestState) -> Void)? { get set }
    
    func fetchImageData()
    func search(_ query: String)
    
    func numberOfRows() -> Int
    func getImageInfo(at index: Int) -> ImageInfo
    func getCellVM(at index: Int) -> CustomCellViewModel
}

class ImageListViewModel: ImageListViewModelProtocol {
    
    private var imageLoader: ImageLoaderProtocol
    private var imageListLoader: ImageListLoaderProtocol
    
    private var imageData: [ImageInfo] = []
    private var currentDataTask: URLSessionDataTask?
    
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true
    private var currentQuery: String = "yellow flowers" //default
    
    var onStateChanged: ((RequestState)->Void)?
    
    init(imageLoader: ImageLoaderProtocol = ImageLoader.shared, imageListLoader: ImageListLoaderProtocol = ImageListLoader()){
        self.imageLoader = imageLoader
        self.imageListLoader = imageListLoader
    }
    
    func fetchImageData() {
        guard !isFetching && hasMoreData else {
            return
        }
        
        isFetching = true
        if (currentPage == 1) {
            onStateChanged?(.initalLoading)
        } else {
            onStateChanged?(.loadingNextPage)
        }
        
        imageListLoader.fetchImageList(for: currentQuery, page: currentPage) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {  
                self.isFetching = false
                
                switch result {
                case .success(let response):
                    if response.hits.isEmpty {
                        self.hasMoreData = false
                        self.onStateChanged?(.endOfData)
                    } else {
                        self.imageData.append(contentsOf: response.hits)
                        self.currentPage += 1
                        self.onStateChanged?(.success)
                    }
                case .failure(let error):
                    switch error {
                    case .endOfData:
                        self.hasMoreData = false
                        self.onStateChanged?(.endOfData)
                        
                    case .noInternet:
                        self.onStateChanged?(.noInternet)
                        
                    case .error(let error):
                        self.onStateChanged?(.error(error))
                    }
                }
            }
        }
    }
    

    func search(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        
        //cancel previous url data task
        imageListLoader.cancel()
        imageLoader.cancelAll()
        
        currentQuery = trimmed
        
        currentPage = 1
        hasMoreData = true
        isFetching = false
        
        imageData.removeAll()
        
        onStateChanged?(.reset)
        
        fetchImageData()
        
    }
    
    func numberOfRows()->Int{
        return imageData.count
    }
    
    func getImageInfo(at index: Int) -> ImageInfo {
        return imageData[index]
    }

    
    func getCellVM(at index: Int)-> CustomCellViewModel {
        let info = imageData[index]
        return CustomCellViewModel(imageInfo: info)
    }

}

