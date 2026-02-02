//
//  AppDIContainer.swift
//  Image Search App MVVM
//
//  Created by Yashika on 30/01/26.
//




class AppDIContainer {
    
    var listLoader: ImageListLoaderProtocol = ImageListLoader()
    var imageLoader: ImageLoaderProtocol = ImageLoader()

    
    init () {
        
    }
    
    func makeImageListVC(coordinator: AppCoordinator) -> ViewController {
        let viewModel = ImageListViewModel(
            imageLoader: imageLoader,
            imageListLoader: listLoader,
            coordinator: coordinator
        )
        
        let stateView = StateView()
        
        let viewController = ViewController(viewModel: viewModel, stateView: stateView)
        return viewController
    }
    
    func makePreviewImageVC(for imageInfo: ImageInfo) -> LargeImageViewController{
        let viewModel = LargeImageViewModel(imageInfo: imageInfo)
        let vc = LargeImageViewController(viewModel: viewModel)
        return vc
    }
    
}
