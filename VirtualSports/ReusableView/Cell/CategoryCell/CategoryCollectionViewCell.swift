//
//  CategoryCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImageView: UIImageView?
    @IBOutlet private weak var categoryLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    lazy var tintLayer: CALayer = {
        let layer = CALayer()
        layer.opacity = 0
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor

        contentView.layer.addSublayer(layer)

        return layer
    }()

    var image: UIImage? {
        get {
            categoryImageView?.image
        }
        set {
            categoryImageView?.image = newValue
            activityIndicator?.stopAnimating()
            UIView.animate(withDuration: 0.4,
                           delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut) {
                self.categoryImageView?.alpha = 1
                self.categoryImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }

    var categoryName: String? {
            get {
                categoryLabel?.text
            }
            set {
                categoryLabel?.text = newValue
            }
        }

    var identifier: String = ""

    // MARK: Cell lifecircle

    override func awakeFromNib() {
        super.awakeFromNib()

        activityIndicator?.startAnimating()
        categoryImageView?.alpha = 0
        categoryImageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        categoryName = ""
        image = nil
        activityIndicator?.startAnimating()
        categoryImageView?.alpha = 0
        categoryImageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tintLayer.frame = contentView.bounds
    }

}

// MARK: Filter Cell Protocol

extension CategoryCollectionViewCell: FilterCell {

    func makeNormal() {
        tintLayer.opacity = 0

        let appearAnimation = CABasicAnimation(keyPath: "opacity")
        appearAnimation.fromValue = 1
        appearAnimation.toValue = 0
        appearAnimation.duration = 0.2
        appearAnimation.fillMode = .forwards

        tintLayer.add(appearAnimation, forKey: "appearAnimation")
    }

    func select() {
        tintLayer.opacity = 1

        let appearAnimation = CABasicAnimation(keyPath: "opacity")
        appearAnimation.fromValue = 0
        appearAnimation.toValue = 1
        appearAnimation.duration = 0.2
        appearAnimation.fillMode = .forwards

        tintLayer.add(appearAnimation, forKey: "appearAnimation")
    }

}
