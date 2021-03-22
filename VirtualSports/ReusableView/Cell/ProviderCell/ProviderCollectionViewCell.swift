//
//  ProviderCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

class ProviderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var providerImageView: UIImageView!
    @IBOutlet private weak var providerView: UIView!

    var image: UIImage? {
        get {
            providerImageView.image
        }
        set {
            providerImageView.image = newValue
        }
    }

    var identifier: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        providerView.layer.cornerRadius = 5
        providerView.layer.borderWidth = 1
        providerView.layer.borderColor = #colorLiteral(red: 0.6156154275, green: 0.6157261729, blue: 0.6156166196, alpha: 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        identifier = nil
    }

}
