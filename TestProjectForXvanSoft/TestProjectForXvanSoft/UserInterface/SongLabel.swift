//
//  SongLabel.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import UIKit

enum TypeOfLabel {
    case song
    case artist
}

class SongLabel: UILabel {
    
    private var typeOfLabel: TypeOfLabel?

    init(withType typeOflabel: TypeOfLabel) {
        super.init(frame: CGRect())
        self.typeOfLabel = typeOflabel
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch self.typeOfLabel {
        case .song:
            self.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            break
        case .artist:
            self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            break
        default:
            break
        }
    }

}
