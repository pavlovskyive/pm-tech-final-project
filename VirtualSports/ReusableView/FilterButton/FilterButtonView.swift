//
//  FilterButtonView.swift
//  VirtualSports
//
//  Created by Вова Благой on 22.03.2021.
//

import UIKit

@objc protocol FilterButtonDelegate: AnyObject {
    @objc func didTapFilterButton()
}

@IBDesignable
final class FilterButtonView: UIView {
    @IBOutlet private weak var filterCountLabel: UILabel!
    @IBOutlet private weak var filterButton: UIButton!

    @IBAction func didTapFilterButton(_ sender: UIButton) {
        delegate?.didTapFilterButton()
    }

    var filterCount: Int? {
        get {
            Int(filterCountLabel.text ?? "0")
        }
        set {
            newValue == 0 ? (filterCountLabel.isHidden = true) : (filterCountLabel.isHidden = false)
            filterCountLabel.text = newValue?.description
        }
    }

    var filterCountIsHidden = true {
        willSet {
            newValue ? (filterCountLabel.isHidden = true) : (filterCountLabel.isHidden = false)
        }
    }

    weak var delegate: FilterButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.configureCountLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
        self.configureCountLabel()
    }

    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "FilterButtonView") else {
            return
        }
        view.frame = self.bounds
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = #colorLiteral(red: 0.6156154275, green: 0.6157261729, blue: 0.6156166196, alpha: 1)
        self.addSubview(view)

    }

    private func configureCountLabel() {
        filterCountLabel.layer.cornerRadius = filterCountLabel.frame.height / 2
        filterCountLabel.isHidden = filterCountIsHidden
    }

}
