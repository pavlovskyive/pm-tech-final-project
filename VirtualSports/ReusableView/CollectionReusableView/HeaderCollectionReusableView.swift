//
//  HeaderCollectionReusableView.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var sectionLabel: UILabel!

    var sectionName: String? {
        get {
            sectionLabel.text
        }
        set {
            sectionLabel.text = newValue
        }
    }

    // MARK: Header lifecircle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        sectionName = nil
    }

}
