//
//  PasswordComplexityView.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 26.03.2021.
//

import UIKit

final class PasswordComplexityView: UIView {

    @IBOutlet private weak var view: UIView!

    @IBOutlet private var conditionsLabels: [UILabel]!
    @IBOutlet private var checkmarks: [UIImageView]!

    var passwordLenghtsCondition = false {
        willSet {
            checkCondition(newValue, tag: 0)
        }
    }

    var lowercaseContainsCondition = false {
        willSet {
            checkCondition(newValue, tag: 1)
        }
    }

    var uppercaseContainsCondition = false {
        willSet {
            checkCondition(newValue, tag: 2)
        }
    }

    var numberContainsCondition = false {
        willSet {
            checkCondition(newValue, tag: 3)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: View setup

    private func setupView() {

        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        layer.cornerRadius = 10

        setupShadows()

        addSubview(view)
    }

    private func setupShadows() {
        layer.shadowRadius = 10.0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
    }

    private func loadFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView

        guard let view = nibView else { return UIView() }

        return view
    }

    // MARK: Condtitions

    func resetConditions() {
        checkmarks.forEach {
            $0.tintColor = .lightGray
        }

        conditionsLabels.forEach {
            $0.textColor = .lightGray
        }
    }

    #warning("Refactor this bullshit")
    private func checkCondition(_ isSatisfied: Bool, tag: Int ) {
        if isSatisfied {
            checkmarks.forEach {
                if  $0.tag == tag {
                    $0.tintColor = UIColor(named: "PMGreen")
                }
            }

            conditionsLabels.forEach {
                if  $0.tag == tag {
                    $0.textColor = UIColor(named: "PMGreen")
                }
            }
        } else {
            checkmarks.forEach {
                if  $0.tag == tag {
                    $0.tintColor = .lightGray
                }
            }

            conditionsLabels.forEach {
                if  $0.tag == tag {
                    $0.textColor = .lightGray
                }
            }
        }
    }

}
