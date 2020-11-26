//
//  OverlayView.swift
//  PresentationControllerTest
//
//  Created by sopra on 25/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

class OverlayView: UIViewController {
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    public var buttonActionHandler: (() -> Void)?

    private var imageIcon = UIImage(systemName: "info.cirlce")
    private var titleText: String = ""
    private var descriptionText: String = ""
    public var blurBool: Bool = false
    public var animatedBool: Bool = false

    init(image: UIImage? = UIImage(systemName: "info.circle"), title: String, description: String, blurBool: Bool? = false, animatedBool: Bool? = false) {
        imageIcon = image ?? UIImage()
        titleText = title
        descriptionText = description
        self.blurBool = blurBool ?? false
        self.animatedBool = animatedBool ?? false
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        if !animatedBool {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
            view.addGestureRecognizer(panGesture)
        }
    }

    @IBAction func buttonActionPressed(_: UIButton) {
        if let buttonAction = buttonActionHandler {
            buttonAction()
        }
    }

    func setupUI() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        iconImageView.image = imageIcon
        closeButton.setTitle("X", for: .normal)
    }

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = view.frame.origin
        }
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
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
