//
//  LocalNotificationManager.swift
//  Sports app
//
//  Created by Zeiad on 03/02/2025.
//

import Foundation
import UIKit

class LocalNotificationManager {
    static let instance = LocalNotificationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()
    private init() {
        userNotificationCenter.requestAuthorization(options: [
            .alert, .sound, .badge,
        ]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    func addNotification(
        title: String, body: String, badgeNumber: Int,
        date: Date?, league: League, sportType: SportType
    ) {
        //2-content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.badge = NSNumber(value: badgeNumber)
        // Convert `league` and `sportType` to Strings or Dictionaries
        let leagueData = try? JSONEncoder().encode(league)
        let sportTypeData = try? JSONEncoder().encode(sportType)

        notificationContent.userInfo = [
            "navigateTo": RouteString.FixturesPage,
            "league": leagueData != nil
                ? String(data: leagueData!, encoding: .utf8) ?? "" : "",
            "sportType": sportTypeData != nil
                ? String(data: sportTypeData!, encoding: .utf8) ?? "" : "",
            "content": body,
            "title": title,
        ]

        var trigger: UNNotificationTrigger!

        guard let date = date else {
            print("Error: Date is nil for Calendar trigger")
            return
        }
        // Convert Date to DateComponents
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second], from: date)
        // Create UNCalendarNotificationTrigger
        trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "test", content: notificationContent, trigger: trigger)
        userNotificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }

        }
    }
}
