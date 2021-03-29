//
//  LayoutFactory.swift
//  VirtualSports
//
//  Created by Вова Благой on 28.03.2021.
//

import UIKit

enum SectionType {
    case top
    case common
}

@available(iOS 13.0, *)
class LayoutFactory {

    func makeGameCollectionLayout(with dataSourse: [GameSection]) -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, enviroment ) ->
            NSCollectionLayoutSection? in

            let data = dataSourse[sectionIndex]
            let width = enviroment.container.contentSize.width

            switch data.tag {
            case "top":
                return self.createTopSection(width: width)
            default:
                return self.createCommonSection(width: width)
            }
        }

        return layout
    }

    private func createTopSection(width: CGFloat) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(width/2 - 8),
                                                     heightDimension: .estimated(width / 2 + 30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 8, bottom: 0, trailing: 8)

        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createCommonSection(width: CGFloat) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(width / 2 + 30))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 8, bottom: 8, trailing: 8)

        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: -8, bottom: 0, trailing: 0)

        return header
    }

}
