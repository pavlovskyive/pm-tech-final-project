//
//  FilterViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

import ImageLoader
import APILayer
import NetworkService

struct FilterScope {
    var categoryId = ""
    var providersIds = [String]()
}

fileprivate extension Game {

    func isIncluded(in scope: FilterScope) -> Bool {
        let categoryCondition = scope.categoryId.isEmpty || self.categories.contains(scope.categoryId)

        let providersCondition = scope.providersIds.isEmpty || scope.providersIds.contains(self.provider)

        return categoryCondition && providersCondition
    }

}

fileprivate extension MainResponse {

    func filter(by scope: FilterScope) -> [Game] {
        self.games.filter { $0.isIncluded(in: scope) }
    }

}

protocol FilterViewControllerProtocol: AnyObject {

    typealias Dependency = HasImageLoader
    var dependency: Dependency? { get set }
    var onGoToDismiss: (() -> Void)? { get set }
}

protocol FilterDelegate: AnyObject {
    var isFiltered: Bool { get set }
    var filterScope: FilterScope { get set }
    func handleFilter(filteredGames: [Game], _ filterCount: Int)
}

class FilterViewController: UIViewController {

    // MARK: Vars

    let mainResponse: MainResponse

    weak private var delegate: FilterDelegate?

    private lazy var categories: [GameCategory] = {
        mainResponse.categories
    }()

    private lazy var providers: [Provider] = {
        mainResponse.providers
    }()

    var onGoToDismiss: (() -> Void)?
    var dependency: Dependency?
    var filterCount = 0

    // MARK: Properties

    @IBOutlet private weak var filterCollectionView: UICollectionView!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var acceptButtonHeight: NSLayoutConstraint!

    private var selectedCategoryId: String = ""
    private var selectedProviders: [String] = []
    private var selectedCategoryCell: CategoryCollectionViewCell?

    // MARK: Actions

    @IBAction private func didTapAcceptButton(_ sender: Any) {

        log.info("Accept button tapped")

        let scope = FilterScope(categoryId: selectedCategoryId, providersIds: selectedProviders)
        delegate?.isFiltered = true
        delegate?.filterScope = scope

        filterCount = selectedProviders.count
        if !selectedCategoryId.isEmpty { filterCount += 1 }
        
        delegate?.handleFilter(filteredGames: mainResponse.filter(by: scope), filterCount )

        onGoToDismiss?()
    }

    @IBAction private func didTapCancelButton(_ sender: Any) {

        log.info("Cancel button tapped")
        onGoToDismiss?()
    }

    // MARK: Initialization

    init(for mainResponse: MainResponse,
         delegate: FilterDelegate) {

        self.mainResponse = mainResponse
        self.delegate = delegate

        selectedCategoryId = delegate.filterScope.categoryId
        selectedProviders = delegate.filterScope.providersIds

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
        acceptButtonEnabling()
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

            acceptButtonHeight.constant = 0

            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: {[weak self] _ in
                self?.acceptButton.isHidden = true
            })

        } else {
            acceptButton.isHidden = false
            acceptButtonHeight.constant = 80

            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }

    func showIfSelectedCategory(_ cell: CategoryCollectionViewCell) {

        if selectedCategoryId == cell.identifier {
            selectedCategoryCell = cell
            cell.select()
        }
    }

    func showIfSelectedProvider(_ cell: ProviderCollectionViewCell) {

        guard let identifier = cell.identifier else {
            return
        }

        if selectedProviders.contains(identifier) {
            cell.select()
        }
    }

    func onCategoryCellSelected(_ cell: CategoryCollectionViewCell) {

        log.info("Category cell tapped")

        if selectedCategoryId == cell.identifier {

            selectedCategoryId = ""
            selectedCategoryCell = nil

            cell.makeNormal()
        } else {
            selectedCategoryCell?.makeNormal()

            selectedCategoryId = cell.identifier

            cell.select()
            selectedCategoryCell = cell

            scrollToCell(cell)
        }

        acceptButtonEnabling()
    }

    func onProviderCellSelected(_ cell: ProviderCollectionViewCell) {

        log.info("Provider cell tapped")
        guard let identifier = cell.identifier else {
            return
        }

        if selectedProviders.contains(identifier) {

            selectedProviders = selectedProviders.filter { $0 != identifier }
            cell.makeNormal()
        } else {

            selectedProviders.append(identifier)
            cell.select()

            scrollToCell(cell)
        }

        acceptButtonEnabling()

    }

    func scrollToCell(_ cell: UICollectionViewCell) {

        DispatchQueue.main.async { [weak self] in
            // Scroll to next cell + spacing
            let rect = CGRect(x: cell.frame.origin.x,
                              y: cell.frame.maxY - 10,
                              width: cell.frame.width,
                              height: cell.frame.height + 30)

            self?.filterCollectionView.scrollRectToVisible(rect, animated: true)
        }
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
            showIfSelectedCategory(cell)

            dependency?.imageLoader
                .downloadImage(from: category.imageURL, indexPath: indexPath) { image, indexPath, _ in

                guard let indexPath = indexPath else { return }

                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
                        cell.image = image
                    }
                }
            }

        default:

            guard let cell = cell as? ProviderCollectionViewCell else { return }

            let provider = providers[indexPath.row]

            cell.identifier = provider.id
            showIfSelectedProvider(cell)

            dependency?.imageLoader.downloadImage(from: provider.imageURL, indexPath: indexPath) { image, indexPath, _ in

                guard let indexPath = indexPath else {
                    return
                }

                DispatchQueue.main.async {
                    if let cell = collectionView.cellForItem(at: indexPath) as? ProviderCollectionViewCell {
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
            onCategoryCellSelected(cell)

        case 1:

            guard let cell = collectionView.cellForItem(at: indexPath) as? ProviderCollectionViewCell else { return }

            onProviderCellSelected(cell)

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
