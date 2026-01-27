//
//  ImageCollectionViewCell.swift
//  Image Search App MVVM
//
//  Created by Yashika on 23/01/26.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    private var viewModel: CollectionViewCellViewModel?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.addArrangedSubview(likesLabel)
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStackView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            // Image on left
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            // Text on right
            labelsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Allow cell to be at least image height
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }
    
    func configure(with viewModel: CollectionViewCellViewModel){
        self.viewModel = viewModel
        
        descriptionLabel.text = viewModel.descriptionText
        likesLabel.text = viewModel.likesText
        
        loader.startAnimating()
            
        ImageLoader.shared.loadImage(from: viewModel.url) { [weak self] image, url in
            guard let self else {return}
            if self.viewModel?.imageInfo.previewURL == url {
                self.loader.stopAnimating()
                self.imageView.image = image
            }
        }
    }
}
