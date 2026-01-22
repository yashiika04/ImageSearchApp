//
//  StateView.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import UIKit

class StateView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 10
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("no storyboard implemetnation")
    }
    
    private func setupUI(){
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        isHidden = true
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        isHidden = true
    }
    
    func setMessage(_ text: String){
        label.text = text
        isHidden = false
    }
    
    func hide(){
        isHidden = true
    }
    
}
