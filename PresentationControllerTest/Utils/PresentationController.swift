//
//  PresentationController.swift
//  PresentationControllerTest
//
//  Created by sopra on 25/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    var blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer = UITapGestureRecognizer()

    var firstTime = true

    var diffTitle = CGFloat(0)
    var diffDescription = CGFloat(0)

    var blurEffect: UIBlurEffect?
    var blurEffectBool: Bool = false

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        guard let presentedView = presentedViewController as? OverlayView else { return }

        if presentedView.blurBool {
            blurEffectBool = true
            blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.addGestureRecognizer(tapGestureRecognizer)
            blurEffectView.isUserInteractionEnabled = true
        }

        presentedView.buttonActionHandler = dismissControllerHandler
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = self.containerView {
            guard let titleLabel = presentedView?.subviews[2] as? UILabel else { return CGRect() }
            guard let descriptionLabel = presentedView?.subviews[3] as? UILabel else { return CGRect() }
            guard let presentedView = self.presentedView else { return CGRect() }

            if firstTime {
                let oldHeightTitle = titleLabel.frame.height
                let oldHeightDescription = descriptionLabel.frame.height
                titleLabel.layoutIfNeeded()
                descriptionLabel.layoutIfNeeded()
                let newHeightTitle = titleLabel.frame.height
                let newHeightDescription = descriptionLabel.frame.height

                diffTitle = newHeightTitle - oldHeightTitle
                diffDescription = newHeightDescription - oldHeightDescription

                firstTime = false
            }

            let heightPresentedView = presentedView.frame.height + diffTitle + diffDescription

            return CGRect(origin: CGPoint(x: 0, y: containerView.frame.maxY - heightPresentedView),
                          size: CGSize(width: containerView.frame.width, height: heightPresentedView))
        }
        return CGRect()
    }

    override func presentationTransitionWillBegin() {
        if blurEffectBool {
            blurEffectView.alpha = 0
            containerView?.addSubview(blurEffectView)
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.blurEffectView.alpha = 0.7
            }, completion: { _ in })
        }
    }

    override func dismissalTransitionWillBegin() {
        if blurEffectBool {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.blurEffectView.alpha = 0
            }, completion: { _ in
                self.blurEffectView.removeFromSuperview()
            })
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        if blurEffectBool {
            blurEffectView.frame = containerView!.bounds
        }
    }

    override func presentationTransitionDidEnd(_: Bool) {
        guard let presentedView = self.presentedView else { return }

        presentedView.updateConstraintsIfNeeded()
        presentedView.layoutIfNeeded()
    }

    @objc func dismissController() {
        dismissControllerHandler()
    }

    func dismissControllerHandler() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

