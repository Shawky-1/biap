//
//  SettingsView.swift
//  Biap
//
//  Created by Bassant on 04/03/2023.
//

import UIKit
import Foundation
import Reachability

class SettingsView: UIViewController {
    
    
    @IBOutlet weak var settingsTable: UITableView!
    
    @IBOutlet weak var imagePlaceHolder: UIImageView!
    
    @IBOutlet weak var logOut: UIButton!
    
    var viewModel: SettingsVM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsVM()
        viewModel?.getSettings()
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        self.navigationController?.navigationBar.tintColor = UIColor.label
        settingsTable.backgroundColor = .quaternarySystemFill
        checkConnection()

        
    }
    
    func checkConnection(){
        let reachability = try! Reachability()
        
        if reachability.connection == .unavailable {
            self.settingsTable.isHidden = true
            self.imagePlaceHolder.isHidden = false
            logOut.isHidden = true
        }
    }
    
    
    @IBAction func didClickLogOut(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "LogOut!", message: "Do you really want to LogOut?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { action in
            UserDefaults.standard.setValue(nil, forKey: "id")
            UserDefaults.standard.setValue(nil, forKey: "email")
            UserDefaults.standard.setValue(nil, forKey: "firstName")
            UserDefaults.standard.setValue(nil, forKey: "lastName")
            UserDefaults.standard.setValue(nil, forKey: "phone")
            RealmManager.shared.deleteAll()
            let login = LoginVC(nibName: "LoginVC", bundle: nil)
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true, completion: nil)
         
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default,handler: { action in
        }))
        
        self.present(alert,animated: true,completion: nil)
    }
    
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTable.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        cell.settingsLabel.text = viewModel?.settingsArr?[indexPath.section]
        //cell.rightLabel.text = "USD"
        //cell.accessoryType = .disclosureIndicator
        
        switch(indexPath.section){
        case 0:
            cell.rightLabel.text = ""
        case 1:
            cell.rightLabel.text = "EGP"
        default:
            cell.rightLabel.text = ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = settingsTable.cellForRow(at: indexPath) as! SettingsCell
        
        switch(indexPath.section){
        case 0:
            let VC = Addresses(nibName: "Addresses", bundle: nil)
            self.navigationController?.pushViewController(VC, animated: true)
        case 1:
            let alert = UIAlertController(title: "Choose currency", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "EGP", style: .default, handler: { (handle) in
                cell.rightLabel.text = "EGP"
            }))
            alert.addAction(UIAlertAction(title: "USD", style: .default, handler: { (handle) in
                cell.rightLabel.text = "USD"
            }))
            self.present(alert, animated: true, completion: nil)
        case 2:
            let VC = Information(nibName: "Information", bundle: nil)
            VC.info = "email: biap@shopify.com\nphone: 01055458855"
            self.present(VC, animated: true)
//            self.present(VC, animated: true) {
//                VC.contentview.superview?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.closeInfo(gesture:))))
//            }
        case 3:
            let VC = Information(nibName: "Information", bundle: nil)
            VC.info = "Biap was created to make shopping a simple task for you, Shop your favourite Brands and discover the latest trends\n\nOur Team:\n Ahmed Shawky\nAbdelrahman Tharwat\nBassant Nagah"
            self.present(VC, animated: true)
        default:
            cell.rightLabel.text = ""
        }
    }
    
//    @objc func closeInfo(gesture: UITapGestureRecognizer) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
        }
    
}
