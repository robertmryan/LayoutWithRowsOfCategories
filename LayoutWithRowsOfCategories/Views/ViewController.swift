//
//  ViewController.swift
//
//  Created by Robert Ryan on 12/1/24.
//

import UIKit

class ViewController: UICollectionViewController {

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    var friends: [Item] = [.person("Michael Todd"), .person("Philippa Perry"), .person("Lori A. Anderson")]
    var interests: [[Item]] = [
        [.interest("Self-Growth"), .interest("Creative Thinking"), .interest("Mindfulness and Well-being"), .interest("Critical Thinking")],
        [.interest("Relationships & Family"), .interest("Education & Learning")],
        [.interest("Business & Finance"), .interest("Sales & Marketing")],
        [.interest("Religion & Faith"), .interest("Psychology"), .interest("Mental Health"), .interest("Philosophy")],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureDataSource()
        updateSnapshot()
    }
}

// MARK: - Data source

private extension ViewController {
    func configureDataSource() {
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .person(let name):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
                cell.nameLabel.text = name
                return cell

            case .interest(let interest):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
                cell.interestLabel.text = interest
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderView.reuseIdentifier,
                    for: indexPath
                ) as! HeaderView

                header.label.text = indexPath.section == 0 ? "Friends" : "More areas you can improve"
                return header
            default:
                fatalError("Unexpected element kind: \(kind)")
            }
        }

        collectionView.dataSource = dataSource
    }

    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.friends])
        snapshot.appendItems(friends)

        for (index, interests) in interests.enumerated() {
            snapshot.appendSections([.areasOfImprovement(index)])
            snapshot.appendItems(interests)
        }

        dataSource.apply(snapshot)
    }
}

// MARK: - Layout

private extension ViewController {
    func configureLayout() {
        collectionView.collectionViewLayout = createLayout()
    }

    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self else { return nil }

            let section = dataSource.snapshot().sectionIdentifiers[sectionIndex]

            let itemSize = switch section {
            case .friends: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            case .areasOfImprovement: NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .fractionalHeight(1))
            }
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = switch section {
            case .friends: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(300))
            case .areasOfImprovement: NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(44))
            }

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 10
            layoutSection.orthogonalScrollingBehavior = .continuous
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

            if section == .friends || section == .areasOfImprovement(0) {
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                layoutSection.boundarySupplementaryItems = [sectionHeader]
            }

            return layoutSection
        }
    }
}

// MARK: - Enumerations

enum Section: Hashable {
    case friends
    case areasOfImprovement(Int)
}

enum Item: Hashable {
    case person(String)
    case interest(String)
}
