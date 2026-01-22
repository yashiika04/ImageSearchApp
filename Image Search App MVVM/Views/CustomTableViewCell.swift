//
//  CustomTableViewCell.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomCell"
    
    private var viewModel: CustomCellViewModel?

    private let myImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
   
    private var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    

    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()
    
    private let loader: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder){
        fatalError("story board is disabled")
    }
    
  
    override func prepareForReuse(){
        super.prepareForReuse( )

        myImageView.image = nil
        loader.startAnimating() // reset on reuse
        
    }
    
 
    private func setupUI(){
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.addArrangedSubview(likesLabel)
        
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(loader)
        self.contentView.addSubview(labelsStackView)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            myImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 100),
            myImageView.heightAnchor.constraint(equalToConstant: 100),
            
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            labelsStackView.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),


            loader.centerXAnchor.constraint(equalTo: self.myImageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.myImageView.centerYAnchor)
        ])
        
        
    }

    func config(with viewModel: CustomCellViewModel) {
        
        self.viewModel = viewModel
        
        descriptionLabel.text = viewModel.descriptionText
        likesLabel.text = viewModel.likesText
        
        loader.startAnimating()
            
        ImageLoader.shared.loadImage(from: viewModel.url) { [weak self] image, url in
            guard let self else {return}
            if self.viewModel?.imageInfo.previewURL == url {
                self.loader.stopAnimating()
                self.myImageView.image = image
            }
        }

    }
}

