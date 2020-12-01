//
//  CustomPresentationController.swift
//  CustomPresentationController
//
//  Created by sopra on 25/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

struct CustomPresentationControllerConstants {
    static let purpleColorBackground = UIColor(red: CGFloat(78.0 / 255.0), green: CGFloat(77.0 / 255.0), blue: CGFloat(128.0 / 255.0), alpha: CGFloat(0.4))
}

class CustomPresentationController: UIPresentationController {
    // MARK: - Blur layer
    var withBlurEffect: Bool = false
    var blurEffectView: UIVisualEffectView!
    var blurEffect: UIBlurEffect?
    // MARK: - Tap dismiss
    var tapGestureRecognizer = UITapGestureRecognizer()
    // MARK: - Background view
    var backgroundView = UIView()

    // MARK: - Lyfecicle methods
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        guard let presentedView = presentedViewController as? CustomModalView else { return }
        withBlurEffect = presentedView.withBlurEffectAux

        if presentedView.withBlurEffectAux {
            blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.addGestureRecognizer(tapGestureRecognizer)
            blurEffectView.isUserInteractionEnabled = true
        }

        backgroundView.isUserInteractionEnabled = false
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = CustomPresentationControllerConstants.purpleColorBackground

        presentedView.buttonActionHandler = dismissControllerHandler
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.layer.cornerRadius = 14.0
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView?.bounds ?? CGRect()
        if withBlurEffect {
            blurEffectView.frame = containerView?.bounds ?? CGRect()
        }
    }

    // MARK: - Frame's variables
    override var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = self.containerView {
            guard let presentedView = self.presentedView else { return CGRect() }
            return CGRect(origin: CGPoint(x: 0, y: containerView.frame.maxY - presentedView.frame.height),
                          size: CGSize(width: containerView.frame.width, height: presentedView.frame.height))
        }
        return CGRect()
    }

    // MARK: - Transition methods
    override func presentationTransitionWillBegin() {
        if withBlurEffect {
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
        if withBlurEffect {
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

    // MARK: - Dismiss methods
    @objc fileprivate func dismissController() {
        dismissControllerHandler()
    }

    fileprivate func dismissControllerHandler() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
