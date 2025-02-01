//
//  ThemeManager.swift
//  Sports app
//
//  Created by Zeiad on 31/01/2025.
//
import Foundation
import UIKit

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

}
