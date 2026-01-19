//
//  ViewController.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView  = UITableView()

    let viewModel = ImageListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        // 1. Bind ViewModel to ViewController
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            self?.tableView.tableFooterView = isLoading ? self?.makeLoadingFooter(): nil
            
        }
            
        // 2. Ask ViewModel to fetch data
        viewModel.fetchImageData()
    }
    
    //set up table view UI
    private func setUp(){
        view.addSubview(tableView)
        
//        tableView.backgroundColor = .red
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    //set-up footer
    private func makeLoadingFooter()-> UIView{
        let footer = UIView(frame: CGRect(x: 0, y: 0,
                                                 width: tableView.frame.width,
                                                 height: 60))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating( )
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "Loading..."
            label.textColor = .secondaryLabel
            label.font  = .systemFont(ofSize: 14)
            return label
        }()
        
        footer.addSubview(spinner)
        footer.addSubview(label)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                spinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
                spinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor),

                label.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: spinner.trailingAnchor)
            ])
        
        return footer
    }


}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else{
            fatalError("could not create the cell")
        }


        cell.config(with: self.viewModel.getCellVM(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 5 {
            viewModel.fetchImageData()
        }
    }
    
    func tableView(_ tableView: UITableView,
               heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
}
