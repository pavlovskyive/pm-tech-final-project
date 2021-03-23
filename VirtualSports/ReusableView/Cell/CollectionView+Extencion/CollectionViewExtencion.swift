//
//  CollectionViewExtencion.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

// MARK: - UIView

extension UIView {

    static var name: String {
        return String(describing: self)
    }
}

// MARK: HELPER

// Using this you can just type
// collectionView.register(SomeCollectionViewCell.self)
// and
// collectionView.dequeueReusableCell(withReuseIdentifier: SomeCollectionViewCell.self,
//                                                    for: indexPath)

// MARK: - UICollectionView

extension UICollectionView {

    func register(type: UICollectionViewCell.Type) {

        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: typeName)
    }

    func register(type: UICollectionReusableView.Type, kind: String) {

        let typeName = type.name
        let nib = UINib(nibName: typeName, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: typeName)
    }

    // It`s normal that we use forecast in this case
    // This is one of the few exceptions
    // swiftlint:disable force_cast

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String,
                                                                       with type: T.Type,
                                                                       for indexPath: IndexPath) -> T {

        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.name, for: indexPath) as! T
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {

        return self.dequeueReusableCell(withReuseIdentifier: type.name, for: indexPath) as! T
    }
}
