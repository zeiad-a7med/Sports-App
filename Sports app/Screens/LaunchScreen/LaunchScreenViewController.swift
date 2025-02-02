//
//  LaunchScreenViewController.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_icon"))  // Replace with your logo's name
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        playAnimation()
    }
        private func setupView() {
        view.backgroundColor = UIColor.systemBackground  // Set the background color
        view.addSubview(logoImageView)

        // Center the logo in the view
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }

    private func playAnimation() {
        // Initial scaling for the logo
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [],
            animations: {
                // Scale the logo back to its original size
                self.logoImageView.transform = .identity
            }
        ) { _ in
            // Fade out the logo after animation
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.logoImageView.alpha = 0
                }
            ) { _ in
                // Transition to the main app screen
                Router.goToHomePage(from: self)
            }
        }
    }

}
