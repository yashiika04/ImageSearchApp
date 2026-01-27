//
//  ViewController.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import UIKit

class ViewController: UIViewController {
    
    //let tableView  = UITableView()
    private let viewModel = ImageListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let stateView = StateView()
    
    private lazy var layout: UICollectionViewLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 120)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 10
//        layout.scrollDirection = .vertical
//        return layout

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(120)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(120)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            return UICollectionViewCompositionalLayout(section: section)

    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return cv
        
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpSearchController()
        
        bindViewModel()

        viewModel.fetchImageData()
    }
    
    private func setUp(){
        view.addSubview(collectionView)
        view.addSubview(stateView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        stateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            stateView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            stateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            stateView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
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
    
//    private func makeFooter(for state: RequestState)-> UIView?{
//        switch state{
//        case .loadingNextPage:
//            return TableFooterView(type: .loading, width: tableView.frame.width)
//        case .endOfData:
//            return TableFooterView(type: .endOfData, width: tableView.frame.width)
//        case .error, .noInternet:
//            return TableFooterView(type: .retry(action: {[weak self] in
//                self?.viewModel.fetchImageData()
//            }), width: tableView.frame.width)
//        default:
//            return nil
//        }
//    }
    
    private func makeFooter(for state: RequestState)-> UIView?{
        switch state{
        case .loadingNextPage:
            return TableFooterView(type: .loading, width: collectionView.frame.width)
        case .endOfData:
            return TableFooterView(type: .endOfData, width: collectionView.frame.width)
        case .error, .noInternet:
            return TableFooterView(type: .retry(action: {[weak self] in
                self?.viewModel.fetchImageData()
            }), width: collectionView.frame.width)
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
//                self.tableView.tableFooterView = makeFooter(for: .loadingNextPage)
           
            case .success:
                self.stateView.hide()
                self.collectionView.reloadData()
//                self.tableView.reloadData( )
//                self.tableView.tableFooterView = makeFooter(for: .success)
            case .endOfData:
                break
//                self.stateView.hide()
//                self.tableView.tableFooterView = makeFooter(for: .endOfData)
            case .reset:
                self.stateView.hide()
                self.collectionView.reloadData()
//                self.tableView.reloadData()
            case .error(let error):
                if self.viewModel.numberOfRows() == 0{
                    //first page error block screen
                    self.stateView.setMessage("Error: \(error.localizedDescription)", action: .retry)
                }else{
                    // Pagination error → don’t block
//                    self.tableView.tableFooterView = makeFooter(for: .error(error))
                }
            case .noInternet:
                if self.viewModel.numberOfRows() == 0 {
                    self.stateView.setMessage("No internet connection", action: .retry)
                } else {
//                    self.tableView.tableFooterView = makeFooter(for: .noInternet)
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
extension ViewController: UICollectionViewDataSource,  UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
           fatalError("could not get the cell")
        }
        let info = viewModel.getImageInfo(at: indexPath.row)
        let vm = CollectionViewCellViewModel(imageInfo: info)
        cell.configure(with: vm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 5 {
            viewModel.fetchImageData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagInfo = viewModel.getImageInfo(at: indexPath.row)
        let detailVM = LargeImageViewModel(imageInfo: imagInfo)
        let vc = LargeImageViewController(viewModel: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPAth: IndexPath)-> CGSize{
////        let padding: CGFloat = 10*3
////        let availableWidth = collectionView.frame.width - padding
////        let width = availableWidth / 2
//        return CGSize(width: collectionView.frame.width,height:.infinity)
//    }
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
