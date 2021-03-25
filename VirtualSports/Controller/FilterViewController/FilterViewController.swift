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
    
    
    // MARK: API SERVICE
    
    private lazy var apiService: APIFetcher = {
        return APIService(config: apiConfig)
    }()
    
    private let apiConfig = APIConfig(scheme: "https",
                                      host: "virtual-sports-yi3j9.ondigitalocean.app",
                                      mainPath: "/Games")
    
    // MARK: Properties
    
    @IBOutlet private weak var filterCollectionView: UICollectionView!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var acceptButtonHeight: NSLayoutConstraint!
    
    // TODO: NAMING + TYPES
    private var selectedCategoryId: String = ""
    private var selectedProviders: [String] = []
    private var selectedCategoryCell: CategoryCollectionViewCell?
    
    // MARK: Actions
    
    @IBAction private func didTapAcceptButton(_ sender: Any) {
        print(selectedCategoryId)
        print(selectedProviders)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        acceptButton.isHidden = true
    }
    
}

// MARK: Private methods

private extension FilterViewController {
    
    func configureCollectionView() {
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(type: CategoryCollectionViewCell.self)
        filterCollectionView.register(type: ProviderCollectionViewCell.self)
        filterCollectionView.register(type: HeaderCollectionReusableView.self,
                                      kind: UICollectionView.elementKindSectionHeader)
    }
    
    
    func acceptButtonEnabling() {
        
        if selectedProviders == [] && selectedCategoryId == "" {
            
            acceptButton.isHidden = true
            acceptButtonHeight.constant = 0
        } else {
            
            acceptButton.isHidden = false
            acceptButtonHeight.constant = 80
        }
    }
    
    func selectCategoryCell(_ cell: CategoryCollectionViewCell) {
        
        if selectedCategoryId == "" {
            selectedCategoryId = cell.identifier
            selectedCategoryCell = cell
            cell.selected()
        } else {
            if selectedCategoryId == cell.identifier {
                selectedCategoryId = ""
                selectedCategoryCell = nil
                cell.normal()
            } else {
                selectedCategoryCell?.normal()
                selectedCategoryId = cell.identifier
                selectedCategoryCell = cell
                cell.selected()
            }
        }
        
        acceptButtonEnabling()
    }
    
    func selectProviderCell(_ cell: ProviderCollectionViewCell) {
        
        if let identifier = cell.identifier {
            
            if selectedProviders.contains(identifier) {
                
                selectedProviders = selectedProviders.filter { $0 != identifier }
                cell.normal()
            } else {
                
                selectedProviders.append(identifier)
                cell.selected()
            }
        }
        
        acceptButtonEnabling()
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
            
            let category = categories[indexPath.row]
            
            cell.categoryName = category.name
            cell.identifier = category.id
            
            
            ImageLoader.shared.downloadImage(from: category.imageURL, indexPath: indexPath) { image, idexPath, _ in
                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: idexPath!) as? CategoryCollectionViewCell {
                        cell.image = image
                    }
                }
            }
            
        default:
            
            guard let cell = cell as? ProviderCollectionViewCell else { return }
            
            let provider = providers[indexPath.row]
            
            cell.identifier = provider.id
            
            
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
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            
            selectCategoryCell(cell)
            
        case 1:
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? ProviderCollectionViewCell else { return }
            
            selectProviderCell(cell)
            
        default:
            return
            
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
            
            return categories.count
            
        default:
            
            return providers.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return filterCollectionView.dequeueReusableCell(with: CategoryCollectionViewCell.self, for: indexPath)
        default:
            return filterCollectionView.dequeueReusableCell(with: ProviderCollectionViewCell.self, for: indexPath)
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
