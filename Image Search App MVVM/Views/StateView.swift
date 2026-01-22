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
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.isHidden = true
        return button
    }()
    
    var onRetryTapped: (()->Void)?
    
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
        
        let stackView = UIStackView(arrangedSubviews: [label, retryButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
            
        ])
        
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    func setMessage(_ text: String, showRetry: Bool = false){
        label.text = text
        isHidden = false
        retryButton.isHidden = !showRetry
    }
    
    func hide(){
        isHidden = true
    }
    
    @objc private func didTapRetry(){
        onRetryTapped?()
    }
}

#Preview {
    let stateView = StateView()
    stateView.setMessage("No Internet", showRetry: true) // make visible
    //stateView.frame = CGRect(x: 0, y: 0, width: 300, height: 200) // set frame for preview
    return stateView
}
