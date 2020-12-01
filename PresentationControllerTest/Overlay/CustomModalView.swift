//
//  CustomModalView.swift
//  PresentationControllerTest
//
//  Created by sopra on 25/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

struct CustomModalViewConstants {
    static let purpleColor = UIColor(red: CGFloat(78.0 / 255.0), green: CGFloat(77.0 / 255.0), blue: CGFloat(128.0 / 255.0), alpha: CGFloat(1.0))
}

final class CustomModalView: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Frame's setup variables
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    // MARK: - Private variables
    private var titleText: String = ""
    private var descriptionText: String = ""

    // MARK: - Public variables
    public var withBlurEffectAux: Bool = false
    public var withAnimationAux: Bool = false

    public var buttonActionHandler: (() -> Void)?

    // MARK: - Init method
    init(title: String, description: String, withBlurEffect: Bool? = false, withAnimation: Bool? = false) {
        titleText = title
        descriptionText = description
        withBlurEffectAux = withBlurEffect ?? false
        withAnimationAux = withAnimation ?? false
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lyfecicle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGestures()
    }

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = view.frame.origin
        }
    }

    // MARK: - Private methods
    fileprivate func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText

        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        titleLabel.textColor = CustomModalViewConstants.purpleColor
        descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        descriptionLabel.textColor = CustomModalViewConstants.purpleColor

        let closeButtonImage = (UIImage(named: "closeButton") ?? UIImage()).image(withTintColor: .systemGray)
        closeButton.setImage(closeButtonImage, for: .normal)
    }

    @IBAction fileprivate func buttonActionPressed(_: UIButton) {
        if let buttonAction = buttonActionHandler {
            buttonAction()
        }
    }

    fileprivate func setupGestures() {
        if withAnimationAux {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
            view.addGestureRecognizer(panGesture)
        }
    }

    @objc fileprivate func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        guard translation.y >= 0 else { return }

        view.frame.origin = CGPoint(x: 0, y: pointOrigin!.y + translation.y)

        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
