//
//  Addresses.swift
//  Biap
//
//  Created by Bassant on 10/03/2023.
//

import UIKit

class Addresses: UIViewController {
    
    
    @IBOutlet weak var addressesTable: UITableView!
    
    var viewModel: AddressesVM?
    var addresses:[Address]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressesVM()
        
        addressesTable.delegate = self
        addressesTable.dataSource = self
        addressesTable.register(UINib(nibName: "SettingsAddressCell", bundle: nil), forCellReuseIdentifier: "SettingsAddressCell")
        self.navigationController?.navigationBar.tintColor = UIColor.label
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel?.getListOfAddresses(url:urls.customerAddresses(customerID: 6869254013233))
        
        viewModel?.bindResultToAddressesView = {[weak self] in
            self?.addresses = self?.viewModel?.listOfaddresses.addresses
            self?.addressesTable.reloadData()
        }
    }
    
    @IBAction func AddNewAddress(_ sender: Any) {
        let VC = NewAddress(nibName: "NewAddress", bundle: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension Addresses: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressesTable.dequeueReusableCell(withIdentifier: "SettingsAddressCell", for: indexPath) as! SettingsAddressCell
        
        cell.country.text = addresses?[indexPath.section].country
        cell.city.text = addresses?[indexPath.section].city
        cell.address.text = addresses?[indexPath.section].address1
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
}
