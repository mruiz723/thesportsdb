//
//  DetailTeamPresenter.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/22/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import Foundation

struct EventViewData{
    let titleEvent: String
}

protocol DetailTeamView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setEvents(_ events: [EventViewData])
}

class DetailTeamPresenter: BasePresenter{
    
    fileprivate let teamService: TeamService
    weak fileprivate var detailTeamView : DetailTeamView?
    
    typealias View = DetailTeamView
    
    init(teamService: TeamService){
        self.teamService = teamService
    }
    
    func attachView(view: DetailTeamView) {
        detailTeamView = view
    }
    
    func detachView() {
        detailTeamView = nil
    }
    
    func destroy() {
    }
    
    func next5EventsByTeamID(_ idTeam: String) {
        self.detailTeamView?.startLoading()
        teamService.next5EventsByTeamID(idTeam) { [weak self] (success, data) in
            if success {
                self?.detailTeamView?.finishLoading()
                if let events = data["data"] as? [Event] {
                    let mappedEvents = events.map {
                        return EventViewData(titleEvent: "Ronda: \($0.round), \($0.eventName), Fecha: \($0.dateEvent) Hora: \($0.timeEvent) ")
                    }
                    self?.detailTeamView?.setEvents(mappedEvents)
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
