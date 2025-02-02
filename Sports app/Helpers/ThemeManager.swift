//
//  ThemeManager.swift
//  Sports app
//
//  Created by Zeiad on 31/01/2025.
//
import Foundation
import UIKit
import Lottie
class ThemeManager {
    static let greenColor = UIColor(
        red: 20 / 255, green: 152 / 255, blue: 133 / 255, alpha: 1
    ).cgColor
    static let blackColor = UIColor.black.cgColor
    static let grayColor = UIColor.gray.cgColor
    static let whiteColor = UIColor.white.cgColor
    static let gradientColors: [CGColor] = [greenColor, blackColor]
    static let gradientColorsForCard: [CGColor] = [blackColor, greenColor]

    static func getEventStatusColor(status: EventStatus?) -> CGColor {
        if(status == nil) {return UIColor.gray.cgColor}
        switch status {
        case .notStarted:
            return UIColor.gray.cgColor
        case .live:
            return UIColor.red.cgColor
        case .finished:
            return UIColor.green.cgColor
        default:
            return UIColor.gray.cgColor
        }
    }
    static func emptyState(at : UIViewController){
        let animationView = LottieAnimationView(name: "emptyState")
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = at.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        at.view.addSubview(animationView)
        animationView.loopMode = .loop  // Loop animation
        animationView.play()  // Start animation
        
        
        
        let layer = CAGradientLayer()
        layer.frame = at.view.bounds
        layer.colors = ThemeManager.gradientColors
        at.view.layer.insertSublayer(layer, at: 100)
//
//        let emptyStateView = UIView()
//        emptyStateView.backgroundColor = .lightGray
//
//        // Create and configure the label
//        let label = UILabel()
//        label.text = "No Data Available"
//        label.textAlignment = .center
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        emptyStateView.addSubview(label)
//        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
//        at.view.addSubview(emptyStateView)
//        NSLayoutConstraint.activate([
//            emptyStateView.centerXAnchor.constraint(equalTo: at.view.centerXAnchor),
//            emptyStateView.centerYAnchor.constraint(equalTo: at.view.centerYAnchor),
//            emptyStateView.widthAnchor.constraint(equalTo: at.view.widthAnchor, multiplier: 0.8),
//            emptyStateView.heightAnchor.constraint(equalToConstant: 100)
//        ])
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
//        ])
    }

}
