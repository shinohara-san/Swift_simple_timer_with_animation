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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self
        getDataList()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //タイトルとタイマー時間と日時をオブジェクトでrealmに保存→ListVCで一覧表示
        if let title = titleTextField.text {
            UserDefaults.standard.setValue(title, forKey: "savedTitle")
        } else {
            UserDefaults.standard.setValue("", forKey: "savedTitle")
        }
    }
    
    func formatTime(time: Int)->String{
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func getDataList(){
        for i in 0...300{
            if i % 10 == 0, i != 0 {
                dataList.append(formatTime(time: i))
            }
        }
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
            UserDefaults.standard.set(time, forKey: "savedTime")
        } else {
            print("変換できません")
        }
    }
}
