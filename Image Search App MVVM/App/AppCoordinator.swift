//
//  AppCoordinator.swift
//  Image Search App MVVM
//
//  Created by Yashika on 30/01/26.
//



import UIKit

class AppCoordinator {
    
    let window: UIWindow
    let diContainer: AppDIContainer
    
    private var rootViewConqroller: UINavigationController? = nil
    private var navVC: UINavigationController? = nil
    
    init (window: UIWindow, diContainer: AppDIContainer) {
        self.window = window
        self.diContainer = diContainer
    }
    
    func start() {
        //some business logic to start the app with
        let vc = diContainer.makeImageListVC(coordinator: self)
        
        navVC = UINavigationController(rootViewController: vc)
//        self.window..rootViewController = navVC
        self.window.rootViewController = navVC
        self.window.makeKeyAndVisible()
    }
    
    func showImagePreviewVC(for imageInfo: ImageInfo) {
        let vc = diContainer.makePreviewImageVC(for: imageInfo)
       navVC?.pushViewController(vc, animated: true)
    }
}
