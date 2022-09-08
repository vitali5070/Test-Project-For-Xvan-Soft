//
//  SongModel.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 3.09.22.
//

import Foundation
import AVFoundation

struct Song {
    var artistName: String?
    var songName: String?
    var imageData: Data?
    var type: String = "mp3"
    var id: String?
    
    init(withBundleID id: String) {
        self.id = id
    }
    
    init() {}
    
    func getSong(fromBundleID id: String) -> Song {
        var song = Song(withBundleID: id)
        guard let path = Bundle.main.path(forResource: song.id,
                                          ofType: song.type)
        else { return Song() }
        let playerItem = AVPlayerItem(url: URL.init(fileURLWithPath: path))
        let metaDataArray = playerItem.asset.metadata as [AVMetadataItem]
        
        for item in metaDataArray {
            if let value = item.value {
                if item.commonKey?.rawValue == "title" {
                    song.songName = value as? String
                }
                if item.commonKey?.rawValue  == "artist" {
                    song.artistName = value as? String
                }
                if item.commonKey?.rawValue  == "artwork" {
                    guard let imageData = item.value as? NSData else { return Song() }
                    song.imageData = Data(imageData)
                }
            }
        }
        return song
    }
}
