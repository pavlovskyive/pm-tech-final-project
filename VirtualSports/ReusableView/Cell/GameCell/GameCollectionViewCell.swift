//
//  GameCollectionViewCell.swift
//  VirtualSports
//
//  Created by Вова Благой on 25.03.2021.
//

import UIKit
import APILayer

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    var image: UIImage? {
        get {
            gameImageView.image
        }
        set {
            gameImageView.image = newValue
            activityIndicator?.stopAnimating()
            UIView.animate(withDuration: 0.4,
                           delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut) {
                self.gameImageView.alpha = 1
                self.gameImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }

    var gameName: String? {
            get {
                gameNameLabel.text
            }
            set {
                gameNameLabel.text = newValue
            }
        }

    var identifier: String = ""
    var game: Game?

    // MARK: Cell lifecircle

    override func awakeFromNib() {
        super.awakeFromNib()
        gameImageView.layer.cornerRadius = 5

        activityIndicator?.startAnimating()
        gameImageView.alpha = 0
        gameImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        gameName = "Game"
        image = nil

        activityIndicator?.startAnimating()
        gameImageView.alpha = 0
        gameImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    func configure(game: Game) {
        self.game = game
        gameName = game.name
    }

}
