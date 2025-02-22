//
//  MainViewController.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Combine
import OSLog
import SwiftUI
import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModel!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Coin>!
    private var contentUnavailableView: UIView!
    private var refreshControl: UIRefreshControl!
    private let searchController = UISearchController(searchResultsController: nil)

    var displayDetails: (Coin) -> Void = { _ in }
    var addToFavourites: (Coin) -> Void = { _ in }

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Coins"

        // Setup Collection View
        setupCollectionView()

        // setup content unavailable
        setupContentUnavailable()

        // Setup the Refresh control
        setupRefreshControl()
        setupSearchController()

        // Register Cell
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "SwiftUICell")

        // Setup Data Source
        configureDataSource()

        // Setup navbar items
        setupNavbarItems(with: viewModel.sorter)

        // listen to view model changes
        bindUI()
    }

    private func bindUI() {
        viewModel.$coins
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                refreshControl.endRefreshing()
                let snapshot = generateSnapshot(from: value)
                dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)

        viewModel.$sorter
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.setupNavbarItems(with: value)
            }
            .store(in: &cancellables)

        viewModel.fetchCoins()
    }

    private func setupContentUnavailable() {
        let controller = UIHostingController(rootView: UnavailableDataView())
        addChild(controller)

        guard let unavailableView = controller.view else { return }
        unavailableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(unavailableView)
        contentUnavailableView = unavailableView

        NSLayoutConstraint.activate([
            unavailableView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            unavailableView.leadingAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.leadingAnchor),
            unavailableView.trailingAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.trailingAnchor),
            unavailableView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.fetchCoins()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // Create a list layout for the collection view
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.showsSeparators = true
        configuration.backgroundColor = .systemBackground
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .normal, title: "Favourite") { [weak self] _, _, handler in
                guard let coin = self?.dataSource.itemIdentifier(for: indexPath) else { return }
                self?.addToFavourites(coin)
                handler(true)
            }
            deleteAction.image = UIImage(systemName: "heart")
            deleteAction.backgroundColor = UIColor(named: "AccentColor")
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    // Configure the data source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Coin>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            // Dequeue a cell and configure it with SwiftUI view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwiftUICell", for: indexPath)

            if let listCell = cell as? UICollectionViewListCell {
                listCell.backgroundConfiguration = .clear()
                listCell.accessories = [.disclosureIndicator()]
                listCell.contentConfiguration = UIHostingConfiguration {
                    CoinOverviewCellView(coin: item)
                }
            }
            return cell
        }
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter by name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    private func setupNavbarItems(with coinSorter: CoinSorter) {
        let barButtonMenu = UIMenu(
            title: "Order list by",
            children: CoinSorter.allCases.compactMap { sorter in
                UIAction(
                    title: sorter.description,
                    image: coinSorter == sorter ? UIImage(systemName: "record.circle") : nil
                ) { [weak self] _ in
                    self?.viewModel.sorter = sorter
                }
            })

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(
                systemName: "ellipsis.circle"
            ),
            target: self,
            action: nil,
            menu: barButtonMenu
        )
    }

    private func generateSnapshot(from coins: [Coin]) -> NSDiffableDataSourceSnapshot<Section, Coin> {
        contentUnavailableView.isHidden = !coins.isEmpty
        var snapshot: NSDiffableDataSourceSnapshot<Section, Coin> = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(coins)
        return snapshot
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == dataSource.snapshot().numberOfItems - 1, viewModel.hasNextPage {
            viewModel.fetchNextPage()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        displayDetails(item)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchTerm = searchController.searchBar.text?.lowercased() ?? ""
    }
}

#Preview {
    let coordinator = MainCoordinator(urlSession: .mock)
    coordinator.navigationController!
}
