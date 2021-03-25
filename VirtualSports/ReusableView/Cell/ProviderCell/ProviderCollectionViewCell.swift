//
//  ProviderCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//
import ImageLoader
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

    var identifier: String?

    // MARK: Cell lifecircle

    override func awakeFromNib() {

        super.awakeFromNib()
        providerView.layer.cornerRadius = 5
        providerView.layer.borderWidth = 1
        providerView.layer.borderColor = #colorLiteral(red: 0.2901595235, green: 0.2902165651, blue: 0.2901602089, alpha: 1)
        providerImageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        identifier = nil
        ImageLoader.shared.cancellAllDownloads()

    }

}

// MARK: Filter Cell Protocol

extension ProviderCollectionViewCell: FilterCell {

    func normal() {
        self.providerView.layer.backgroundColor = nil
    }

    func selected() {
        self.providerView.layer.backgroundColor = #colorLiteral(red: 0.2901595235, green: 0.2902165651, blue: 0.2901602089, alpha: 1)
    }

}
