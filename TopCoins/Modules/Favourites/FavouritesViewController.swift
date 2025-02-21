//
//  FavouritesViewController.swift
//  TopCoins
//
//  Created by Ilian Konchev on 20.02.25.
//

import Combine
import Foundation
import OSLog
import SwiftUI
import UIKit

final class FavouritesViewController: UIViewController {
    var viewModel: FavouritesViewModel!
    private var collectionView: UICollectionView!
    private var contentUnavailableView: UIView!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Coin>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Coin>!

    var displayDetails: (Coin) -> Void = { _ in }

    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favourites"
        // Setup Collection View
        setupCollectionView()

        // setup content unavailable
        setupContentUnavailable()

        // Register Cell
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "SwiftUICell")

        // Setup Data Source
        configureDataSource()

        // listen to model changes
        bindUI()
    }

    private func bindUI() {
        // bindToViewModel
        cancellable = viewModel.$favourites
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }

                let snapshot = generateSnapshot(from: value)
                dataSource.apply(snapshot, animatingDifferences: true)
            }

        viewModel.loadFavourites()
    }

    private func setupContentUnavailable() {
        let controller = UIHostingController(rootView: UnavailableFavouritesView())
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

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
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
            let deleteAction = UIContextualAction(style: .destructive, title: "Unfavourite") {
                [weak self] _, _, handler in
                guard let coin = self?.dataSource.itemIdentifier(for: indexPath) else { return }
                self?.viewModel.removeFromFavourite(coin: coin)
                handler(true)
            }
            deleteAction.image = UIImage(systemName: "heart")
            deleteAction.backgroundColor = UIColor.red
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
                listCell.accessories = [.disclosureIndicator()]
                listCell.backgroundConfiguration = .clear()
                listCell.contentConfiguration = UIHostingConfiguration {
                    CoinOverviewView(coin: item)
                }
            }
            return cell
        }
    }

    private func generateSnapshot(from coins: Set<Coin>) -> NSDiffableDataSourceSnapshot<Section, Coin> {
        contentUnavailableView.isHidden = !coins.isEmpty
        var snapshot: NSDiffableDataSourceSnapshot<Section, Coin> = .init()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(coins))

        return snapshot
    }
}

extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        displayDetails(item)
    }
}

#Preview {
    let controller = FavouritesViewController()
    let model = FavouritesViewModel(storage: .mock)
    // model.addToFavourite(coin: .bitcoin)
    controller.viewModel = model

    return AppNavigationController(rootViewController: controller)
}
