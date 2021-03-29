//
//  LayoutFactory.swift
//  VirtualSports
//
//  Created by Вова Благой on 28.03.2021.
//

import UIKit

@available(iOS 13.0, *)
class LayoutFactory {
    func makeGameCollectionLayout(with dataSourse: [GameSection], view: UIView) -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _ ) ->
            NSCollectionLayoutSection? in

            let data = dataSourse[sectionIndex]

            switch data.tag {
            case "top":
                return self.createTopSection(view: view)
            case "filter":
                return self.createCommonSection(view: view)
            default:
                return self.createCommonSection(view: view)
            }
        }

        return layout
    }

    func createTopSection(view: UIView) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(view.layer.frame.width/2 - 8),
                                                     heightDimension: .estimated(view.layer.frame.width/2 - 8+40))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 8, bottom: 0, trailing: 8)

        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]

        return layoutSection
    }

    func createCommonSection(view: UIView) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(view.layer.frame.width/2 - 8+40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 8, bottom: 8, trailing: 8)

        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]

        return layoutSection
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .estimated(50))
        let layoutSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: -8, bottom: 0, trailing: 0)
        return layoutSection
    }
}
