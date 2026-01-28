//
//  ReusableFooterView.swift
//  Image Search App MVVM
//
//  Created by Yashika on 27/01/26.
//

import UIKit

class CollectionFooterView: UICollectionReusableView {
    
    static let identifier = "CollectionFooterView"
    
    private let footerView = TableFooterView(type: .loading, width: 0)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder){
        fatalError("storyboard not set up")
    }
    
    private func setup(){
        footerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(footerView)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: topAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(type: FooterType){
        print("configuring ther footer")
        footerView.configure(type: type)
    }
}

