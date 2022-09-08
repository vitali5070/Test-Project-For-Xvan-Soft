//
//  PlayerButton.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import UIKit

enum TypeOfButton {
    case playButton
    case previousButton
    case nextButton
}

class PlayerButton: UIButton {
    
    private var typeOfButton: TypeOfButton?
    public var isPlayed: Bool = false
    
    init(withTypeOfButton typeOfButton: TypeOfButton) {
        super.init(frame: CGRect())
        self.typeOfButton = typeOfButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch typeOfButton {
        case .playButton:
            self.layer.cornerRadius = self.frame.height / 2
            self.backgroundColor = UIColor(named: "playButtonBackground")
            guard let imageView = self.imageView else { return }
            imageView.tintColor = .white
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18)
            ])
            if isPlayed {
                self.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            } else {
                self.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            }
            self.contentMode = .center
        case .nextButton:
            self.setImage(UIImage(named: "next"), for: .normal)
        case .previousButton:
            self.setImage(UIImage(named: "previous"), for: .normal)
            
        default:
            break
        }
    }
}
