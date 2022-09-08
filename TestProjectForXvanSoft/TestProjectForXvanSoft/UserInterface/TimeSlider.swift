//
//  TimeSlider.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import UIKit
import AVFAudio

class TimeSlider: UISlider {
    
    private var audioPlayer: AVAudioPlayer?

    init(withPlayer audioPlayer: AVAudioPlayer) {
        super.init(frame: CGRect())
        self.audioPlayer = audioPlayer
        self.maximumValue = Float(audioPlayer.duration)
        self.minimumTrackTintColor = UIColor(named: "minimumTrackTintColorSlider")
        self.maximumTrackTintColor = UIColor(named: "maximumTrackTintColorSlider")
//        self.setThumbImage(UIImage(named: "thumbImage"), for: .normal)
        self.thumbTintColor = UIColor(named: "minimumTrackTintColorSlider")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
