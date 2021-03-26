//
//  PasswordComplexityView.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 26.03.2021.
//

import UIKit

final class PasswordComplexityView: UIView {
    
    @IBOutlet weak var view: UIView!

    @IBOutlet var conditionsLabels: [UILabel]!
    @IBOutlet var checkmarks: [UIImageView]!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.shadowRadius = 5.0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7

        layer.cornerRadius = 5

        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }

    private func loadFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView

        guard let view = nibView else { return UIView() }

        return view
    }
    
    func change() {
        checkmarks.forEach {
            $0.tintColor = .red
        }
    }
}
