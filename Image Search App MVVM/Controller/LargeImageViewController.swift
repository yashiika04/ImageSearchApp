//
//  ImageDetailViewViewController.swift
//  Image Search App MVVM
//
//  Created by Yashika on 22/01/26.
//

import UIKit

class LargeImageViewController: UIViewController {
    
    private let viewModel: LargeImageViewModelProtocol
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let  descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Life cycle
    init(viewModel: LargeImageViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard for this view controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true 
        setupUI()
        bindViewModel()
    }
    
    //MARK: - setup
    private func setupUI(){
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            descriptionLabel,
            likesLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        
        view.addSubview(stackView)
        view.addSubview(spinner)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            spinner.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor)
        ])
            
        
    }
    
    // MARK: - Bind Function
    private func bindViewModel(){
        descriptionLabel.text = viewModel.descriptionText
        likesLabel.text = viewModel.likeText
        
        spinner.startAnimating()
        
        viewModel.loadImage { [weak self] image in
            guard let self else {return}
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.imageView.image = image
            }
        }
  
    }

}
