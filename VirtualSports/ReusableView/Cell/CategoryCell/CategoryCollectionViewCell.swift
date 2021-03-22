//
//  CategoryCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImageView: UIImageView!

    @IBOutlet private weak var categoryLabel: UILabel!

    var image: UIImage? {
        get {
            categoryImageView.image
        }
        set {
            categoryImageView.image = newValue
        }
    }

    var categoryName: String? {
            get {
                categoryLabel.text
            }
            set {
                categoryLabel.text = newValue
            }
        }

    // MARK: Cell lifecircle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        categoryName = nil
    }

}
