//
//  TeamService.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias CompletionHandler = (_ success: Bool, _ jsonResponse: [String : Any]) -> ()

class TeamService {
    
    func teamsByIDLeague(_ idLeague: String, completionHandler:@escaping CompletionHandler) {
        let urlString = Constants.kBaseURL + Constants.kTeamsByIDLeague + "id=\(idLeague)"
        guard let url = URL(string: urlString) else {
            completionHandler(false, ["error": Constants.kBaseURL])
            return
        }
        Alamofire.request(url, method: .get, parameters: nil)
            .validate()
            .responseData { (response) in
                guard response.result.isSuccess else {
                    print("Get teams failed: \(String(describing: response.result.error))")
                        completionHandler(false, ["error": Constants.kErrorFetchingTeams])
                    return
                }
                
                let json = try! JSON(data: response.result.value!, options: .allowFragments)
                let teams:[Team] = self .teamsWithJsonTeams(jsonTeams: json)
                
                completionHandler(true, ["data": teams])
        }
        
    }
    
    func next5EventsByTeamID(_ idTeam: String, completionHandler:@escaping CompletionHandler){
        let urlString = Constants.kBaseURL + Constants.KTeamEventsURL + "id=\(idTeam)"
        guard let url = URL(string: urlString) else {
            completionHandler(false, ["error": Constants.kBaseURL])
            return
        }
        Alamofire.request(url, method: .get, parameters: nil)
            .validate()
            .responseData { (response) in
                guard response.result.isSuccess else {
                    print("Get teams failed: \(String(describing: response.result.error))")
                    completionHandler(false, ["error": Constants.kErrorFetchingTeams])
                    return
                }
                
                let json = try! JSON(data: response.result.value!, options: .allowFragments)
                let events:[Event] = self .eventsWithJsonEvents(jsonEvents: json)
                completionHandler(true, ["data": events])
        }
    }
    
    private func teamsWithJsonTeams(jsonTeams: JSON) -> [Team] {
        var teams = [Team]()
        let jsonTeamsArray = jsonTeams["teams"]
        
        for (_,subJson):(String, JSON) in jsonTeamsArray {
            let team = Team(idTeam: subJson["idTeam"].string ?? "", teamName: subJson["strTeam"].string ?? "", teamDescription: subJson["strStadiumDescription"].string ?? "", stadium: subJson["strStadium"].string ?? "", formedYear: subJson["intFormedYear"].string ?? "", badgeImageURL: URL(string: subJson["strTeamBadge"].string ?? ""), jerseyImageURL: URL(string: subJson["strTeamJersey"].string ?? ""), facebookURL: URL(string: subJson["strFacebook"].string ?? ""), instragramURL: URL(string: subJson["strInstagram"].string ?? ""), twitterURL: URL(string: subJson["strTwitter"].string ?? ""), youtubeURL: URL(string: subJson["strYoutube"].string ?? ""), websiteURL: URL(string: subJson["strWebsite"].string ?? ""))
            teams.append(team)
            
        }
        
        return teams
    }
    
    private func eventsWithJsonEvents(jsonEvents: JSON) -> [Event] {
        var events = [Event]()
        let jsonEventsArray = jsonEvents["events"]
        
        for (_,subJson):(String, JSON) in jsonEventsArray {
            let event = Event(idEvent: subJson["idEvent"].string ?? "", eventName: subJson["strEvent"].string ?? "", filename: subJson["strFilename"].string ?? "", league: subJson["strLeague"].string ?? "", homeTeam: subJson["strHomeTeam"].string ?? "", awayTeam: subJson["strAwayTeam"].string ?? "", round: subJson["intRound"].string ?? "", dateEvent: subJson["dateEvent"].string ?? "", timeEvent: subJson["strTime"].string ?? "")
            events.append(event)

        }
        return events
    }
    
    func imageFromURL(_ URLresourse: URL, completionHandler:@escaping CompletionHandler){
        Alamofire.request(URLresourse).responseImage { response in
            if let image = response.result.value {
                completionHandler(true, ["data": image])
            } 
        }
    }
    
}
