//
//  Constants.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import Foundation

struct Constants {
    
    // URLs
    static let kBaseURL = "https://www.thesportsdb.com/api/v1/json/1/"
    static let kTeamsBySpanishLeagueURL = "search_all_teams.php?l=Spanish%20La%20Liga"
    static let KTeamEventsURL = "eventsnext.php?"
    static let kTeamsByIDLeague = "lookup_all_teams.php?"
    

    
    // Errors
    static let kErrorURL = "Something went wrong!"
    static let kErrorFetchingTeams = "Error while fetching remote teams"
    static let kErrorMalformedData = "Malformed data"
    
    // CellIdentifiers
    static let kTeamCellIdentifier = "TeamCell"
    static let kEventCellIdentifier = "EventCell"

    // PickerLeague
    static let KNumberComponentsLeaguePicker = 1
    static let kDataPickerValues = [ "Spanish La Liga",
                               "English Premier Leaguea",
                               "Italian Serie A"]
    static let kDataPickerKeys = [ "4335" ,
                                    "4328",
                                    "4332"]

    // Navigations
    static let kDetailSegueIdentifier = "DetailTeamSegue"
    static let kWebSegueIdentifier = "WebSegue"

}
