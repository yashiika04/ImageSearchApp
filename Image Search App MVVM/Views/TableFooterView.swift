//
//  TableFooterView.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import UIKit

enum FooterType{
    case none
    case loading
    case endOfData
    case retry (action: ()->Void)
}

class TableFooterView: UIView {
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = nil
        return label
    }()
    private var retryAction: (()->Void)?
    
    
    init(type: FooterType, width: CGFloat){
        super.init(frame: CGRect(x:0, y:0, width: width, height: 60))
        setupViews()
        configure(type:type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard implementation")
    }
    
    private func setupViews(){
        let stack = UIStackView(arrangedSubviews: [spinner, label])
          stack.axis = .horizontal
          stack.spacing = 8
          stack.alignment = .center
          stack.distribution = .fill
          stack.translatesAutoresizingMaskIntoConstraints = false

          addSubview(stack)

          NSLayoutConstraint.activate([
              stack.centerXAnchor.constraint(equalTo: centerXAnchor),
              stack.centerYAnchor.constraint(equalTo: centerYAnchor)
          ])
 
          label.font = .systemFont(ofSize: 14)
          label.textColor = .secondaryLabel
    }
    
    func configure(type: FooterType){
        retryAction = nil
        spinner.isHidden = true
        
        switch type{
        case .none:
            spinner.stopAnimating( )
            label.isHidden = true
        case .loading:
            spinner.startAnimating( )
            spinner.isHidden = false
            label.text = "Loading..."
        case .endOfData:
            label.text = "No more data to load"
        case .retry(action: let action):
            label.isHidden = false
            label.text = "Tap to retry"
            label.textColor = .systemBlue
            retryAction = action
            
            //add tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRetry))
            addGestureRecognizer(tap)
        }
        
    }
    
    @objc private func didTapRetry(){
        retryAction?()
    }
    
    
    
    

}
