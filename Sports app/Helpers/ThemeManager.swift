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
    static func emptyState(at : UIViewController , message : String ,emptyStateType : EmptyStateType){
        removeEmptyState(from : at)
        let animationView = LottieAnimationView(name: emptyStateType.rawValue)
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = at.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = .clear
        animationView.tag = 404
        at.view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        
        
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 0
        label.sizeToFit()
        label.tag = 405

        label.center = CGPoint(x: animationView.center.x, y: animationView.frame.maxY + 20)
        at.view.addSubview(label)
    }
    static func removeEmptyState(from : UIViewController){
        if let lottieToRemove = from.view.viewWithTag(404),
           let index = from.view.subviews.firstIndex(of: lottieToRemove) {
            from.view.subviews[index].removeFromSuperview()
        }
        if let labelToRemove = from.view.viewWithTag(405),
           let index = from.view.subviews.firstIndex(of: labelToRemove) {
            from.view.subviews[index].removeFromSuperview()
        }
    }
    
    static func addMainBackgroundToTable(at : UITableViewController){
        let gradientView = UIView(frame: at.view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = ThemeManager.gradientColors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        at.tableView.backgroundView = gradientView
    }
    static func addMainBackgroundToView(at : UIViewController)
    {
        let layer = CAGradientLayer()
        layer.frame = at.view.bounds
        layer.colors = ThemeManager.gradientColors
        at.view.layer.insertSublayer(layer, at: 0)
    }
    static func addMainBackgroundToCollectionView(at : UICollectionViewController)
    {
        let gradientView = UIView(frame: at.view.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = ThemeManager.gradientColors
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        at.collectionView.backgroundView = gradientView
    }
    
    

}

enum EmptyStateType : String{
    case emptyData = "emptyData"
    case emptySearch = "emptySearch"
    case noInternetConnection = "noInternetConnection"
}
