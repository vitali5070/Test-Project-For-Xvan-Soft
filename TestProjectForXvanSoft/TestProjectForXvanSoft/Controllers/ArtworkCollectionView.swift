//
//  ArtworkCollectionView.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 6.09.22.
//

import UIKit

class ArtworkCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    private var songs: Array<Song>?
    
    init(withSongs songs: Array<Song>) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 0
        super.init(frame: CGRect(), collectionViewLayout: layout)
        self.songs = songs
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(ArtworkCollectionViewCell.self, forCellWithReuseIdentifier: ArtworkCollectionViewCell().reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
