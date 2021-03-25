//
//  FilterViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit
import ImageLoader
import APIService

protocol FilterViewControllerProtocol: AnyObject {
    
    var onGoToDismiss: (() -> Void)? { get set }
}

class FilterViewController: UIViewController {
    
    let mainResponse: MainResponse
    
    private lazy var categories: [GameCategory] = {
        mainResponse.categories
    }()
    
    private lazy var providers: [Provider] = {
        mainResponse.providers
    }()
    
    var onGoToDismiss: (() -> Void)?
    
    var selectedCategory: [Int] = []
    
    @IBOutlet private weak var filterCollectionView: UICollectionView!
    
    @IBAction private func didTapCancelButton(_ sender: Any) {
        
        self.onGoToDismiss?()
    }
    
    // MARK: Initialization
    
    init(for mainResponse: MainResponse) {
        self.mainResponse = mainResponse
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
}

// MARK: Setup methods

private extension FilterViewController {
    
    func configureCollectionView() {
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(type: CategoryCollectionViewCell.self)
        filterCollectionView.register(type: ProviderCollectionViewCell.self)
        filterCollectionView.register(type: HeaderCollectionReusableView.self,
                                      kind: UICollectionView.elementKindSectionHeader)
    }
    
}

// MARK: FilterViewControllerProtocol

extension FilterViewController: FilterViewControllerProtocol {
    
}

// MARK: Collection View Delegate

extension FilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            guard let cell = cell as? CategoryCollectionViewCell else { return }
            cell.categoryName = "Category"
            
            let category = categories[indexPath.row]
            
            ImageLoader.shared.downloadImage(from: category.imageURL, indexPath: indexPath) { image, idexPath, _ in
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: idexPath!) as? CategoryCollectionViewCell {
                        cell.image = image
                    }
                }
            }
            
        default:
            
            guard let cell = cell as? ProviderCollectionViewCell else { return }
            
            cell.identifier = 1
            
            let provider = providers[indexPath.row]
            ImageLoader.shared.downloadImage(from: provider.imageURL, indexPath: indexPath) { image, idexPath, _ in
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: idexPath!) as? ProviderCollectionViewCell {
                        cell.image = image
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
            cell?.didTap()
            
        default:
            
            let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
            cell?.didTap()
            
        }
    }
    
}

// MARK: Collection View DataSource

extension FilterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return filterCollectionView.dequeueReusableCell(with: CategoryCollectionViewCell.self, for: indexPath)
        case 1:
            return filterCollectionView.dequeueReusableCell(with: ProviderCollectionViewCell.self, for: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let kindView = UICollectionView.elementKindSectionHeader
        
        if kind == kindView {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kindView,
                                                                         with: HeaderCollectionReusableView.self,
                                                                         for: indexPath)
            if indexPath.section == 1 {
                header.sectionName = "Провайдеры"
            }
            
            return header
        }
        return .init()
    }
    
}

// MARK: Collection View Delegate Flow Layout

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: self.view.frame.width, height: 50)
        case 1:
            return CGSize(width: self.view.frame.width, height: 80)
        default:
            return CGSize()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 1:
            return CGSize(width: self.view.frame.width, height: 80)
        default:
            return CGSize()
        }
        
    }
    
}
