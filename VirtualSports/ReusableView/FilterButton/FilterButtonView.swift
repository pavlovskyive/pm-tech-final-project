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

    @IBOutlet weak var filterButton: UIButton!

    @IBAction func didTapFilterButton(_ sender: Any) {
        delegate?.didTapFilterButton()
    }

    weak var delegate: FilterButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
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

}
