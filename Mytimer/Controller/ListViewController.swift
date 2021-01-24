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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimer = DatabaseManager.shared.timerArray[indexPath.row]
        UserDefaults.standard.set(selectedTimer.title, forKey: "savedTitle")
        UserDefaults.standard.set(selectedTimer.time, forKey: "savedTime")
        showAlert(title: "お知らせ", message: "\(selectedTimer.title)をセットしました。")
    }
    
    private func showAlert(title: String, message: String ){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        return
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedTimer = DatabaseManager.shared.timerArray[indexPath.row]
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DatabaseManager.shared.deleteTimer(selectedTimer: selectedTimer) { [weak self] (success) in
                if success {
                    self?.showAlert(title: "お知らせ", message: "タイマーを削除しました。")
                    DatabaseManager.shared.timerArray.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                    self?.showAlert(title: "エラー", message: "タイマーを削除できませんでした。")
                }
            }
        }
    }
}
