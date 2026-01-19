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

    private var decpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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
        labelsStackView.addArrangedSubview(decpLabel)
        labelsStackView.addArrangedSubview(likesLabel)
        
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(loader)
        self.contentView.addSubview(labelsStackView)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            myImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            myImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            myImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
//            myImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 100),
            myImageView.heightAnchor.constraint(equalToConstant: 100),
            
            labelsStackView.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 12),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            loader.centerXAnchor.constraint(equalTo: self.myImageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: self.myImageView.centerYAnchor)
        ])
        
        
    }

    func config(with viewModel: CustomCellViewModel) {
        
        self.viewModel = viewModel
        
        decpLabel.text = viewModel.descriptionText
        likesLabel.text = viewModel.likesText
        
        loader.startAnimating()
            
        viewModel.fetchImage() { [weak self] image in
            self?.loader.stopAnimating() //hides spinner
            self?.myImageView.image = image
            //set the label
        }
        
        
    }

}

