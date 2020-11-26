//
//  HomeView.swift
//  PresentationControllerTest
//
//  Created by sopra on 25/11/20.
//  Copyright © 2020 ÁF. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    var presenter: HomePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Modales"
    }

    @IBAction func buttonPressedShort(_: UIButton) {
        let slideVC = OverlayView(title: "Título de ejemplo", description: "Descripción de ejemplo")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        present(slideVC, animated: true, completion: nil)
    }

    @IBAction func buttonPressedMedium(_: UIButton) {
        let slideVC = OverlayView(image: UIImage(named: "nike"), title: "Título de ejemplo", description: "Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        present(slideVC, animated: true, completion: nil)
    }

    @IBAction func buttonPressedLarge(_: UIButton) {
        let slideVC = OverlayView(title: "Título de ejemplo", description: "Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo  Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo  Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo  Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo Descripción de ejemplo")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        present(slideVC, animated: true, completion: nil)
    }
}

extension HomeView: HomeViewProtocol {}

extension HomeView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
