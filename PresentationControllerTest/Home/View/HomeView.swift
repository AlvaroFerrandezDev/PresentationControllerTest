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

    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI(){
        navigationItem.title = "Modales"
        button1.layer.cornerRadius = button1.frame.size.width / 2
        button2.layer.cornerRadius = button2.frame.size.width / 2
        button3.layer.cornerRadius = button3.frame.size.width / 2
    }

    @IBAction func buttonPressedShort(_: UIButton) {
        let slideVC = OverlayView(title: "Grasas", description: "Grasas de perfil lípido bajo adaptado a las recomendaciones ADA y EASD.", animatedBool: true)
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        present(slideVC, animated: true, completion: nil)
    }

    @IBAction func buttonPressedMedium(_: UIButton) {
        let slideVC = OverlayView(image: UIImage(named: "nike"), title: "Pescado con arroz", description: "Fuente de proteínas")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        present(slideVC, animated: true, completion: nil)
    }

    @IBAction func buttonPressedLarge(_: UIButton) {
        let slideVC = OverlayView(image: UIImage(named: ""), title: "Pavo con champiñones", description: "Fuente de proteínas. Vitaminas A, D, B, C, B1, B2, niacina, B6, ácido fólico, B12, biotina, ácido pantoténico.", blurBool: true)
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
