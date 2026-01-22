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
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let stateView = StateView()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpSearchController()
        
        bindViewModel()
            
        viewModel.fetchImageData()
    }
    
    private func setUp(){
        view.addSubview(tableView)
        view.addSubview(stateView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        stateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            stateView.topAnchor.constraint(equalTo: tableView.topAnchor),
            stateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            stateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    private func setUpSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
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
    
    private func bindViewModel(){
        viewModel.onStateChanged = {[weak self] state in
            guard let self else {return}
            
            switch state{
            case .loading:
                self.stateView.hide()
                self.tableView.tableFooterView = self.makeLoadingFooter()
            case .success:
                self.tableView.reloadData( )
                self.tableView.tableFooterView = nil
                self.stateView.hide()
            case .error(let error):
                print("error: \(error)")
                self.tableView.tableFooterView = nil
                self.stateView.setMessage("Error: \(error.localizedDescription)")
            case .noInternet:
                print("no internet")
                self.tableView.tableFooterView = nil
                self.stateView.setMessage("No internet connection")
            }
        }
        
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
}
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //get text
        guard
            let query = searchBar.text,
            !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else{
            return
        }
        //dismiss keyboard
        searchBar.resignFirstResponder()
        //tell view model to start search
        viewModel.search(query)
    }
}
