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

    var image: UIImage? {
        get {
            gameImageView.image
        }
        set {
            gameImageView.image = newValue
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
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        gameName = "Game"
    }
    
    func configur(game: Game) {
        self.game = game
        gameName = game.name
    }

}
