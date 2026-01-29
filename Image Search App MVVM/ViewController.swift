//
//  ViewController.swift
//  Image Search App MVVM
//
//  Created by Yashika on 13/01/26.
//

import UIKit

enum layoutMode{
    case list
    case grid
}

class ViewController: UIViewController {

    private let viewModel: ImageListViewModelProtocol
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let stateView = StateView()
    
    private var currentState: RequestState = .reset
    private var layoutMode: layoutMode = .list
    
    private lazy var listLayout = makeListLayout()
    private lazy var gridLayout = makeGridLayout()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        cv.register(CollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFooterView.identifier)
        return cv
        
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        return button
    }()

    init(viewModel: ImageListViewModelProtocol = ImageListViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpSearchController()
        
        bindViewModel()

        viewModel.fetchImageData()
    }
    
    // MARK: - Setup
    
    private func setUp(){
        view.addSubview(collectionView)
        view.addSubview(stateView)
        view.addSubview(toggleButton)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        stateView.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            stateView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            stateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            stateView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toggleButton.widthAnchor.constraint(equalToConstant: 56),
            toggleButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        toggleButton.addTarget(self, action: #selector(toggleLayoutMode), for: .touchUpInside)
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
    
    // MARK: - Layout Builders
    
    private func makeListLayout()-> UICollectionViewLayout {
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
        
        let footer = makeFooter()
        section.boundarySupplementaryItems = [footer]

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func makeGridLayout()-> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
    
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let footer = makeFooter()
        section.boundarySupplementaryItems = [footer]

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func makeFooter()-> NSCollectionLayoutBoundarySupplementaryItem{
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )

        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        return footer
    }
    
    // MARK: - Toggle
    @objc private func toggleLayoutMode(){
        layoutMode = (layoutMode == .list) ? .grid : .list
        let newLayout = (layoutMode == .list) ? makeListLayout() : makeGridLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: true)
        collectionView.reloadData()
        
        // Force visible cells to update their internal UI immediately
        for cell in collectionView.visibleCells {
            if let imageCell = cell as? CollectionViewCell,
               let indexPath = collectionView.indexPath(for: imageCell) {
                let info = viewModel.getImageInfo(at: indexPath.row)
                let vm = CollectionViewCellViewModel(imageInfo: info)
                
                // Re-configure the visible cell manually to hide/show labels
                imageCell.configure(with: vm, isGrid: layoutMode == .grid)
            }
        }
    }
    
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel(){
        viewModel.onStateChanged = {[weak self] state in
            guard let self else {return}
            
            currentState = state
            
            switch state{
            case .initalLoading:
                self.stateView.setMessage( "Loading...")
                
            case .loadingNextPage:
                self.stateView.hide()
                self.collectionView.reloadSections(IndexSet(integer: 0))
                
            case .success:
                self.stateView.hide()
                self.collectionView.reloadData()
         
            case .endOfData:
                self.stateView.hide()
                self.collectionView.reloadSections(IndexSet(integer: 0))
        
            case .reset:
                self.stateView.hide()
                self.collectionView.reloadData()

            case .error(let error):
                if self.viewModel.numberOfRows() == 0{
                    self.stateView.setMessage("Error: \(error.localizedDescription)", action: .retry)
                }else{
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            
            case .noInternet:
                if self.viewModel.numberOfRows() == 0 {
                    self.stateView.setMessage("No internet connection", action: .retry)
                } else {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
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
        cell.configure(with: vm, isGrid: layoutMode == .grid)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 5 {
            switch currentState {
            case .error, .noInternet, .endOfData:
                return
            default:
                DispatchQueue.main.async{
                    self.viewModel.fetchImageData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagInfo = viewModel.getImageInfo(at: indexPath.row)
        let detailVM = LargeImageViewModel(imageInfo: imagInfo)
        let vc = LargeImageViewController(viewModel: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CollectionFooterView.identifier,
                    for: indexPath
              ) as? CollectionFooterView
        else {
            return UICollectionReusableView()
        }
        switch currentState{
        case .loadingNextPage:
            footer.configure(type: .loading)
        case .endOfData:
            footer.configure(type: .endOfData)
        case .error, .noInternet:
            footer.configure(type: .retry(action: { [weak self] in
                self?.viewModel.fetchImageData()
            }))
        default:
            footer.configure(type: .none)
        }
        return footer
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
