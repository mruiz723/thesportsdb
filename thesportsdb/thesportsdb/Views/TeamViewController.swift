//
//  TeamViewController.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import UIKit
import SVProgressHUD

class TeamViewController: UIViewController {
    
    // MARK - IBOutlets
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var leaguePicker: UIPickerView!
    @IBOutlet weak var leagueToolbar: UIToolbar!
    
    // MARK - Properties
    fileprivate let teamPresenter = TeamPresenter(teamService: TeamService())
    fileprivate var teamsData = [TeamViewData]()
    fileprivate var teamsRaw = [Team]()
    fileprivate var selectedIDLeague: String = Constants.kDataPickerKeys.first!
    
    // MARK - IBActions
    @IBAction func doneLeague(_ sender: Any) {
        leagueToolbar.isHidden = true
        leaguePicker.isHidden = true
        filterTextField.endEditing(true)
        teamPresenter.teamsByIDLeague(selectedIDLeague)
    }

    // MARK - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        teamPresenter.attachView(view: self)
        teamPresenter.teamsByIDLeague(selectedIDLeague)
        filterTextField.delegate = self
    }
    
    // MARK - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailTeamVC = segue.destination as? DetailTeamViewController {
            detailTeamVC.team = sender as? Team
        }
    }
    
    // MARK - Utils
    func setupPicker()  {
        filterTextField.inputView = leaguePicker
        leaguePicker.selectRow(0, inComponent: 1, animated: true)
        filterTextField.text =  Constants.kDataPickerValues[leaguePicker.selectedRow(inComponent: 1)]
        filterTextField.inputAccessoryView = leagueToolbar
        leaguePicker.removeFromSuperview()
        leagueToolbar.removeFromSuperview()
        leaguePicker.delegate = self
    }
}

extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.kTeamCellIdentifier) as? TeamCell {
            let teamViewData = teamsData[indexPath.row]
            
            teamPresenter.imageFromURL(URL(string: teamViewData.badge!)!) { (success, data) in
                if success {
                    if let image = data["data"] as? UIImage {
                        cell.badgeImageView.image = image
                    }
                }
            }
            cell.nameLabel.text = teamViewData.name
            cell.stadiumLabel.text = teamViewData.stadium
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = teamsRaw[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.kDetailSegueIdentifier, sender: team)
    }
    
}

extension TeamViewController: TeamView {
    func teams(_ teams: [Team]) {
        teamsRaw = teams
    }

    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
    
    func setTeams(_ teams: [TeamViewData]) {
        teamsData = teams
        teamTableView?.reloadData()
    }
    
}

extension TeamViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.KNumberComponentsLeaguePicker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.kDataPickerKeys.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.kDataPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterTextField.text = Constants.kDataPickerValues[row]
        selectedIDLeague = Constants.kDataPickerKeys[row]
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        leagueToolbar.isHidden = false
        leaguePicker.isHidden = false
    }
}
