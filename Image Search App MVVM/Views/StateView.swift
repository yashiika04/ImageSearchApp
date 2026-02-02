//
//  StateView.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import UIKit

enum StateViewAction{
    case retry
}

protocol StateViewProtocol: AnyObject{
    var onActionTapped: ((StateViewAction)->Void)? {get set}
    func setMessage(_ text: String, action: StateViewAction?)
    func hide()
}
extension StateViewProtocol {
    func setMessage(_ text: String) {
        setMessage(text, action: nil)
    }
}

class StateView: UIView, StateViewProtocol{
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 10
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.isHidden = true
        return button
    }()
    
    var onActionTapped: ((StateViewAction)->Void)?
    
    
    //MARK: - life cycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("no storyboard implemetnation")
    }
    
    //MRK: - Setup
    private func setupUI(){
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [label, actionButton])
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
        
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func setMessage(_ text: String, action: StateViewAction? = nil){
        label.text = text
        isHidden = false
        actionButton.isHidden = true
        
        if let type = action{
            
            switch type {
            case .retry:
                actionButton.setTitle("Retry", for: .normal)
                actionButton.isHidden = false
                
            }
        }
    }
    
    func hide(){
        isHidden = true
    }
        
    @objc private func didTapButton(){
        guard let title = actionButton.titleLabel?.text else { return }
        switch title{
        case "Retry": onActionTapped?(.retry)
        default: break
        }
    }
}
