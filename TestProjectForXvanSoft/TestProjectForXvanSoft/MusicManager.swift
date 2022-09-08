//
//  MusicManager.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 5.09.22.
//

import AVFoundation
import UIKit


class MusicManager: UIViewController, AVAudioPlayerDelegate {
    
    public var audioPlayer: AVAudioPlayer?
    private var timeSlider: TimeSlider?
    private var artistLabel: SongLabel?
    private var songLabel: SongLabel?
    private var startTimeLabel: TimeLabel?
    private var endTimeLabel: TimeLabel?
    private var playButton: PlayerButton?
    private var nextButton: PlayerButton?
    private var previousButton: PlayerButton?
    private var songsArray: [Song]?
    private var collectionView: ArtworkCollectionView?
    
    private var currentIndexPath: IndexPath = [0, 0]
    private var isMoveRight: Bool?
    private var lastContentOffset: CGFloat = 0
    
    init(withTimeSlider timeSlider: TimeSlider,
         artistLabel: SongLabel,
         songLabel: SongLabel,
         startTimeLabel: TimeLabel,
         endTimeLabel: TimeLabel,
         audioPlayer: AVAudioPlayer,
         playButton: PlayerButton,
         nextButton: PlayerButton,
         previousButton: PlayerButton,
         songsArray: [Song],
         collectionView: ArtworkCollectionView
    )
    {
        super.init(nibName: nil, bundle: nil)
        self.timeSlider = timeSlider
        self.artistLabel = artistLabel
        self.songLabel = songLabel
        self.startTimeLabel = startTimeLabel
        self.endTimeLabel = endTimeLabel
        self.audioPlayer = audioPlayer
        self.playButton = playButton
        self.nextButton = nextButton
        self.previousButton = previousButton
        self.songsArray = songsArray
        self.collectionView = collectionView
        
        playButton.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousSong), for: .touchUpInside)
        timeSlider.addTarget(self, action: #selector(audioTimeController), for: .valueChanged)
        
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.isPagingEnabled = true
        
        updateView(withSongArray: songsArray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView(withSongArray songs: [Song]) {
        self.audioPlayer?.prepareToPlay()
        let song = songs[currentIndexPath.row]
        self.artistLabel?.text = song.artistName
        self.songLabel?.text = song.songName
        if ((audioPlayer?.isPlaying) != nil) {
            playMusic()
        }
    }
    
    @objc public func playMusic() {
        guard let songs = self.songsArray else { return }
        guard let path = Bundle.main.path(forResource: songs[self.currentIndexPath.row].id,
                                          ofType: songs[self.currentIndexPath.row].type)
        else { return }
        guard let playButton = self.playButton else { return }
        if playButton.isPlayed {
            audioPlayer?.pause()
            self.playButton?.isPlayed = false
        } else {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: path))
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeValue), userInfo: nil, repeats: true)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            self.playButton?.isPlayed = true
        } catch {
            print(error.localizedDescription)
        }
        }
    }
    
    @objc func updateTimeValue(){
        if let currentTime = self.audioPlayer?.currentTime {
            self.timeSlider?.value = Float(currentTime)
        }
        if let duration = self.audioPlayer?.duration {
            self.timeSlider?.maximumValue = Float(duration)
        }
        guard let timeSlider = timeSlider else { return }
        self.startTimeLabel?.text = self.startTimeLabel?.timeString(time: TimeInterval(timeSlider.value))
        self.endTimeLabel?.text = self.endTimeLabel?.timeString(time: TimeInterval(timeSlider.maximumValue - timeSlider.value))
    }
    
    @objc func audioTimeController(){
        guard let timeSlider = timeSlider else {
            return
        }
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(timeSlider.value)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        playButton?.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    @objc public func nextSong() {
        self.collectionView?.isPagingEnabled = false
        guard let songs = songsArray else { return }
        guard let collectionView = collectionView else { return }
        if currentIndexPath.row == songs.count - 1 {
            currentIndexPath.row = 0
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            currentIndexPath.row += 1
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: true)
        }
        self.collectionView?.isPagingEnabled = true
        self.playButton?.isPlayed = false
        updateView(withSongArray: songs)
    }
    
    @objc public func previousSong() {
        self.collectionView?.isPagingEnabled = false
        guard let songs = songsArray else { return }
        guard let collectionView = collectionView else { return }
        if currentIndexPath.row == 0 {
            currentIndexPath.row = songs.count - 1
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            currentIndexPath.row -= 1
            collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: true)
        }
        self.collectionView?.isPagingEnabled = true
        self.playButton?.isPlayed = false
        updateView(withSongArray: songs)
    }
    
}

extension MusicManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
              let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
              dataSourceCount > 0 else {
            return .zero
        }
        
        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width + (itemSpacing * cellCount)
        var insets = flowLayout.sectionInset
        
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        guard totalCellWidth < contentWidth else {
            return insets
        }
        
        let padding = (contentWidth - totalCellWidth) / 7
        insets.left = padding
        insets.right = padding
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset < scrollView.contentOffset.x {
            isMoveRight = true
            lastContentOffset = scrollView.contentOffset.x
        } else {
            isMoveRight = false
            lastContentOffset = scrollView.contentOffset.x
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.x
        guard let isMoveRight = isMoveRight else { return }
        if isMoveRight {
            nextSong()
        } else {
            previousSong()
        }
    }
    
}

extension MusicManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let songs = self.songsArray else { return UICollectionViewCell() }
        let song = songs[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtworkCollectionViewCell().reuseId, for: indexPath) as! ArtworkCollectionViewCell
        
        cell.prepareCell(withSong: song)
        
        return cell
    }
}

