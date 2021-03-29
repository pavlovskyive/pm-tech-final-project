//
//  ProviderCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//
import ImageLoader
import UIKit

class ProviderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var providerImageView: UIImageView?
    @IBOutlet private weak var providerView: UIView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    lazy var tintLayer: CALayer = {
        let layer = CALayer()
        layer.opacity = 0
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.4).cgColor

        providerView?.layer.addSublayer(layer)

        return layer
    }()

    var image: UIImage? {

        get {
            providerImageView?.image
        }
        set {
            providerImageView?.image = newValue
            activityIndicator?.stopAnimating()
            UIView.animate(withDuration: 0.4,
                           delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut) {
                self.providerImageView?.alpha = 1
                self.providerImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }

    var identifier: String?

    // MARK: Cell lifecircle

    override func awakeFromNib() {

        super.awakeFromNib()
        providerView?.layer.cornerRadius = 5
        providerView?.layer.masksToBounds = true
        providerView?.layer.borderWidth = 1
        providerView?.layer.borderColor = #colorLiteral(red: 0.2901595235, green: 0.2902165651, blue: 0.2901602089, alpha: 1)
        providerImageView?.contentMode = .scaleAspectFit

        activityIndicator?.startAnimating()
        self.providerImageView?.alpha = 0
        self.providerImageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        identifier = nil
        image = nil

        activityIndicator?.startAnimating()
        self.providerImageView?.alpha = 0
        self.providerImageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tintLayer.frame = providerView?.bounds ?? .zero
    }

}

// MARK: Filter Cell Protocol

extension ProviderCollectionViewCell: FilterCell {

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
