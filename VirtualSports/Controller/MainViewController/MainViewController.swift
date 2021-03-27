//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APILayer
import AuthLayer

import Network

protocol MainViewControllerProtocol: BaseViewControllerProvider {

    typealias Dependencies = HasAuthProvider & HasAPIFetching

    var dependencies: Dependencies? { get set }

    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: ((_ game: Game?) -> Void)? { get set }
    var onGoToFilter: ((_ mainResponse: MainResponse?) -> Void)? { get set }
    var onGoToOffline: (() -> Void)? { get set }

}

@available(iOS 13.0, *)
class MainViewController: UIViewController, MainViewControllerProtocol {

    var dataSource: UICollectionViewDiffableDataSource<GameSection, Game>?
    var sections: [GameSection] = []

    var dependencies: Dependencies?

    var mainResponse: MainResponse?
    var favouriteGames = [Game]()
    var recentGames = [Game]()
    var filteredGames = [Game]()

    var isFiltered = false
    var filterScope = FilterScope()

    var onGoToLogin: (() -> Void)?
    var onGoToRegistration: (() -> Void)?
    var onGoToGame: ((_ game: Game?) -> Void)?
    var onGoToFilter: ((_ mainResponse: MainResponse?) -> Void)?
    var onGoToOffline: (() -> Void)?

    var connectionState = NetworkMonitor.shared.connectionState {
        willSet {
            checkNetworkConnectionState(newValue)
        }
    }

    @IBOutlet private weak var topBar: TopBar!
    @IBOutlet private weak var filterButtonView: FilterButtonView!
    @IBOutlet private weak var gameCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStatusBar(backgroundColor: .black)
        filterButtonView.delegate = self
        topBar.delegate = self
        topBar.showMainTopBar()
        checkNetworkConnectionState(connectionState)

    }

    private func checkNetworkConnectionState(_ state: ConnectionState) {
        switch state {
        case .connected:
        dependencies?.authProvider.subscribe(self)
            fetchMain()
            configureCollectionView()
        case .disconnected:
            DispatchQueue.main.async {
                self.onGoToOffline?()
            }
        }

        NetworkMonitor.shared.handleConnection = { [weak self] isConnected in
            guard let self = self else { return }
            self.connectionState = isConnected
        }
    }

    deinit {
        dependencies?.authProvider.unsubscribe(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func configureCollectionView() {

        gameCollectionView.collectionViewLayout = createCompositionalLayout()
        gameCollectionView.delegate = self
        gameCollectionView.register(type: GameCollectionViewCell.self)
        gameCollectionView.register(type: HeaderCollectionReusableView.self,
                                      kind: UICollectionView.elementKindSectionHeader)

    }

    // MARK: - Setup Layout

    func createCompositionalLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) ->
            NSCollectionLayoutSection? in

            let section = self.sections[sectionIndex]

            switch section.tag {
            case "top":
                return self.createWaitingChatSection()
            default:
                return self.createActiveChatSection()
            }
        }

        return layout
    }

    func createWaitingChatSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(self.view.layer.frame.width/2 - 8),
                                                     heightDimension: .estimated(self.view.layer.frame.width/2 - 8+20))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 8, bottom: 20, trailing: 8)

        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]

        return layoutSection
    }

    func createActiveChatSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(self.view.layer.frame.width/2 - 8+20))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 30, leading: 8, bottom: 0, trailing: 8)

        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .estimated(20))
        let layoutSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        return layoutSection
    }

    private func fetchMain() {
        dependencies?.apiService.fetchMain { result in
            switch result {
            case .success(let mainResponse):
                print(mainResponse)
                self.mainResponse = mainResponse

                DispatchQueue.main.async {
                    self.sections = self.makeSections(response: mainResponse)
                    self.createDataSource()
                    self.reloadData()
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchFavourites() {
        dependencies?.apiService.fetchFavourites { result in
            switch result {
            case .success(let favouriteGames):
                print("\n\nFavourites: \(favouriteGames)")
                self.favouriteGames = favouriteGames
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchRecent() {
        dependencies?.apiService.fetchRecent { result in
            switch result {
            case .success(let recentGames):
                print("\n\nRecent: \(recentGames)")
                self.recentGames = recentGames
            case .failure(let error):
                print(error)
            }
        }
    }

    private func logout() {
        dependencies?.authProvider.logout { error in
            guard let error = error else {
                return
            }

            print(error)
        }
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<GameSection, Game>(collectionView: gameCollectionView,
                                cellProvider: { (collectionView, indexPath, game) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(with: GameCollectionViewCell.self, for: indexPath)
            cell.configur(game: game)
            return cell
        })

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in

            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "HeaderCollectionReusableView",
                    for: indexPath) as? HeaderCollectionReusableView else { return nil }
            guard let firstGame = self.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self.dataSource?
                    .snapshot()
                    .sectionIdentifier(containingItem: firstGame) else { return nil }
            if section.title.isEmpty { return nil }

            sectionHeader.sectionName = section.title
            return sectionHeader
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<GameSection, Game>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    func makeSections(response: MainResponse) -> [GameSection] {
        var sections: [GameSection] = []
        for tag in response.tags {
            let tagId = tag.id
            let games = response.games.filter { $0.tags.contains(tagId) == true }

            let section = GameSection(tag: tagId, title: tag.name, items: games)
            sections.append(section)
        }
        return sections.reversed()
    }

    func setupTopBar() {
        topBar.delegate = self
        topBar.showMainTopBar()
    }

}

@available(iOS 13.0, *)
extension MainViewController: AuthDelegate {

    func onLogin() {
        DispatchQueue.main.async {
            self.topBar.showLogOutButton()
        }

        fetchMain()
        fetchRecent()
        fetchFavourites()
    }

    func onLogout() {
        DispatchQueue.main.async {
            self.topBar.showMainTopBar()
        }
    }
}

@available(iOS 13.0, *)
extension MainViewController: FilterDelegate {

    func handleFilter(filteredGames: [Game]) {
        // TODO: Handle empty filtered
        // TODO: Implement filter reset
        isFiltered = true
        self.filteredGames = filteredGames
        print(filteredGames)
    }

}

@available(iOS 13.0, *)
extension MainViewController: FilterButtonDelegate {

    func didTapFilterButton() {
        self.onGoToFilter?(mainResponse)
        print("Filter button pressed")
    }

}

@available(iOS 13.0, *)
extension MainViewController: TopBarDelegate {

    func signUpButtonPressed() {
        self.onGoToRegistration?()
    }

    func signInButtonPressed() {
        self.onGoToLogin?()
    }

    func logOutButtonPressed() {
        logout()
    }

}

// MARK: Collection View Delegate

@available(iOS 13.0, *)
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else { return }

        self.onGoToGame?(cell.game)
    }
}
