//
//  ListViewController.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/23.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimerListTableViewCell.nib(), forCellReuseIdentifier: TimerListTableViewCell.identifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        DatabaseManager.shared.getAllTimers(for: tableView)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.shared.timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerListTableViewCell.identifier, for: indexPath) as! TimerListTableViewCell
        cell.configure(with: DatabaseManager.shared.timerArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
