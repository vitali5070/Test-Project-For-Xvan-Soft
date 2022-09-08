//
//  TimeLabel.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import UIKit

class TimeLabel: UILabel {
    
    enum TypeOfTimerLabel {
        case start
        case end
    }
    
    private var start: TimeInterval = 0
    public var end: TimeInterval = 0
    
    init(withTypeOfLabel typeOfLabel: TypeOfTimerLabel) {
        super.init(frame: CGRect())
        self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.textColor = .white
        switch typeOfLabel {
        case .start:
            self.text = timeString(time: self.start)
        case .end:
            self.text = timeString(time: end)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
