//
//  CharacterListTVC.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 25/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import UIKit

class CharacterListTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.removeExtraLines()
        NetworkService.shared.characters { (list) in
            print("reload")
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = \(NetworkService.shared.names.count)")
        return NetworkService.shared.names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        cell.textLabel?.text = NetworkService.shared.names[indexPath.row]
        return cell
    }

}
