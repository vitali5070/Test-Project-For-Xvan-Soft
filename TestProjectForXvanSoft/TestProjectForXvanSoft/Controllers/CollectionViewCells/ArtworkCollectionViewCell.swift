//
//  ArtworkCollectionViewCell.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import UIKit

class ArtworkCollectionViewCell: UICollectionViewCell {
    
    public let reuseId: String = "ArtworkCollectionViewCell"
    private var imageView: UIImageView?
    
    public func prepareCell(withSong song: Song) {
        guard let image = UIImage(data: song.imageData ?? Data()) else { return }
        self.imageView = UIImageView(image: image)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.frame = self.contentView.bounds
        guard let imageView = imageView else { return }
        self.contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 10
        let shadowLayer = CALayer()
        shadowLayer.backgroundColor = UIColor(named: "collectionViewCellShadow")?.cgColor
        shadowLayer.frame = CGRect(x: -15, y: 10, width: self.contentView.bounds.width + 30, height: self.contentView.bounds.height - 20)
        shadowLayer.cornerRadius = 10
        shadowLayer.borderWidth = 1
        shadowLayer.borderColor = UIColor(named: "collectionViewCellShadowBorder")?.cgColor
        self.layer.insertSublayer(shadowLayer, below: self.contentView.layer)
        self.clipsToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
    }
    
}
