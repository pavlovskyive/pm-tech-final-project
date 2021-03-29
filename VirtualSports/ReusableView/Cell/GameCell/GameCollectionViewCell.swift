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
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        gameName = "Game"
        image = nil

        activityIndicator?.startAnimating()
    }

    func configure(game: Game) {
        self.game = game
        gameName = game.name
    }

}
