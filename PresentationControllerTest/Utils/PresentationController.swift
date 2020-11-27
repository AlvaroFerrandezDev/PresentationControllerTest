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

    var titleLabel = UILabel()
    var descriptionLabel = UILabel()

    var diffTitle = CGFloat(0)
    var diffDescription = CGFloat(0)

    var blurEffect: UIBlurEffect?
    var blurEffectBool: Bool = false

    let purpleColorBackground = UIColor(red: CGFloat(78.0 / 255.0), green: CGFloat(77.0 / 255.0), blue: CGFloat(128.0 / 255.0), alpha: CGFloat(0.4))
    var backgroundView = UIView()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        guard let presentedView = presentedViewController as? OverlayView else { return }

        if presentedView.blurBoolAux {
            blurEffectBool = true
            blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.addGestureRecognizer(tapGestureRecognizer)
            blurEffectView.isUserInteractionEnabled = true
        }

        backgroundView.isUserInteractionEnabled = false
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = purpleColorBackground

        presentedView.buttonActionHandler = dismissControllerHandler
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = self.containerView {
            guard let presentedView = self.presentedView else { return CGRect() }
            return CGRect(origin: CGPoint(x: 0, y: containerView.frame.maxY - presentedView.frame.height),
                          size: CGSize(width: containerView.frame.width, height: presentedView.frame.height))
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

        backgroundView.alpha = 0
        containerView?.addSubview(backgroundView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        }, completion: { _ in })
    }

    override func dismissalTransitionWillBegin() {
        if blurEffectBool {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.blurEffectView.alpha = 0
            }, completion: { _ in
                self.blurEffectView.removeFromSuperview()
            })
        }

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
        })
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.layer.cornerRadius = 14.0
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView?.bounds ?? CGRect()
        if blurEffectBool {
            blurEffectView.frame = containerView?.bounds ?? CGRect()
        }
    }

    @objc func dismissController() {
        dismissControllerHandler()
    }

    func dismissControllerHandler() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
