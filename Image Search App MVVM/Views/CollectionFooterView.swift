//
//  ReusableFooterView.swift
//  Image Search App MVVM
//
//  Created by Yashika on 27/01/26.
//

import UIKit

class CollectionFooterView: UICollectionReusableView {
    
    static let identifier = "CollectionFooterView"
    
    private var footerView: TableFooterView?

    func configure(type: FooterType) {
        footerView?.removeFromSuperview()

        let view = TableFooterView(type: type, width: bounds.width)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        footerView = view
    }
}

