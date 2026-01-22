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
    
    private func makeFooter(for state: RequestState)-> UIView?{
        switch state{
        case .loadingNextPage:
            return TableFooterView(type: .loading, width: tableView.frame.width)
        case .endOfData:
            return TableFooterView(type: .endOfData, width: tableView.frame.width)
        case .error, .noInternet:
            return TableFooterView(type: .retry(action: {[weak self] in
                self?.viewModel.fetchImageData()
            }), width: tableView.frame.width)
        default:
            return nil
        }
    }
    
    private func bindViewModel(){
        viewModel.onStateChanged = {[weak self] state in
            guard let self else {return}
            
            switch state{
            case .initalLoading:
                self.stateView.setMessage( "Loading...")
    
            case .loadingNextPage:
                self.stateView.hide()
                self.tableView.tableFooterView = makeFooter(for: .loadingNextPage)
            case .success:
                self.stateView.hide()
                self.tableView.reloadData( )
                self.tableView.tableFooterView = makeFooter(for: .success)
            case .endOfData:
                self.stateView.hide()
                self.tableView.tableFooterView = makeFooter(for: .endOfData)
            case .error(let error):
                if self.viewModel.numberOfRows() == 0{
                    //first page error block screen
                    self.stateView.setMessage("Error: \(error.localizedDescription)", action: .retry)
                }else{
                    // Pagination error → don’t block
                    self.tableView.tableFooterView = makeFooter(for: .error(error))
                }
            case .noInternet:
                if self.viewModel.numberOfRows() == 0 {
                    self.stateView.setMessage("No internet connection", action: .retry)
                } else {
                    self.tableView.tableFooterView = makeFooter(for: .noInternet)
                }
            }
        }
        
        stateView.onActionTapped = {[weak self] action in
            guard let self else {return}
            
            switch action{
                case .retry:
                self.viewModel.fetchImageData()
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
