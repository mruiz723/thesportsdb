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
    @IBOutlet weak var socialNetworkStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var eventsStackView: UIStackView!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var eventPageControl: UIPageControl!
    
    
    // MARK - Properties
    var team: Team!
    fileprivate let detailTeamPresenter = DetailTeamPresenter(teamService: TeamService())
    var events =  [EventViewData]()
 
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
    
  
    @IBAction func eventPageControl(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(row: currentPage, section: 0)
        eventCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
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
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: eventsStackView.frame.maxY + 10)
    }
}

extension DetailTeamViewController: DetailTeamView {
    // MARK: - DetailTeamView
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
    
    func setEvents(_ events: [EventViewData]) {
        self.events = events
        eventCollectionView.reloadData()
        updateScrollView()
    }
}

extension DetailTeamViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.kEventCellIdentifier , for: indexPath) as? EventCell {
            let event = events[indexPath.row]
            cell.roundLabel.text = event.round
            cell.titleEventLabel.text = event.titleEvent
            cell.dateLabel.text = event.date
            cell.timeLabel.text = event.time
            return cell
        }
        
        return EventCell()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thisWidth = CGFloat(collectionView.frame.width)
        return CGSize(width: thisWidth, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        eventPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    

 
}
