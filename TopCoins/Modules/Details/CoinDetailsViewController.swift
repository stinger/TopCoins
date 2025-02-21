//
//  CoinPerformanceViewController.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import Combine
import OSLog
import SwiftUI
import UIKit

class CoinDetailsViewController: UIViewController {
    var viewModel: CoinDetailsViewModel!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CoinDetail>!
    private var refreshControl: UIRefreshControl!

    private var cancellables: Set<AnyCancellable> = []

    lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()

    lazy var relativeDayFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.coin.name
        navigationItem.largeTitleDisplayMode = .never

        // setup the collection view
        setupCollectionView()

        // setuo the refresh control
        setupRefreshControl()

        // Register the cell and the header view
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "SwiftUICell")
        collectionView.register(
            ChartHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "PerformanceHistory"
        )

        // Configure data source
        configureDataSource()

        // set up the navbar items
        setupNavbarItems(with: viewModel.chartType)

        // listen to model updates
        bindUI()
    }

    private func bindUI() {
        viewModel.$history
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }

                refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        viewModel.$coin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }

                let snapshot = generateSnapshot(for: viewModel.coin)
                dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)

        viewModel.$chartType
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chartType in
                guard let self else { return }

                setupNavbarItems(with: chartType)
            }
            .store(in: &cancellables)

        viewModel.fetchCoinHistory()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.fetchCoinHistory()
    }

    private func setupNavbarItems(with sorter: ChartType) {
        let barButtonMenu = UIMenu(
            title: "Pick a graph style",
            children: ChartType.allCases.compactMap { chartType in
                UIAction(
                    title: chartType.description,
                    image: chartType == sorter ? UIImage(systemName: "record.circle") : nil
                ) { [weak self] _ in
                    self?.viewModel.chartType = chartType
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

    // Create a list layout for the collection view
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(.zero)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(340))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            section.boundarySupplementaryItems = [header]

            return section
        }
    }

    // Configure the data source
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CoinDetail>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            // Dequeue a cell and configure it with SwiftUI view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwiftUICell", for: indexPath)
            if let listCell = cell as? UICollectionViewListCell {
                listCell.backgroundConfiguration = .clear()
                listCell.contentConfiguration = UIHostingConfiguration {
                    CoinDetailCellView(name: item.name, value: item.value)
                }
            }
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self, kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }

            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "PerformanceHistory",
                for: indexPath
            )

            if let headerView = headerView as? ChartHeaderView {
                headerView.viewModel = viewModel
                headerView.setupChartView()
            }

            return headerView
        }
    }

    private func generateSnapshot(for coin: Coin) -> NSDiffableDataSourceSnapshot<Section, CoinDetail> {
        var snapshot: NSDiffableDataSourceSnapshot<Section, CoinDetail> = .init()
        snapshot.appendSections([.main])

        snapshot.appendItems([
            .init(name: "Name", value: coin.name),
            .init(name: "Symbol", value: coin.symbol),
            .init(name: "Price", value: currencyFormatter.string(from: NSNumber(value: coin.priceDouble)) ?? "n/a"),
            .init(name: "Change", value: coin.change),
            .init(name: "24 hour volume", value: coin.performance),
            .init(name: "Listed", value: relativeDayFormatter.localizedString(for: coin.listedAt, relativeTo: .now)),
        ])
        return snapshot
    }
}

#Preview {
    let controller = CoinDetailsViewController()
    let model = CoinDetailsViewModel(coin: .bitcoin, urlSession: .mock)
    controller.viewModel = model

    return AppNavigationController(rootViewController: controller)
}
