//
//  SettingViewController.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var dataList: [String] = []
    var chosenTime = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self
        getDataList()
//        https://appleharikyu.jp/iphone/?p=1541
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newTimer = MyTimer()
        newTimer.id = UUID().uuidString
        if let title = titleTextField.text {
            newTimer.title = title
        } else {
            newTimer.title = "名無しのタイマー"
        }
        newTimer.time = chosenTime
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))
        newTimer.date = formatter.string(from: Date())
        
        DatabaseManager.shared.saveTimer(newTimer: newTimer) { [weak self](success) in
            if success {
                self?.showAlert(title: "\(newTimer.title)を登録・セットしました。", message: "")
                UserDefaults.standard.setValue(newTimer.title, forKey: "savedTitle")
                UserDefaults.standard.set(newTimer.time, forKey: "savedTime")
                self?.titleTextField.text = ""
            } else {
                self?.showAlert(title: "エラー", message: "登録できませんでした。")
                return
            }
        }
    }
    
    func formatTime(time: Int)->String{
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func getDataList(){
        for i in 0...600{
            if i % 30 == 0, i != 0 {
                dataList.append(formatTime(time: i))
            }
        }
    }
    
    private func showAlert(title: String, message: String ){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        return
    }
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return String(dataList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let array = dataList[row].components(separatedBy: ":")
        
        if let minute = Int(array[0]), let second = Int(array[1]) {
            let time = minute * 60 + second
            chosenTime = time
        } else {
            print("変換できません")
        }
    }
}
