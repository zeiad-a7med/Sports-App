//
//  LaunchScreenViewController.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import Lottie
import UIKit

class LaunchScreenViewController: UIViewController {

    let animationView = LottieAnimationView(name: "animatedLogo")

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        animationView.loopMode = .loop  // Loop animation
        animationView.play()  // Start animation
        
        
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = ThemeManager.gradientColors
        view.layer.insertSublayer(layer, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.animationCompletedAction()
            self.animationView.stop()
        }
        
    }
    func animationCompletedAction() {
        Router.goToHomePage(from: self)
    }

}
