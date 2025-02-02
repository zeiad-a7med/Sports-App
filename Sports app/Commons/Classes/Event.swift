//
//  Event.swift
//  Sports app
//
//  Created by Zeiad on 28/01/2025.
//
import Foundation

struct Event: Codable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let homeTeamKey: Int?
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let eventHalftimeResult: String?
    let eventFinalResult: String?
    let eventFtResult: String?
    let eventPenaltyResult: String?
    let eventStatus: String?
    let countryName: String?
    let leagueName: String?
    let leagueKey: Int?
    let leagueRound: String?
    let leagueSeason: String?
    let eventLive: String?
    let eventStadium: String?
    let eventReferee: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventCountryKey: Int?
    let leagueLogo: String?
    let countryLogo: String?
    let eventHomeFormation: String?
    let eventAwayFormation: String?
    let fkStageKey: Int?
    let stageName: String?
    let leagueGroup: String?
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    let goalscorers: [Goalscorer]?
    //    let substitutes: [Substitute]?
    let cards: [Card]?
    //    let vars: Vars?
    //    let lineups: Lineups?
    let statistics: [Statistic]?
    //    let playerStats: PlayerStats?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventCountryKey = "event_country_key"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case eventHomeFormation = "event_home_formation"
        case eventAwayFormation = "event_away_formation"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case leagueGroup = "league_group"
        case goalscorers = "goalscorers"
        case cards = "cards"
        case statistics = "statistics"
    }

    func getStatus() -> EventStatus {

        let currentDate = Date()
        let dateFormatter = DateFormatter()

        // Set date format for eventDate (assuming format: "yyyy-MM-dd")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let datePart = eventDate,
            let parsedDate = dateFormatter.date(from: datePart)
        else {
            return .notStarted
        }

        // Set time format for eventTime (assuming format: "HH:mm")
        dateFormatter.dateFormat = "HH:mm"
        guard let timePart = eventTime,
            let parsedTime = dateFormatter.date(from: timePart)
        else {
            return .notStarted
        }

        // Combine eventDate and eventTime into a single Date object
        let calendar = Calendar.current
        let eventDateTime =
            calendar.date(
                bySettingHour: calendar.component(.hour, from: parsedTime),
                minute: calendar.component(.minute, from: parsedTime),
                second: 0,
                of: parsedDate) ?? parsedDate

        // Compare with current date
        if eventDateTime < currentDate {
            return .finished
        } else if eventLive == "1"
            || calendar.isDate(
                eventDateTime, equalTo: currentDate, toGranularity: .minute)
        {
            return .live
        } else {
            return .notStarted
        }
    }

}

enum EventStatus: String {
    case notStarted = "Not Started"
    case live = "Live"
    case finished = "Finished"
}
