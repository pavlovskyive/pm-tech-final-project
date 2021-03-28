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

    // MARK: Properties

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

    // MARK: Lifecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStatusBar(backgroundColor: .black)
        filterButtonView.delegate = self
        setupTopBar()
        checkNetworkConnectionState(connectionState)

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        dependencies?.authProvider.unsubscribe(self)
    }

    // MARK: Setup Metods

    func setupTopBar() {
        topBar.delegate = self
        topBar.showMainTopBar()
    }

    func makeSections() {

        guard let response = mainResponse else { return }

        sections = []

        if filteredGames != [] {
            let filterSection = GameSection(tag: "filtr", title: "Фильтр", items: filteredGames)
            sections.append(filterSection)
            return
        }

        let topGames = response.games.filter { $0.tags.contains("top") == true }
        let topSections = GameSection(tag: "top", title: "Top", items: topGames)
        sections.append(topSections)

        if !favouriteGames.isEmpty {
                let sectionFavourite = GameSection(tag: "favourite", title: "Favourite", items: favouriteGames)
                sections.append(sectionFavourite)
        }

        if !recentGames.isEmpty {
                let sectionFavourite = GameSection(tag: "recent", title: "Recent", items: recentGames)
                sections.append(sectionFavourite)
        }

        let allGames = response.games
        let allGamesSections = GameSection(tag: "all", title: "All Games", items: allGames)
        sections.append(allGamesSections)

    }

    // MARK: Network

    private func checkNetworkConnectionState(_ state: ConnectionState) {
        switch state {
        case .connected:
        dependencies?.authProvider.subscribe(self)
            fetchMain()

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

    private func fetchMain() {
        dependencies?.apiService.fetchMain { result in
            switch result {
            case .success(let mainResponse):
                print(mainResponse)
                self.mainResponse = mainResponse
                self.makeSections()

                DispatchQueue.main.async {
                    self.configureCollectionView()
                    self.gameCollectionView.reloadData()
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
                self.makeSections()

                    DispatchQueue.main.async {
                        self.gameCollectionView.reloadData()
                    }

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
                self.makeSections()

                    DispatchQueue.main.async {
                        self.gameCollectionView.reloadData()
                    }

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

    func configureCollectionView() {
        self.gameCollectionView.collectionViewLayout = LayoutFactory()
            .makeGameCollectionLayout(with: sections, view: self.view)
        self.gameCollectionView.dataSource = self
        self.gameCollectionView.delegate = self
        self.gameCollectionView.register(type: GameCollectionViewCell.self)
        self.gameCollectionView.register(type: HeaderCollectionReusableView.self,
                                      kind: UICollectionView.elementKindSectionHeader)
    }

}

// MARK: Auth Delegate

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

// MARK: Filter Delegate

@available(iOS 13.0, *)
extension MainViewController: FilterDelegate {

    func handleFilter(filteredGames: [Game]) {
        isFiltered = true
        self.filteredGames = filteredGames
        self.makeSections()
        self.gameCollectionView.reloadData()
        print(filteredGames)
    }

}

// MARK: Filter Button Delegate

@available(iOS 13.0, *)
extension MainViewController: FilterButtonDelegate {

    func didTapFilterButton() {
        self.onGoToFilter?(mainResponse)
    }

}

// MARK: Top Bar Delegate

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

// MARK: Collection View Data Source

@available(iOS 13.0, *)
extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: GameCollectionViewCell.self, for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? GameCollectionViewCell else { return }

        cell.configur(game: sections[indexPath.section].items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let kindView = UICollectionView.elementKindSectionHeader

        if kind == kindView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kindView,
                                                                         with: HeaderCollectionReusableView.self,
                                                                         for: indexPath)

            header.sectionName = sections[indexPath.section].title

            return header
        }

        return .init()
    }

}
