//
//  TeamPresenter.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import Foundation

struct TeamViewData{
    let name: String
    let stadium: String
    let badge: String?
}

protocol TeamView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setTeams(_ teams: [TeamViewData])
}

class TeamPresenter: BasePresenter{
    
    fileprivate let teamService: TeamService
    weak fileprivate var teamView : TeamView?
    
    typealias View = TeamView
    
    init(teamService: TeamService){
        self.teamService = teamService
    }
    
    func attachView(view: TeamView) {
        teamView = view
    }
    
    func detachView() {
        teamView = nil
    }
    
    func destroy() {
    }
    
    func teamsByIDLeague(_ idLeague: String) {
        self.teamView?.startLoading()
        teamService.teamsByIDLeague(idLeague) { [weak self] (success, data) in
            if success {
                self?.teamView?.finishLoading()
                if let teams = data["data"] as? [Team] {
                    let mappedTeams = teams.map {
                        return TeamViewData(name: "\($0.teamName)", stadium: "\($0.stadium)", badge: "\($0.badgeImageURL?.absoluteString ?? "")")
                    }
                    self?.teamView?.setTeams(mappedTeams)
                }
            }
        }
    }
    
    func imageFromURL(_ URL: URL, completionHandler: @escaping CompletionHandler) {
        teamService.imageFromURL(URL) { (success, data) in
            completionHandler(success, data)
        }
    }
    
    
    
}
