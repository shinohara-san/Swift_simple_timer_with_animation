//
//  TimerListTableViewCell.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/24.
//

import UIKit

class TimerListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static let identifier = "TimerListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TimerListTableViewCell", bundle: nil)
    }
    
    func configure(with model: MyTimer){
        self.titleLabel.text = model.title
        let minutes = model.time / 60 % 60
        let seconds = model.time % 60
        let shownTime = String(format:"%02i:%02i", minutes, seconds)
        self.timerLabel.text = shownTime
        self.dateLabel.text = model.date
    }
    
}
