//
//  MockImageLoader.swift
//  Image Search App MVVM
//
//  Created by Yashika on 30/01/26.
//


import UIKit

class MockImageLoader: ImageLoaderProtocol {
    
    private let colors: [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemGreen,
            .systemOrange,
            .systemPurple
        ]

    func loadImage(from url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        
        let color = colors.randomElement()!
        let image = UIImage.placeholder(
            size: CGSize(width: 400, height: 240),
            color: color
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(image, url)
        }
    }
    
    func cancelAll(){
        
    }
    
}
extension UIImage {
    static func placeholder(
        size: CGSize,
        color: UIColor
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}

