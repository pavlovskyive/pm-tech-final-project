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

    private var isActive: Bool = false

    // MARK: Cell lifecircle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        categoryName = "Category"
        isActive = false
    }

}

// MARK: Filter Cell Protocol

extension CategoryCollectionViewCell: FilterCell {

    func didTap() {

        if isActive {

            isActive = false
            self.layer.backgroundColor = nil

        } else {

            isActive = true
            self.layer.backgroundColor = #colorLiteral(red: 0.2901595235, green: 0.2902165651, blue: 0.2901602089, alpha: 1)
        }

    }

}
