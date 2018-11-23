//
//  DetailTeamViewController.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class DetailTeamViewController: UIViewController {
    
    // MARK - IBOutlets
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var foundedLabel: UILabel!
    @IBOutlet weak var aboutUsTextView: UITextView!
    @IBOutlet var eventsLabel: [UILabel]!
    @IBOutlet weak var socialNetworkStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventsStackView: UIStackView!
    
    // MARK - Properties
    var team: Team!
    fileprivate let detailTeamPresenter = DetailTeamPresenter(teamService: TeamService())
    
    init(_ team: Team) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = team.teamName
        setupView()
        detailTeamPresenter.attachView(view: self)
        detailTeamPresenter.next5EventsByTeamID(team.idTeam)
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webVC = segue.destination as? WebViewController {
            webVC.url = sender as? URL
        }
    }
    
    // MARK - IBActions
    
    @IBAction func facebook(_ sender: Any) {
        if let url = team.facebookURL {
           performSegue(withIdentifier: Constants.kWebSegueIdentifier, sender: url)
        }
    }
    
    @IBAction func instragram(_ sender: Any) {
        if let url = team.facebookURL {
            performSegue(withIdentifier: Constants.kWebSegueIdentifier, sender: url)
        }
    }
    
    @IBAction func twitter(_ sender: Any) {
        if let url = team.twitterURL {
            performSegue(withIdentifier: Constants.kWebSegueIdentifier, sender: url)
        }
    }
    
    @IBAction func youtube(_ sender: Any) {
        if let url = team.youtubeURL {
            performSegue(withIdentifier: Constants.kWebSegueIdentifier, sender: url)
        }
    }
    
    @IBAction func myWebsite(_ sender: Any) {
        if let url = team.websiteURL {
            performSegue(withIdentifier: Constants.kWebSegueIdentifier, sender: url)
        }
    }
    
    // MARK - Utils
    func setupView() {
        detailTeamPresenter.imageFromURL(team.badgeImageURL!) { (success, data) in
            if success {
                if let image = data["data"] as? UIImage {
                    self.badgeImageView.image = image
                }
            }
        }
        
        detailTeamPresenter.imageFromURL(team.jerseyImageURL!) { (success, data) in
            if success {
                if let image = data["data"] as? UIImage {
                    self.jerseyImageView.image = image
                }
            }
        }
        foundedLabel.text = team.formedYear
        aboutUsTextView.text = team.teamDescription
        
    }
    
    func updateScrollView() {
        socialNetworkStackView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: eventsStackView.frame.maxY + 10)
    }
}

extension DetailTeamViewController: DetailTeamView {
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
    
    func setEvents(_ events: [EventViewData]) {
        for i in 0...events.count - 1 {
            eventsLabel[i].text = events[i].titleEvent
        }
        
        updateScrollView()
    }
    
    
}
